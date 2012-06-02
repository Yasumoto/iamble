# __author__ = russ@iamble

from profiles import models as profile_models
from google.appengine.ext import ndb


class Place(ndb.Model):
  """A spot to go eat."""
  coordinate = ndb.StructuredProperty(profile_models.Coordinate)
  name = ndb.StringProperty()
  type = ndb.StringProperty(choices=['coffee', 'quick', 'sit-down'])
  cost = ndb.IntegerProperty(choices=[1,2,3,4,5])
  mentions = ndb.IntegerProperty()
  
  def AddCheckin(self):
    """Adds a child checkin object to the parent Place."""
    pass
    # Calculate signal change for Place based on checkin value

class Place(ndb.Model):
  """A spot to go eat."""
  coordinate = ndb.StructuredProperty(profile_models.Coordinate)
  name = ndb.StringProperty()
  type = ndb.StringProperty(choices=['coffee', 'quick', 'sit-down'])
  cost = ndb.IntegerProperty(choices=[1,2,3,4,5])
  mentions = ndb.IntegerProperty()

class Checkin(ndb.Model):
  """Checkin objects used as signals. Child of Place."""
  source = ndb.KeyProperty(kind=profile_models.Source)
  who = ndb.KeyProperty(kind=profile_models.Ambler)
  friend = ndb.StringProperty()
  coordinate = ndb.StructuredProperty(profile_models.Coordinate)  # keep duplicated for speedy index
  when = ndb.DateTimeProperty()
  data = ndb.StringProperty()
  signal_value = ndb.IntegerProperty()
