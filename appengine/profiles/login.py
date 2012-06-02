# __author__ = russ@iamble

import models
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

class LoginHandler(webapp.RequestHandler):
  """Handler for Login page."""
  URL_PATH = '/login'
  UNDER_CONSTRUCTION = """This is the login page."""
  HOME_TEMPLATE = 'templates/login.html'

  def get(self):
    """Handles get request for logins."""
    user = users.get_current_user()
    if user:
      # Check datastore for active account
      ambler = True
      if ambler:
        # Redirect to core site
        template_params = dict()
        template_params['messages'] = list()
        template_params['messages'].append(UNDER_CONSTRUCTION)
        rendered_page = template.render(LOGIN_TEMPLATE, template_params)
        self.response.out.write(str(rendered_page))
      else:
        # Redirect to account creation page
        # Account creation includes all Oauth generation
        pass
    else:
      # Redirect to google sign in page
      pass
  
  def post(self):
    """Handles post for login page."""
    # Handle posted preferences
    pass
