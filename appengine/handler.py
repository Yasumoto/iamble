import logging
import os

from google.appengine.api import users
from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

import config

UNDER_CONSTRUCTION = """This site is currently under construction.
Amble on back when you have a chance and check us out!"""

HOME_TEMPLATE = 'templates/home.html'

CURRENT_VERSION_ID = 'CURRENT_VERSION_ID'

def RequiresLogin(handler_method):

  def CheckLogin(self, *args):
    if users.get_current_user():
      return handler_method(self, *args)
    self.redirect(config.LOGIN_URL)

  return CheckLogin

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
