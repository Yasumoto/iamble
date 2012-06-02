import logging
import os

from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

UNDER_CONSTRUCTION = """This site is currently under construction.
Amble on back when you have a chance and check us out!"""

HOME_TEMPLATE = 'templates/home.html'

CURRENT_VERSION_ID = 'CURRENT_VERSION_ID'


class BaseHandler(webapp.RequestHandler):
  """"""

  def get(self):
    """"""
    template_params = dict()
    template_params['app_version'] = os.environ[CURRENT_VERSION_ID]
    template_params['info_messages'] = list()
    template_params['success_messages'] = list()
    template_params['warning_messages'] = list()
    template_params['error_messages'] = list()

    template_params['warning_messages'].append(UNDER_CONSTRUCTION)
    rendered_page = template.render(HOME_TEMPLATE, template_params)
    self.response.out.write(str(rendered_page))
