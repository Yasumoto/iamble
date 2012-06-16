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
    place1 = {'lat': 37.7589071,
              'lng': -122.4167398,
              'name': 'Mr. Pickle\'s Sandwich Shop',
              'type': 'quick',
              'cost': 1,
              'why': ['James Meador checked in.', 'Zach Szafran likes this.']}
    place2 = {'lat': 37.777328,
              'lng': -122.40720439,
              'name': 'Extreme Pizza',
              'type': 'quick',
              'cost': 1,
              'why': ['Russ White checked in.', 'Dan White likes this.']}
    place3 = {'lat': 37.870292,
              'lng': -122.283477,
              'name': 'Bangkok Thai Cusine',
              'type': 'quick',
              'cost': 1,
              'why': ['Joe Smith checked in.', 'James Meador likes this.']}
    
    self.response.out.write(json.dumps([place1,place2,place3]))
