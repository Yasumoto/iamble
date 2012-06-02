# __author__ = russ@iamble

import models
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
    template_params = dict()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_by_id(user.email())
      if ambler:
        # Redirect to core site
        template_params['messages'] = list()
        template_params['messages'].append('You are logged in.')
      else:
        self.redirect('/create_account?user=%s' % user.email()) #needs an escape
        # Account creation includes all Oauth generation
    else:
      # Redirect to google sign in page
      template_params['messages'] = list()
      template_params['messages'].append('google sign in page redirect here')
      pass
    render_template(self, self.LOGIN_TEMPLATE, template_params)
  
  def post(self):
    """Handles post for login page."""
    # Handle posted preferences
    pass
