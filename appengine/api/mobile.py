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
    ambler = models.Ambler.get_or_insert(id=user.email())
    ambler.singly_access_token = singly_access_token
    ambler.put()
    if ambler.key:
      self.response.out.write('true')

class RecommendationHandler(webapp.RequestHandler):

  URL_PATH = '/api/mobile/recommend'

  @handler.RequiresOAuth
  def get(self, *args):
    user = oauth.get_current_user()
    ambler = models.Ambler.get_by_id(user.email())
    place = {'lat': 37.7589071,
             'lng': -122.4167398,
             'name': 'Mr. Pickle\'s Coffee Shop',
             'type': 'coffee',
             'cost': 1,
             'why': ['James Meador checked in.', 'Russell Schnookums likes this.']}
    self.response.out.write(json.dumps(place))
