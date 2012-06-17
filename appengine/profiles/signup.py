# __author__ = russ@cypht

import logging
import models
import json
import handler

from utils import template
from google.appengine.ext import webapp
from google.appengine.api import users

class SignupHandler(webapp.RequestHandler):
  """Handler for tracking interested users."""
  URL_PATH = '/signup'

  def get(self):
    """Throws action not implimented error for GET requests."""
    self.error(403)
  
  def post(self):
    """Handles posts for data for users showing interest."""
    ret = dict()
    ret['message'] = 'hello world'
    response = json.dumps(ret)
    self.response.out.write(response)
