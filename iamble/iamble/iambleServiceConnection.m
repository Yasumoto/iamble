//
//  iambleServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "iambleServiceConnection.h"

static NSString *const kCyphtClientID = @"307500153747.apps.googleusercontent.com";
static NSString *const kCyphtClientSecret = @"hLPKxTsZv4CepvzERMEL6le7";
static NSString *const kCypht = @"Cypht-app";
static NSString *const kOAuthScope = @"https://cypht-app.appspot.com";
static NSString *const kRequestTokenString = @"https://cypht-app.appspot.com/_ah/OAuthGetRequestToken";
static NSString *const kAuthorizeTokenString = @"https://cypht-app.appspot.com/_ah/OAuthAuthorizeToken";
static NSString *const kAccessTokenString = @"https://cypht-app.appspot.com/_ah/OAuthGetAccessToken";

@interface iambleServiceConnection () <NSURLConnectionDataDelegate>
@end

@implementation iambleServiceConnection
@synthesize auth = _auth;

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
    [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kCypht
                                               authentication:auth];
    if ([auth canAuthorize]){
      self.auth = auth;
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
    self.auth = auth;
    [GTMOAuthViewControllerTouch saveParamsToKeychainForName:kCypht authentication:auth];
  }
}

- (UIViewController *) authorizeAmble {
  GTMOAuthViewControllerTouch *viewController;
  GTMOAuthAuthentication *auth = [self myCustomAuth];
  viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:kOAuthScope
                                                             language:nil
                                                      requestTokenURL:[NSURL URLWithString:kRequestTokenString]
                                                    authorizeTokenURL:[NSURL URLWithString:kAuthorizeTokenString]
                                                       accessTokenURL:[NSURL URLWithString:kAccessTokenString]
                                                       authentication:auth
                                                       appServiceName:kCypht
                                                             delegate:self
                                                     finishedSelector:@selector(viewController:finishedWithAuth:error:)];
  [viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://cypht-app.appspot.com"]];
  
  return viewController;
}

- (GTMOAuthAuthentication *)myCustomAuth {
  GTMOAuthAuthentication *auth = [[GTMOAuthAuthentication alloc]
                                  initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                  consumerKey:kCyphtClientID
                                  privateKey:kCyphtClientSecret];
  auth.serviceProvider = @"Custom Auth Service";
  [auth setCallback:@"http://cypht-app.appspot.com/_my_callback"];
  return auth;
}

@end
