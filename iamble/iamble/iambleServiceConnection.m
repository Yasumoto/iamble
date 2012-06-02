//
//  iambleServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "iambleServiceConnection.h"
#import "GTMHTTPFetcher.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <SSKeychain.h>

static NSString *const kAmbleClientID = @"307500153747.apps.googleusercontent.com";
static NSString *const kAmbleClientSecret = @"hLPKxTsZv4CepvzERMEL6le7";
static NSString *const kAmble = @"Amble";

@implementation iambleServiceConnection

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:auth.userEmail forKey:kAmble];
        
        [SSKeychain setPassword:auth.accessToken forService:kAmble account:auth.userEmail];
    }
}

- (void) authorizeAmble {
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:@"https://www.googleapis.com/auth/userinfo.email"
                                                                clientID:kAmbleClientID
                                                            clientSecret:kAmbleClientSecret
                                                        keychainItemName:nil
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://ambleapp.appspot.com"]];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

@end
