# __author__ = russ@iamble

from profiles import models as profile_models
from google.appengine.ext import ndb


class Source(ndb.Model):
  """Source of signal information."""
  service = ndb.StringProperty()

class Coordinate(ndb.Model):
  """Lat and Long object."""
  lat = ndb.FloatProperty()
  long = ndb.FloatProperty()

class Place(ndb.Model):
  """A spot to go eat."""
  coordinate = ndb.StructuredProperty(Coordinate)
  name = ndb.StringProperty()
  type = ndb.StringProperty(choices=['coffee', 'quick', 'sit-down'])
  cost = ndb.IntegerProperty(choices=[1,2,3,4,5])
  mentions = ndb.IntegerProperty()

class Checkin(ndb.Model):
  """Checkin objects used as signals."""
  source = ndb.KeyProperty(kind=Source)
  who = ndb.KeyProperty(kind=profile_models.Ambler)
  friend = ndb.StringProperty()
  place = ndb.KeyProperty(kind=Place)
  coordinate = ndb.StructuredProperty(Coordinate)  # keep duplicated for speedy index
  when = ndb.DateTimeProperty()
  data = ndb.StringProperty()
  signal_value = ndb.IntegerProperty()


