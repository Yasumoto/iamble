import utils
from google.appengine.ext import webapp

class DefaultHandler(webapp.RequestHandler):

  def get(self):
    self.response.headers['Content-Type'] = 'text/plain'
    self.response.out.write('This site is currently under construction. Amble on back when you have a chance and check us out!')