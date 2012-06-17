# __author__ = russ@cypht

import logging
import models
import urllib

from utils import template
from google.appengine.api import users
from google.appengine.ext import webapp

class LoginHandler(webapp.RequestHandler):
  """Handler for Login page."""

  URL_PATH = '/login'

  def get(self):
    """Handles get request for logins."""
    user = users.get_current_user()
    template_params = template.get_params()

    if user:
      ambler = models.Ambler.get_by_id(user.email())
      if ambler:
        if not ambler.first_time:
          # Redirect to core site
          self.redirect('/')
          return
      else:
        ambler = models.Ambler.get_or_insert(user.email())
        ambler.put()
      self.redirect('/oauth')
    else:
      login_url = users.create_login_url(dest_url='/login')
      message = 'Redirecting you to Google for authentication.'
      redirect_url = '/redirect?url=%s&message=%s' % (
          urllib.quote_plus(login_url), message)
      logging.info(redirect_url)
      self.redirect(redirect_url)

  def post(self):
    """Handles post for login page."""
    # We don't handle posted login info. Get off my lawn.
    self.error(404)


class LogoutHandler(webapp.RequestHandler):
  """Handler for Logout page."""

  URL_PATH = '/logout'

  def get(self):
    """Handles get request for logouts."""
    self.redirect(users.create_logout_url(dest_url='/'))

  def post(self):
    """Handles post for logout page."""
    # We don't handle posted logout info. Get off my lawn.
    self.error(404)
