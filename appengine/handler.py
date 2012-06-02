import json
import logging

from utils import template

from google.appengine.ext import webapp

UNDER_CONSTRUCTION = """This site is currently under construction.
Amble on back when you have a chance and check us out!"""

HOME_TEMPLATE = 'templates/home.html'


class BaseHandler(webapp.RequestHandler):
  """"""

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
