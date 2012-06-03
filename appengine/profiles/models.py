# __author__ = russ@iamble

import logging
import urllib
import json

from google.appengine.api import urlfetch
from google.appengine.api import users
from google.appengine.ext import ndb

import config
from utils import singly_utils

class Preference(ndb.Model):
  """An iAmble preference."""
  name = ndb.StringProperty()
  value = ndb.StringProperty()


class Source(ndb.Model):
  """Source of signal information."""
  service = ndb.StringProperty()


class Coordinate(ndb.Model):
  """Lat and Long object."""
  lat = ndb.FloatProperty()
  long = ndb.FloatProperty()


class CachedPlace(ndb.Model):
  """A cached place an ambler might like."""
  coordinate = ndb.StructuredProperty(Coordinate)
  name = ndb.StringProperty()
  type = ndb.StringProperty(choices=['coffee', 'quick', 'sit-down'])
  cost = ndb.IntegerProperty(choices=[1,2,3,4,5])
  why = ndb.StringProperty()  # Description of why you'll like this spot.
  cache_date = ndb.DateTimeProperty()


class Ambler(ndb.Model):
  """An iAmble user.
    id: user.User.email()
  """
  user = ndb.UserProperty()
  activated_services = ndb.KeyProperty(kind=Source)
  name_first = ndb.StringProperty()
  name_last = ndb.StringProperty()
  singly_id = ndb.StringProperty()
  singly_access_token = ndb.StringProperty()
  preferences = ndb.StructuredProperty(Preference, repeated=True)
  default_location = ndb.StructuredProperty(Coordinate)
  persistent_suggestion_cache = ndb.StructuredProperty(CachedPlace)
  setup = ndb.BooleanProperty(default=False)

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

  def GetProfileServiceData(self, service):
    if self.singly_access_token:
      url = config.SINGLY_API_PROFILES + '/%s' % service
      params = {'access_token': self.singly_access_token}
      status_code, result_object = singly_utils.SinglyGET(url, params)
      if status_code == 200:
        return result_object
    return None
