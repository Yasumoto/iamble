import json
import logging

from utils import template

from google.appengine.api import users
from google.appengine.ext import webapp

import config

UNDER_CONSTRUCTION = """This site is currently under construction.
Amble on back when you have a chance and check us out!"""

HOME_TEMPLATE = 'templates/home.html'


def RequiresLogin(handler_method):

  def CheckLogin(self, *args):
    if users.get_current_user():
      return handler_method(self, *args)
    self.redirect(config.LOGIN_URL)

  return CheckLogin


class BaseHandler(webapp.RequestHandler):
  """"""

  @RequiresLogin
  def get(self):
    """"""
    template_params = template.get_params()
    template_params['warning_messages'].append(UNDER_CONSTRUCTION)

    template.render_template(self, HOME_TEMPLATE, template_params)

  def post(self):
    ret = dict()
    ret['message'] = 'hello world'
    response = json.dumps(ret)
    self.response.out.write(response)
