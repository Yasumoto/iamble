# __author__ = russ@iamble

import models
import handler
from utils.template import render_template
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

class LoginHandler(webapp.RequestHandler):
  """Handler for Login page."""
  URL_PATH = '/login'
  LOGIN_TEMPLATE = 'templates/login.html'

  def get(self):
    """Handles get request for logins."""
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_by_id(user.email())
      if ambler:
        self.redirect('/iamble')
      else: 
        self.redirect('/create_account?user=%s' % user.email())
    else:  # If not authenticated, redirect to Google login page
      redirect_url = users.create_login_url(dest_url='/login')
      self.redirect(redirect_url)
  
  def post(self):
    """Handles post for login page."""
    # We don't handle posted login info. Get off my lawn.
    self.error(404)
