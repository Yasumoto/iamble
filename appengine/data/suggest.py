# __author__ = russ@iamble

import constants
import json
from profiles import models
import datetime
from data import data_utils
from data import data_models

def GenerateSuggestions(ambler, location,  suggestions=10):
  """Generates a list of top suggestions for the given ambler."""
  rated_places = {}  # {rating_int: cached_place_object,}
  local_places = data_utils.GetPlacesInArea(
      location.lat, location.lng, constants.DISTANCE_MAPPING[ambler.distance])
  for place in json.loads(local_places)['results']:
    temp_place = {}
    temp_place['lat'] = place['geometry']['location']['lat']
    temp_place['lng'] = place['geometry']['location']['lng']
    temp_place['name'] = place['name']
    temp_place['food_type'] = _GetGooglePlaceFoodType(place)
    temp_place['cost'] = constants.COST_MAPPING[temp_place['food_type']]
    temp_place['why_description1'] = 'This place is close!'
    temp_place['why_description2'] = 'This place has a good rating of %s!' % place['rating']
    temp_place['cache_timestamp'] = datetime.datetime.now()
    temp_place['rating'] = place['rating']
    stored_checkins = data_models.Checkin.query()
    stored_checkins = stored_checkins.filter(data_models.Checkin.who == ambler.key)
    stored_checkins = stored_checkins.filter(data_models.Checkin.coordinate.lat == temp_place['lat'])
    stored_checkins = stored_checkins.filter(data_models.Checkin.coordinate.lng == temp_place['lng'])
    stored_checkins = stored_checkins.fetch() 
    if stored_checkins:
      for checkin in stored_checkins:
        if checkin.mentions:
          temp_place['rating'] += (checkin.mentions * constants.MENTION_WEIGNT)
        if checkin.likes:
          temp_place['rating'] += (checkin.likes * constants.LIKE_WEIGHT)
    # check ambler recent likes and dislikes
    # weight based on distance
    if ambler.budget:
      if temp_place['cost'] == ambler.budget:
        temp_place['rating'] += constants.PREFERENCE_MATCH_WEIGHT
    rated_places[temp_place['rating']] = temp_place
    return_list = [rated_places[key] for key in sorted(rated_places.iterkeys())]
    return return_list[:suggestions]


def _GetGooglePlaceFoodType(place):
  """Parses a google place to find the food type."""
  for quick_string in constants.QUICK_STRINGS:
    if quick_string in [i.lower() for i in place['name'].split()]:
      return 'quick'
  for sit_down_string in constants.SIT_DOWN_STRINGS:
    if sit_down_string in [i.lower() for i in place['name'].split()]:
      return 'sit-down'
  for coffee_string in constants.COFFEE_STRINGS:
    if coffee_string in [i.lower() for i in place['name'].split()]:
      return 'coffee'
  return 'default'
