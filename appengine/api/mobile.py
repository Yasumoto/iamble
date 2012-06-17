"""
mobile_endpoint.py

Created by James Meador on 2012-06-02.
Copyright (c) 2012 __MyCompanyName__. All rights reserved.
"""
import json

from google.appengine.api import oauth
from google.appengine.ext import webapp

import handler
from profiles import models
from data import signal

class NewServiceHandler(webapp.RequestHandler):
  
  URL_PATH = '/api/mobile/new_service'

  @handler.RequiresOAuth
  def get(self, *args):
    singly_access_token = self.request.get('singly_access_token')
    user = oauth.get_current_user()
    ambler = models.Ambler.get_or_insert(user.email())
    if singly_access_token:
      ambler.singly_access_token = singly_access_token
      ambler.put()
      self.response.out.write('true')
    else:
      self.response.out.write('false')


class RecommendationHandler(webapp.RequestHandler):

  URL_PATH = '/api/mobile/recommend'

  @handler.RequiresOAuth
  def get(self, *args):
    user = oauth.get_current_user()
    #ambler = models.Ambler.get_by_id(user.email())
    places = []
    """place1 = {'lat': 37.7589071,
              'lng': -122.4167398,
              'name': 'Mr. Pickle\'s Coffee Shop',
              'type': 'coffee',
              'cost': 1,
              'why': ['James Meador checked in.', 'Russell Schnookums likes this.']}
    place2 = {'lat': 38.7589071,
              'lng': -123.4167398,
              'name': 'Fake Place 2',
              'type': 'coffee',
              'cost': 1,
              'why': ['James Meador checked in.', 'Russell Schnookums likes this.']}
    place3 = {'lat': 39.7589071,
              'lng': -121.4167398,
              'name': 'Fake Place 2',
              'type': 'coffee',
              'cost': 1,
              'why': ['James Meador checked in.', 'Russell Schnookums likes this.']}
    
    self.response.out.write(json.dumps([place1,place2,place3]))"""
    suggestion_generator = signal.SignalEngine(user)
    lat = self.request.get('lat')
    lng = self.request.get('lng')
    coordinate = models.Coordinate(lat=float(lat), lng=float(lng))
    top_suggestions = suggestion_generator.SignalMaster('get_top_default', location=coordinate)
    response = []
    for top_suggestion in top_suggestions:
      response.append(
                 {'lat': top_suggestion.lat,
                  'lng': top_suggestion.lng,
                  'name': top_suggestion.name,
                  'type': top_suggestion.food_type,
                  'why': [top_suggestion.why_description1, top_suggestion.why_description2]
                 })
    self.response.out.write(json.dumps(response))
    

