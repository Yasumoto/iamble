//
//  iambleServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "iambleServiceConnection.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

static NSString *const kAmbleClientID = @"307500153747.apps.googleusercontent.com";
static NSString *const kAmbleClientSecret = @"hLPKxTsZv4CepvzERMEL6le7";
static NSString *const kAmble = @"Amble";
static NSString *const kOAuthScope = @"https://ambleapp.appspot.com";
static NSString *const kRequestTokenString = @"https://ambleapp.appspot.com/_ah/OAuthGetRequestToken";
static NSString *const kAuthorizeTokenString = @"https://ambleapp.appspot.com/_ah/OAuthAuthorizeToken";
static NSString *const kAccessTokenString = @"https://ambleapp.appspot.com/_ah/OAuthGetAccessToken";
static NSString *const kAmbleServiceEndPoint = @"https://ambleapp.appspot.com/api/mobile/new_service";
static NSString *const kAmbleLocationEndPoint = @"https://ambleapp.appspot.com/api/mobile/recommend";

@interface iambleServiceConnection () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *service;
- (void) sendUpdatedLocation;
@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation iambleServiceConnection
@synthesize delegate = _delegate;
@synthesize service = _service;
@synthesize locationManager = _locationManager;

- (id) init {
    self = [super init];
    if (self) {
        //self.authenticated = ([SSKeychain passwordForService:kAmble account:[defaults valueForKey:kAmble]] != nil);
        // Get the saved authentication, if any, from the keychain.
        GTMOAuthAuthentication *auth = [self myCustomAuth];
        if (auth) {
            self.authenticated = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kAmble
                                                                      authentication:auth];
            // if the auth object contains an access token, didAuth is now true
        }
        
        // retain the authentication object, which holds the auth tokens
        //
        // we can determine later if the auth object contains an access token
        // by calling its -canAuthorize method
        self.auth = auth;
        self.locationManager = [[LocationManager alloc] init];
    }
    return self;
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
{
    if (error != nil)
    {
        // Authentication failed
        UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Authorization Failed"
                                                             message:[error localizedDescription]
                                                            delegate:self
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // Authentication succeeded
        self.authenticated = YES;
        self.auth = auth;
        [self sendUpdatedLocation];
    }
}

- (void) sendUpdatedLocation {
    CLLocation *myLocation = self.locationManager.currentLocation;
    NSURL *url = [NSURL URLWithString:[kAmbleLocationEndPoint stringByAppendingFormat:@"?lat=%f&lng=%f", myLocation.coordinate.latitude, myLocation.coordinate.longitude]];
    NSLog(@"URL being sent: %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.auth authorizeRequest:request];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.delegate connectedToService:self.service];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy]);
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"Response: %@", [httpResponse allHeaderFields]);
    NSLog(@"Status Code: %d", [httpResponse statusCode]);
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
