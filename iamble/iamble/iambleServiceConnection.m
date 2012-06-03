//
//  iambleServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "iambleServiceConnection.h"
#import "GTMHTTPFetcher.h"
#import "GTMOAuthViewControllerTouch.h"
#import <SSKeychain.h>

static NSString *const kAmbleClientID = @"307500153747.apps.googleusercontent.com";
static NSString *const kAmbleClientSecret = @"hLPKxTsZv4CepvzERMEL6le7";
static NSString *const kAmble = @"Amble";
static NSString *const kOAuthScope = @"https://www.googleapis.com/auth/userinfo.email";
static NSString *const kRequestTokenString = @"https://ambleapp.appspot.com/_ah/OAuthGetRequestToken";
static NSString *const kAuthorizeTokenString = @"https://ambleapp.appspot.com/_ah/OAuthAuthorizeToken";
static NSString *const kAccessTokenString = @"https://ambleapp.appspot.com/_ah/OAuthGetAccessToken";


@interface iambleServiceConnection () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *service;
@end

@implementation iambleServiceConnection
@synthesize delegate = _delegate;
@synthesize service = _service;

- (id) init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.authenticated = ([SSKeychain passwordForService:kAmble account:[defaults valueForKey:kAmble]] != nil);
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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:auth.userEmail forKey:kAmble];
        NSLog(@"Access Token: %@", auth.accessToken);
        [SSKeychain setPassword:auth.accessToken forService:kAmble account:auth.userEmail];
        [self.delegate connectedToService:self.service];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://ambleapp.appspot.com/api/mobile"]];
        [auth authorizeRequest:request];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        if(!connection) {
            NSLog(@"fail connection: %@", connection);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@", response.description);
}

- (UIViewController *) authorizeAmble:(NSString *)service {
    self.service = service;
    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:kOAuthScope
                                                               language:nil
                                                        requestTokenURL:[NSURL URLWithString:kRequestTokenString]
                                                      authorizeTokenURL:[NSURL URLWithString:kAuthorizeTokenString]
                                                         accessTokenURL:[NSURL URLWithString:kAccessTokenString]
                                                         authentication:nil
                                                         appServiceName:kAmble
                                                               delegate:self
                                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    /*viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:kOAuthScope
                                                                clientID:kAmbleClientID
                                                            clientSecret:kAmbleClientSecret
                                                        keychainItemName:nil
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://ambleapp.appspot.com"]];*/
    
    return viewController;
}

@end
