import json
import logging


from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

HOME_TEMPLATE = 'templates/home.html'

class BaseHandler(webapp.RequestHandler):
  """"""

  def get(self):
    """"""
    rendered_template = template.render(HOME_TEMPLATE, {})
    self.response.out.write(str(rendered_template))

  def post(self):
    """"""
    self.response.out.write(response)
