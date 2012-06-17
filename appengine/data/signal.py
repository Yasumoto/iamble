# __author__ = russ@iamble

import constants
import caches
import data_models
import data_utils
import datetime
import logging
import handler
import json
import suggest
from data import data_utils
from profiles import models as profile_models
from google.appengine.api import users
from utils import decorators


class SignalEngine(object):
  """Generates signals based on input I'll fill in later."""

  def __init__(self, ambler):
    """Initializes a signal generation object"""
    # Gather ambler stats before any data is aggregated
    self.ambler = profile_models.Ambler.get_by_id(ambler.email())

  def SignalMaster(self, call_type, location=None):
    """Master function to govern data collection, parsing, and return."""
    if call_type == 'get_top_default':
      top_suggestion = caches.GetPersistentCache(self.ambler, 1)
      if not top_suggestion:
        return self.FullDataProcess()
      else:
        return top_suggestion
    elif call_type == 'get_top_dynamic':
      return self.FindDynamicSuggestions(location)
    elif call_type == 'first_login' or 'cron':
      return self.FullDataProcess()

  def FindDynamicSuggestions(self, location):
    """Find suggestions based on your current location."""
    return 'Dynamic location place response!'

  def FullDataProcess(self):
    """Fires a full data collection and parse process."""
    try:
      json_checkins = data_utils.GetCheckinsForUser(self.ambler)
    except decorators.SinglyAccessTokenNotFoundError:
      # provide some default crap
      json_checkins = []
    self.ProcessCheckins(json_checkins)
    suggestions = suggest.GenerateSuggestions(self.ambler, self.ambler.default_location)
    logging.info(suggestions)
    caches.SetPersistentCache(self.ambler, suggestions)
    top_suggestion = caches.GetPersistentCache(self.ambler, 1)
    return top_suggestion

  def ProcessCheckins(self, json_checkins):
    """Does a massive data gather on all activated services."""
    parsed_signal = {}
    for checkin in json_checkins:
      try:
        source = checkin['oembed']['provider_name']
      except KeyError:
        logging.info('missed on fb and 4s for %s', checkin)
        source = None
      if source == 'facebook':
        lat = checkin['oembed']['lat']
        lng = checkin['oembed']['lng']
        name = checkin['oembed']['title']
        google_signal = json.loads(data_utils.GetGooglePlace(lat, lng, name))
        if not google_signal['status'] == 'ZERO_RESULTS':
          parsed_signal = self.ParseFacebookJSON(google_signal, checkin)
      elif source == 'foursquare':
        parents = None
        try:
          parents = checkin['data']['categories']['parents']
        except KeyError:
          logging.info('found a 4s error parsing parents out')
        if not parents:
          try:
            parents = checkin['venue']['categories'][0]['parents']
          except KeyError:
            break
        if constants.FOURSQUARE_FOOD_PARENT in [i.lower() for i in parents]:
          parsed_signal = self.ParseFoursquareJSON(signal)
      if parsed_signal:
        place = self.FindPlace(parsed_signal)
        signal_object = self.CheckForDuplicateCheckin(parsed_signal, place)
        if not signal_object:
          self.AddCheckinToPlace(parsed_signal, place)

  def FindPlace(self, parsed_signal):
    """Associates a possible place with a passed in signal."""
    place = data_models.Place.query()
    place = place.filter(data_models.Place.coordinate.lat == parsed_signal['lat'])
    place = place.filter(data_models.Place.coordinate.lng == parsed_signal['lng'])
    place = place.filter(data_models.Place.name == parsed_signal['name'])
    place = place.get()
    if not place:
      place = self.InsertNewPlace(parsed_signal).get()
    return place

  def InsertNewPlace(self, parsed_signal):
    """Adds a place we haven't seen before to datastore."""
    new_place_coordinate = profile_models.Coordinate()
    new_place_coordinate.lat = parsed_signal['lat']
    new_place_coordinate.lng = parsed_signal['lng']
    new_place = data_models.Place()
    new_place.coordinate = new_place_coordinate
    new_place.name = parsed_signal['name']
    new_place.address = parsed_signal['address']
    new_place.city = parsed_signal['city']
    new_place.state = parsed_signal['state']
    new_place.type = parsed_signal['type']
    new_place.friend = parsed_signal['friend']
    new_place.mentions = parsed_signal['mentions']
    return new_place.put()

  def CheckForDuplicateCheckin(self, parsed_signal, place):
    """Check for duplicate checkins."""
    duplicate = data_models.Checkin.query(ancestor=place.key)
    duplicate = duplicate.filter(data_models.Checkin.who == self.ambler.key)
    duplicate = duplicate.filter(data_models.Checkin.friend == parsed_signal['friend'])
    duplicate = duplicate.filter(data_models.Checkin.coordinate.lat == parsed_signal['lat'])
    duplicate = duplicate.filter(data_models.Checkin.coordinate.lng == parsed_signal['lng'])
    return duplicate.get()

  def AddCheckinToPlace(self, parsed_signal, place):
    """Adds a child checkin object to a place entity."""
    new_checkin_coordinate = profile_models.Coordinate()
    new_checkin_coordinate.lat = parsed_signal['lat']
    new_checkin_coordinate.lng = parsed_signal['lng']
    new_checkin = data_models.Checkin(parent=place.key)
    new_checkin.who = self.ambler.key
    new_checkin.friend = parsed_signal['friend']
    new_checkin.coordinate = new_checkin_coordinate
    new_checkin.when = parsed_signal['when']
    new_checkin.data = parsed_signal['data']
    new_checkin.put()

  def ParseFoursquareJSON(self, signal):
    """Parses an input JSON signal from Foursquare."""
    parsed_signal = dict()
    parsed_signal['name'] = signal['data']['venue']['name']
    parsed_signal['lat'] = signal['data']['location']['lat']
    parsed_signal['lng'] = signal['data']['location']['lng']
    parsed_signal['address'] = signal['data']['location']['address']
    parsed_signal['city'] = signal['data']['location']['city']
    parsed_signal['state'] = signal['data']['location']['state']
    parsed_signal['type'] = self._DetermineType(signal)
    parsed_signal['friend'] = '%s %s' % (signal['data']['user']['firstName'], signal['data']['user']['lastName'])
    parsed_signal['mentions'] = signal['data']['venue']['stats']
    parsed_signal['when'] = datetime.datetime.fromtimestamp(signal['data']['createdAt'])
    parsed_signal['data'] = signal['data']['user']['trips']
    return parsed_signal
  
  def ParseFacebookJSON(self, google_signal, signal):
    """Parses an input JSON signal from Facebook."""
    logging.info('Google signal: %s', google_signal)
    logging.info('Facebook signal: %s', signal)
    parsed_signal = dict() # these are all wrong
    parsed_signal['name'] = signal['oembed']['title']
    parsed_signal['lat'] = signal['oembed']['lat']
    parsed_signal['lng'] = signal['oembed']['lng']
    parsed_signal['address'] = google_signal['results'][0]['vicinity'].split(',')[0]
    parsed_signal['city'] = signal['data']['place']['location']['city']
    parsed_signal['state'] = signal['data']['place']['location']['state']
    parsed_signal['type'] = self._FacebookDetermineType(signal)
    parsed_signal['friend'] = signal['oembed']['author_name']
    parsed_signal['mentions'] = 0
    logging.info('datetime throwing error %s', signal['at'])
    parsed_signal['when'] = datetime.datetime.fromtimestamp((signal['at']/1000))
    parsed_signal['data'] = signal['data'].get('message', '')
    try:
      parsed_signal['likes'] = signal['data']['likes']['count']
    except KeyError:
      parsed_signal['likes'] = 0
    return parsed_signal

  def _FoursquareDetermineType(self, signal):
    """Determines the signal type using our nifty constants for Foursquare."""
    for quick_string in constants.QUICK_STRINGS:
      if quick_string in [i.lower() for i in signal['data']['categories']['name'].split()]:
        return 'quick'
    for sit_down_string in constants.SIT_DOWN_STRINGS:
      if sit_down_string in [i.lower() for i in signal['data']['categories']['name'].split()]:
        return 'sit-down'
    for coffee_string in constants.COFFEE_STRINGS:
      if coffee_string in [i.lower() for i in signal['data']['categories']['name'].split()]:
        return 'coffee'
    return 'default'
    
  def _FacebookDetermineType(self, signal):
    """Determines the signal type using our nifty constants for Facebook."""
    for quick_string in constants.QUICK_STRINGS:
      if quick_string in [i.lower() for i in signal['oembed']['title'].split()]:
        return 'quick'
    for sit_down_string in constants.SIT_DOWN_STRINGS:
      if sit_down_string in [i.lower() for i in signal['oembed']['title'].split()]:
        return 'sit-down'
    for coffee_string in constants.COFFEE_STRINGS:
      if coffee_string in [i.lower() for i in signal['oembed']['title'].split()]:
        return 'coffee'
    return 'default'
