"""
data_utils.py

Processes data from Singly into datastore.
"""

import logging
import urllib

from google.appengine.api import urlfetch

import config
import data_models
from profiles import models
from utils import singly_utils
from utils import decorators

@decorators.RequiresSinglyAccessToken
def GetCheckinsForUser(ambler):
  """Gets all Singly checkins for an Ambler.
  
  Args:
    ambler: models.Ambler.
  """
  status_code, json_object = singly_utils.SinglyGetCheckinsFeed(ambler)
  return json_object

def GetGooglePlace(lat, lng, name):
  coordinate = '%s,%s' % (lat, lng)
  name = name
  types = 'food|restaurant'
  query_params = {
      'key': config.GOOGLE_API_KEY,
      'location': coordinate,
      'radius': 25,
      'name': name,
      'types': types,
      'sensor': 'true'}
  params = urllib.urlencode(query_params)
  get_url = '%s?%s' % (config.GOOGLE_PLACES_API, params)
  result = urlfetch.fetch(get_url)
  logging.info(params)
  logging.info(result.status_code)
  return result.content