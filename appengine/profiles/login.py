# __author__ = russ@iamble

import models
<<<<<<< HEAD
import handler
from utils.template import render_template
=======
from utils import template
>>>>>>> added landing page.
from google.appengine.api import users
from google.appengine.ext import webapp

class LoginHandler(webapp.RequestHandler):
  """Handler for Login page."""
  URL_PATH = '/login'
  LOGIN_TEMPLATE = 'templates/login.html'

  def get(self):
    """Handles get request for logins."""
    user = users.get_current_user()
    template_params = template.get_params()

    if user:
      ambler = models.Ambler.get_by_id(user.email())
      if ambler:
        # Redirect to core site
        template_params['messages'].append('You are logged in.')
      else:
        self.redirect('/create_account?user=%s' % user.email()) #needs an escape
        # Account creation includes all Oauth generation
    else:
      redirect_url = users.create_login_url(dest_url='/login')
      self.redirect(redirect_url)
    template.render_template(self, self.LOGIN_TEMPLATE, template_params)

  def post(self):
    """Handles post for login page."""
    # We don't handle posted login info. Get off my lawn.
    self.error(404)
