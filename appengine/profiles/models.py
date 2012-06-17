# __author__ = russ@cypht

import logging
import urllib
import json

from google.appengine.api import urlfetch
from google.appengine.api import users
from google.appengine.ext import ndb

import config
from utils import singly_utils


class InterestedUsers(ndb.Model):
  """Users signed up to get notified on launch date."""
  email = ndb.StringProperty()


class Source(ndb.Model):
  """Source of signal information."""
  service = ndb.StringProperty()


class Coordinate(ndb.Model):
  """Lat and Long object."""
  lat = ndb.FloatProperty()
  lng = ndb.FloatProperty()


class CachedPlace(ndb.Model):
  """A cached place an ambler might like."""
  lat = ndb.FloatProperty()
  lng = ndb.FloatProperty()
  name = ndb.StringProperty()
  food_type = ndb.StringProperty(choices=['coffee', 'quick', 'sit-down', 'default'])
  cost = ndb.IntegerProperty()
  address = ndb.StringProperty()
  why_description1 = ndb.StringProperty()
  why_description2 = ndb.StringProperty()
  cache_timestamp = ndb.DateTimeProperty(auto_now=True)


class Ambler(ndb.Model):
  """An cypht user.
    id: user.User.email()
  """
  user = ndb.UserProperty()
  activated_services = ndb.KeyProperty(kind=Source)
  name_first = ndb.StringProperty()
  name_last = ndb.StringProperty()
  singly_id = ndb.StringProperty()
  singly_access_token = ndb.StringProperty()
  default_location = ndb.StructuredProperty(Coordinate)
  default_address = ndb.StringProperty()
  persistent_suggestion_cache = ndb.StructuredProperty(CachedPlace, repeated=True)
  first_time = ndb.BooleanProperty(default=True)
  budget = ndb.FloatProperty(default=20.00)
  distance = ndb.StringProperty(default='walk')
  recent_likes = ndb.StringProperty(repeated=True)
  recent_dislikes = ndb.StringProperty(repeated=True)

  def GetActiveServices(self):
    if self.singly_access_token:
      url = config.SINGLY_API_PROFILES
      params = {'access_token': self.singly_access_token}
      status_code, result_object = singly_utils.SinglyGET(config.SINGLY_API_PROFILES, params)
      if status_code == 200:
        if not self.singly_id:
          self.singly_id = result_object['id']
          self.put()
        del result_object['id']
        return result_object.keys()
    return []

  def GetProfileServiceData(self, service=None, data=False, fields=None):
    if self.singly_access_token:
      url = config.SINGLY_API_PROFILES
      params = {'access_token': self.singly_access_token}

      if service:
        url + '/%s' % service

      if data:
        params['data'] = 'true'

      if fields:
        params['fields'] = ','.join(fields)

      logging.info(params)

      status_code, result_object = singly_utils.SinglyGET(url, params)
      if status_code == 200:
        return result_object
    return None
