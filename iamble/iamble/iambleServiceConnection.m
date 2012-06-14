//
//  iambleServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "iambleServiceConnection.h"

static NSString *const kAmbleClientID = @"307500153747.apps.googleusercontent.com";
static NSString *const kAmbleClientSecret = @"hLPKxTsZv4CepvzERMEL6le7";
static NSString *const kAmble = @"Amble";
static NSString *const kOAuthScope = @"https://ambleapp.appspot.com";
static NSString *const kRequestTokenString = @"https://ambleapp.appspot.com/_ah/OAuthGetRequestToken";
static NSString *const kAuthorizeTokenString = @"https://ambleapp.appspot.com/_ah/OAuthAuthorizeToken";
static NSString *const kAccessTokenString = @"https://ambleapp.appspot.com/_ah/OAuthGetAccessToken";

@interface iambleServiceConnection () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *service;
@end

@implementation iambleServiceConnection
@synthesize authenticated = _authenticated;
@synthesize auth = _auth;
@synthesize delegate = _delegate;
@synthesize service = _service;

- (id) init {
  self = [super init];
  if (self) {
    [self setupAuth];
    }
  return self;
}

- (void) setupAuth {
  // Get the saved authentication, if any, from the keychain.
  GTMOAuthAuthentication *auth = [self myCustomAuth];
  if (auth) {
    // if the auth object contains an access token, didAuth is now true
    [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kAmble
                                               authentication:auth];
    if ([auth canAuthorize]){
      self.auth = auth;
      self.authenticated = YES;
      NSLog(@"iAmble has been rampaged.");
    }
  }
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
{
  if (error != nil)
  {
    // Authentication failed
    /*UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Authorization Failed"
     message:[error localizedDescription]
     delegate:self
     cancelButtonTitle:@"Dismiss"
     otherButtonTitles:nil];*/
    //[alertView show];
  }
  else
  {
    // Authentication succeeded
    self.authenticated = YES;
    self.auth = auth;
    [GTMOAuthViewControllerTouch saveParamsToKeychainForName:kAmble authentication:auth];
    [self.delegate connectedToAmble:self.service];
  }
}

- (UIViewController *) authorizeAmble:(NSString *)service {
  self.service = service;
  GTMOAuthViewControllerTouch *viewController;
  GTMOAuthAuthentication *auth = [self myCustomAuth];
  viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:kOAuthScope
                                                             language:nil
                                                      requestTokenURL:[NSURL URLWithString:kRequestTokenString]
                                                    authorizeTokenURL:[NSURL URLWithString:kAuthorizeTokenString]
                                                       accessTokenURL:[NSURL URLWithString:kAccessTokenString]
                                                       authentication:auth
                                                       appServiceName:kAmble
                                                             delegate:self
                                                     finishedSelector:@selector(viewController:finishedWithAuth:error:)];
  [viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://ambleapp.appspot.com"]];
  
  return viewController;
}

- (GTMOAuthAuthentication *)myCustomAuth {
  GTMOAuthAuthentication *auth = [[GTMOAuthAuthentication alloc]
                                  initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                  consumerKey:kAmbleClientID
                                  privateKey:kAmbleClientSecret];
  auth.serviceProvider = @"Custom Auth Service";
  [auth setCallback:@"http://ambleapp.appspot.com/_my_callback"];
  return auth;
}

@end
