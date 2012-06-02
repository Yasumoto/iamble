# __author__ = russ@iamble

import logging
import urllib
import json

from google.appengine.api import urlfetch
from google.appengine.api import users
from google.appengine.ext import ndb

import config

class Preference(ndb.Model):
  """An iAmble preference."""
  name = ndb.StringProperty()
  value = ndb.StringProperty()


class Ambler(ndb.Model):
  """An iAmble user.
    id: user.User.email()
  """
  user = ndb.UserProperty()
  name_first = ndb.StringProperty()
  name_last = ndb.StringProperty()
  singly_id = ndb.StringProperty()
  singly_access_token = ndb.StringProperty()
  preferences = ndb.StructuredProperty(Preference, repeated=True)

  def GetActiveServices(self):
    if self.singly_access_token:
      url = config.SINGLY_API_PROFILES
      params = {'access_token': self.singly_access_token}
      url_params = urllib.urlencode(params)
      logging.info(url_params)
      url = '%s?%s' % (config.SINGLY_API_PROFILES, url_params)
      logging.info(url)
      response = urlfetch.fetch(url=url, method=urlfetch.GET)
      logging.info('RESPONSE: %s', response.status_code)
      if response.status_code == 200:
        result_object = json.loads(response.content)
        self.singly_id = self.singly_id or result_object['id']
        del result_object['id']
        return result_object.keys()
    return []
