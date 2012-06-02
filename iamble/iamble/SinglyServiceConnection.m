//
//  SinglyServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "SinglyServiceConnection.h"
#import "GTMHTTPFetcher.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <SSKeychain.h>

static NSString *const kSinglyClientID = @"4eed71589ff0a822458e50db4b9ebb42";
static NSString *const kSinglyClientSecret = @"d13bc8daa661cd7ea6bb3917ba687d29";
static NSString *const kSingly = @"Singly";

@interface SinglyServiceConnection ()
- (GTMOAuth2Authentication *)singlyAuth;
- (IBAction)loadProfiles;
@end

@implementation SinglyServiceConnection


- (GTMOAuth2Authentication *)singlyAuth
{
    
    // Set the token URL to the Singly token endpoint.
    NSURL *tokenURL = [NSURL URLWithString:@"https://api.singly.com/oauth/access_token"];
    
    // Set a bogus redirect URI. It won't actually be used as the redirect will
    // be intercepted by the OAuth library and handled in the app.
    NSString *redirectURI = @"http://api.singly.com/OAuthCallback";
    
    GTMOAuth2Authentication *auth;
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Singly API"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:kSinglyClientID
                                                         clientSecret:kSinglyClientSecret];
    
    // The Singly API does not return a token type, therefore we set one here to
    // avoid a warning being thrown.
    [auth setTokenType:@"Bearer"];
    
    return auth;
}

- (UIViewController *)authorize:(NSString *)service
{
    GTMOAuth2Authentication *auth = [self singlyAuth];
    
    // Prepare the Authorization URL. We will pass in the name of the service
    // that we wish to authorize with.
    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.singly.com/oauth/authorize?service=%@", service]];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [ [GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                  authorizationURL:authURL
                                                                  keychainItemName:nil
                                                                          delegate:self
                                                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://api.singly.com/"]];
    
    // Push the authentication view to our navigation controller instance
    return viewController;
}


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
        [defaults setValue:auth.userEmail forKey:kSingly];
        
        [SSKeychain setPassword:auth.accessToken forService:kSingly account:auth.userEmail];
    }
}

- (IBAction)loadProfiles
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *profilesURL = [NSURL URLWithString:[@"https://api.singly.com/profiles?access_token=" stringByAppendingString:[SSKeychain passwordForService:kSingly account:[defaults valueForKey:kSingly]]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:profilesURL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *responseBody = [ [NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"Received Response: %@", responseBody);
                               
                               UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Profiles Response"
                                                                                    message:responseBody
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"Dismiss"
                                                                          otherButtonTitles:nil];
                               [alertView show];
                               
                           }];
}

@end
