import utils

from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

UNDER_CONSTRUCTION = """'This site is currently under construction.
Amble on back when you have a chance and check us out!'"""

HOME_TEMPLATE = 'templates/home.html'

class DefaultHandler(webapp.RequestHandler):

  def get(self):
    template_params = dict()
    template_params['messages'] = list()
    template_params['messages'].append(UNDER_CONSTRUCTION)
    self.response.out.write(template.render(HOME_TEMPLATE, template_params))
