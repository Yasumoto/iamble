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
    ambler = models.Ambler.get_by_id(user.email())
    places = []
    place1 = {'lat': 37.7589071,
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
    
    self.response.out.write(json.dumps([place1,place2,place3]))

