# __author__ = russ@iamble

from google.appengine.ext import webapp

class CreateAccountHandler(webapp.RequestHandler):
  """Handler for areating accounts."""
  URL_PATH = '/create_account'
  TEMPLATE = 'templates/create_account.html'

  def get(self):
   """Handles get request for Create Account functions."""
   # Render a blank create account template
   self.response.out.write('create account blank')
  
  def post(self):
    """Handles posts for Account Creation functions."""
    self.response.out.write('create account populated')
    # Drop any passed in data to the form
    # Check for which fields are passed in, parse data and route/throw error depending on what's given.