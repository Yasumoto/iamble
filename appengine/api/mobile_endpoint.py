#!/usr/bin/env python
# encoding: utf-8
"""
mobile_endpoint.py

Created by James Meador on 2012-06-02.
Copyright (c) 2012 __MyCompanyName__. All rights reserved.
"""
from google.appengine.ext import webapp

import handler

class MobileHandler(webapp.RequestHandler):
  
  URL_PATH = '/api/mobile'

  @handler.RequiresOAuth
  def get(self):
    self.response.out.write('YAAAAAY')

