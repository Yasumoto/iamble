//
//  SinglyServiceConnection.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "SinglyServiceConnection.h"
#import "gtm-oauth2/GTMHTTPFetcher.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <SSKeychain.h>
#import <JSONKit/JSONKit.h>
#import <AFNetworking/AFNetworking.h>

static NSString *const kSinglyClientID = @"4eed71589ff0a822458e50db4b9ebb42";
static NSString *const kSinglyClientSecret = @"d13bc8daa661cd7ea6bb3917ba687d29";
static NSString *const kSingly = @"Singly";
static NSString *const kAmbleNewServiceEndPoint = @"https://cypht-app.appspot.com/api/mobile/new_service";

@interface SinglyServiceConnection ()
- (GTMOAuth2Authentication *)singlyAuth;
- (IBAction)loadProfiles;
@property (strong, nonatomic) NSString *service;
@end

@implementation SinglyServiceConnection

@synthesize service = _service;
@synthesize ambleAuth = _ambleAuth;

- (id) init {
    self = [super init];
    if (self) {
        [self loadProfiles];
    }
    return self;
}

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:service]) {
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
        
        self.service = service;
        
        // Push the authentication view to our navigation controller instance
        return viewController;
    }
    return nil;
}


- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
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
        [SSKeychain setPassword:auth.accessToken forService:kSingly account:kSingly];
        [self sendJimmehTehToken:auth.accessToken];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:kSingly forKey:self.service];
    }
}

- (void) sendJimmehTehToken:(NSString *)accessToken {
    NSURL *url = [NSURL URLWithString:[kAmbleNewServiceEndPoint stringByAppendingFormat:@"?singly_access_token=%@", accessToken]];
    NSLog(@"URL being sent for Jimmeh singly token: %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.ambleAuth authorizeRequest:request];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy]);
    JSONDecoder *decoder = [JSONDecoder decoder];
    NSMutableDictionary *dic = [decoder mutableObjectWithData:data];
    NSLog(@"Dic: %@", dic);
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"Response: %@", [httpResponse allHeaderFields]);
    NSLog(@"Status Code: %d", [httpResponse statusCode]);
}

- (IBAction)loadProfiles
{
    NSString *singlyToken = [SSKeychain passwordForService:kSingly account:kSingly];
    if (singlyToken) {
        NSURL *profilesURL = [NSURL URLWithString:[@"https://api.singly.com/profiles?access_token=" stringByAppendingString:singlyToken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:profilesURL];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   JSONDecoder *decoder = [JSONDecoder decoder];
                                   NSObject *decodedData = [decoder objectWithData:data];
                                   if ([decodedData isKindOfClass:[NSDictionary class]]) {
                                       NSDictionary *dict = (NSDictionary *)decodedData;
                                       for (NSString *key in dict) {
                                           [defaults setValue:kSingly forKey:key];
                                       }
                                   }
                               }];
    }
}

@end
