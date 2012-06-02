import logging

from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

UNDER_CONSTRUCTION = """This is OAuth2. Start handshaking!"""

HOME_TEMPLATE = 'templates/home.html'


class OAuth2Handler(webapp.RequestHandler):
  """"""
  URL_PATH = '/oauth'

  def get(self):
    """"""
    template_params = dict()
    template_params['messages'] = list()
    template_params['messages'].append(UNDER_CONSTRUCTION)
    rendered_page = template.render(HOME_TEMPLATE, template_params)
    self.response.out.write(str(rendered_page))
