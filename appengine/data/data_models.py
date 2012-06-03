# __author__ = russ@iamble

from profiles import models as profile_models
from google.appengine.ext import ndb


class Place(ndb.Model):
  """A spot to go eat."""
  coordinate = ndb.StructuredProperty(profile_models.Coordinate)
  name = ndb.StringProperty()
  address = ndb.StringProperty()
  city = ndb.StringProperty()
  state = ndb.StringProperty()
  type = ndb.StringProperty(choices=['coffee', 'quick', 'sit-down', 'default'])
  mentions = ndb.IntegerProperty()


class Checkin(ndb.Model):
  """Checkin objects used as signals. Child of Place."""
  who = ndb.KeyProperty(kind=profile_models.Ambler)
  friend = ndb.StringProperty()
  coordinate = ndb.StructuredProperty(profile_models.Coordinate)  # keep duplicated for speedy index
  when = ndb.DateTimeProperty()
  data = ndb.StringProperty()
  likes = ndb.IntegerProperty()
