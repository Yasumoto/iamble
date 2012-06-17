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
from data import signal_handler, constants

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
    suggestion_generator = signal.SignalEngine(user)
    lat = self.request.get('lat')
    lng = self.request.get('lng')
    coordinate = models.Coordinate(lat=float(lat), lng=float(lng))
    suggestions = signal_handler.RouteRequest(
        constants.GET_DEFAULT,
        user=user,
        location=coordinate)
    #TODO(russw): update the recent_suggestions ambler property (parse output below)
    #ambler.recent_suggestions.extend(suggestions)
    #ambler.put()
    self.response.out.write(json.dumps(suggestions))
