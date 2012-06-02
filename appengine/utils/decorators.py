#!/usr/bin/env python
# encoding: utf-8
"""
decorators.py

Created by James Meador on 2012-06-02.
Copyright (c) 2012 __MyCompanyName__. All rights reserved.
"""

class Error(Exception):
  pass

class SinglyAccessTokenNotFoundError(Error):
  pass

def RequiresSinglyAccessToken(method):

  def CheckToken(ambler):
    if ambler.singly_access_token:
      return method(ambler)
    raise SinglyAccessTokenNotFoundError

  return CheckToken