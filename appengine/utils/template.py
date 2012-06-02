import os

from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

CURRENT_VERSION_ID = 'CURRENT_VERSION_ID'


def render_template(handler, template_path, template_params):
  rendered_page = template.render(template_path, template_params)
  handler.response.out.write(str(rendered_page))


def get_params():
  template_params = dict()
  template_params['app_version'] = os.environ[CURRENT_VERSION_ID]
  template_params['info_messages'] = list()
  template_params['success_messages'] = list()
  template_params['warning_messages'] = list()
  template_params['error_messages'] = list()
  return template_params
