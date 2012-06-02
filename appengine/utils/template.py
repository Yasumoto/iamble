from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

def render_template(handler, template_path, template_params):
  rendered_page = template.render(template_path, template_params)
  handler.response.out.write(str(rendered_page))