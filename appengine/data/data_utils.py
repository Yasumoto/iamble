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
  types = 'cafe|bakery|meal_delivery|meal_takeaway|food|restaurant'
  
  logging.warning('AAAH:%s|%s|%s|%s', config.GOOGLE_API_KEY, coordinate, name, types)
  query_params = {
      'key': config.GOOGLE_API_KEY,
      'location': coordinate,
      'radius': 25,
      'name': name.decode('utf-8'),
      'types': types,
      'sensor': 'true'}
  params = urllib.urlencode(query_params)
  get_url = '%s?%s' % (config.GOOGLE_PLACES_API, params)
  result = urlfetch.fetch(get_url)
  logging.info(params)
  logging.info(result.status_code)
  return result.content

def GetPlacesInArea(lat, lng, miles):
  coordinate = '%s,%s' % (lat, lng)
  meters = miles * 1609.344
  types = 'cafe|bakery|meal_delivery|meal_takeaway|food|restaurant'
  query_params = {
      'key': config.GOOGLE_API_KEY,
      'location': coordinate,
      'radius': meters,
      'types': types,
      'sensor': 'true'}
  params = urllib.urlencode(query_params)
  get_url = '%s?%s' % (config.GOOGLE_PLACES_API, params)
  result = urlfetch.fetch(get_url)
  logging.info(params)
  logging.info(result.status_code)
  return result.content
