# __author__ = russ@iamble

from google.appengine.ext import ndb


class Preference(ndb.Model):
  """An iAmble preference."""
  name = ndb.StringProperty()
  value = ndb.StringProperty()


class Ambler(ndb.Model):
  """An iAmble user.
    id: user.User.email()
  """
  user = ndb.UserProperty()
  facebook_key = ndb.StringProperty()
  twitter_key = ndb.StringProperty()
  preferences = ndb.StructuredProperty(Preference, repeated=True)
