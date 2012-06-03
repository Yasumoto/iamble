//
//  RecomendationViewController.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "RecomendationViewController.h"
#import <SSKeychain.h>
#import <CoreLocation/CoreLocation.h>
#import <JSONKit.h>

static NSString *const ambleURL = @"https://ambleapp.appspot.com/";
static NSString *const jimmehPath = @"api/mobile";
static NSString *const kAmble = @"Amble";
static NSString *const kAmbleLocationEndPoint = @"https://ambleapp.appspot.com/api/mobile/recommend";

@interface RecomendationViewController ()
@property (strong, nonatomic) NSString *name;

@end

@implementation RecomendationViewController
@synthesize locationManager = _locationManager;
@synthesize auth = _auth;
@synthesize name = _name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self sendUpdatedLocation];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void) sendUpdatedLocation {
    CLLocation *myLocation = self.locationManager.currentLocation;
    NSURL *url = [NSURL URLWithString:[kAmbleLocationEndPoint stringByAppendingFormat:@"?lat=%f&lng=%f", myLocation.coordinate.latitude, myLocation.coordinate.longitude]];
    NSLog(@"URL being sent: %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.auth authorizeRequest:request];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
