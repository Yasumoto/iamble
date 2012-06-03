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
#import <QuartzCore/QuartzCore.h>
#import "mkPlaceAnotationTHing.h"


static NSString *const ambleURL = @"https://ambleapp.appspot.com/";
static NSString *const jimmehPath = @"api/mobile";
static NSString *const kAmble = @"Amble";
static NSString *const kAmbleLocationEndPoint = @"https://ambleapp.appspot.com/api/mobile/recommend";
static int shiftHeight = 77;
static int sliderShiftRight = 150;
static int sliderShiftLeft = 150;

@interface RecomendationViewController ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *sliders;
@property (strong, nonatomic) CLLocation *placeLocation;
@property (strong, nonatomic) NSString *choice;
@end

@implementation RecomendationViewController
@synthesize placeMapView = _placeMapView;
@synthesize mehButton = _mehButton;
@synthesize looksGoodButton = _looksGoodButton;
@synthesize locationManager = _locationManager;
@synthesize auth = _auth;
@synthesize backButton = _backButton;
@synthesize chooseSawtoothBanner = _chooseSawtoothBanner;
@synthesize coffeeSlider = _coffeeSlider;
@synthesize quickbiteSlider = _quickbiteSlider;
@synthesize sitdownSlider = _sitdownSlider;
@synthesize settingsSlider = _settingsSlider;
@synthesize name = _name;
@synthesize sliders = _sliders;
@synthesize placeLocation = _placeLocation;
@synthesize choice = _choice;

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
    UIImage *img = [UIImage imageNamed:@"logo_header.png"];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.coffeeSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coffee_bar.png"]];
    self.coffeeSlider.delegate = self;
    
    self.quickbiteSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quickbite_bar.png"]];
    self.quickbiteSlider.delegate = self;
    
    self.sitdownSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sitdown_bar.png"]];
    self.sitdownSlider.delegate = self;
    
    self.settingsSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_bar.png"]];
    self.settingsSlider.delegate = self;
    
    self.sliders = [NSArray arrayWithObjects:self.coffeeSlider, self.quickbiteSlider, self.sitdownSlider, self.settingsSlider, nil];
    
    UIImage *backButtonImage = [UIImage imageWithContentsOfFile:@"bg.png"];
    NSLog(@"%@", backButtonImage);
    self.backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(goBackBetch)];
    NSLog(@"%@", self.backButton);
    self.placeMapView.delegate = self;
    [self mapViewShadow];
    self.placeMapView.hidden = YES;
    self.mehButton.hidden = YES;
    self.looksGoodButton.hidden = YES;
}

- (void) mapViewShadow {
    [[self.placeMapView layer] setMasksToBounds:NO];
    [[self.placeMapView layer] setCornerRadius:8]; // if you like rounded corners
    [[self.placeMapView layer] setShadowOffset:CGSizeMake(-2, 5)];
    [[self.placeMapView layer] setShadowRadius:1];
    [[self.placeMapView layer] setShadowOpacity:0.5];
}

- (void)viewDidAppear:(BOOL)animated {

}

/*- (void) sendUpdatedLocation {
    CLLocation *myLocation = self.locationManager.currentLocation;
    NSURL *url = [NSURL URLWithString:[kAmbleLocationEndPoint stringByAppendingFormat:@"?lat=%f&lng=%f", myLocation.coordinate.latitude, myLocation.coordinate.longitude]];
    NSLog(@"URL being sent: %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSLog(@"wtf what's the auth token look like?!: %@", self.auth);
    [self.auth authorizeRequest:request];
    [NSURLConnection connectionWithRequest:request delegate:self];
} we might send just the data over later, for now we're sending choice and location over together */

- (void) sendJimmehChoice:(NSString *) choice{
    CLLocation *myLocation = self.locationManager.currentLocation;
    NSURL *url = [NSURL URLWithString:[kAmbleLocationEndPoint stringByAppendingFormat:@"?lat=%f&lng=%f&choice=%@", myLocation.coordinate.latitude, myLocation.coordinate.longitude, choice]];
    NSLog(@"Sending over a choice: %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSLog(@"wtf what's the auth token look like?!: %@", self.auth);
    [self.auth authorizeRequest:request];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy]);
    JSONDecoder *decoder = [JSONDecoder decoder];
    NSMutableDictionary *dic = [decoder mutableObjectWithData:data];
    NSLog(@"Dic: %@", dic);
    CLLocationDegrees lat = [(NSString *)[dic objectForKey:@"lat"] floatValue];
    CLLocationDegrees lng = [(NSString *)[dic objectForKey:@"lng"] floatValue];
    self.placeLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    MKCoordinateSpan span = {.latitudeDelta = .01, .longitudeDelta = .005};
    MKCoordinateRegion region = {self.placeLocation.coordinate, span};
    [self.placeMapView setRegion:region];
    self.placeMapView.frame = CGRectMake(0, 87, 320, 150);
    
    mkPlaceAnotationTHing *annote = [[mkPlaceAnotationTHing alloc] init];
    annote.coordinate = self.placeLocation.coordinate;
    annote.title = [dic objectForKey:@"name"];
    annote.subtitle = [dic objectForKey:@"type"];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.placeMapView addAnnotation:annote];
    [self.placeMapView selectAnnotation:annote animated:FALSE];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"Response: %@", [httpResponse allHeaderFields]);
    NSLog(@"Status Code: %d", [httpResponse statusCode]);
}

- (void) pushChoice:(NSString *)choice {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.chooseSawtoothBanner.center = CGPointMake(self.chooseSawtoothBanner.center.x,
                                                   self.chooseSawtoothBanner.center.y - shiftHeight);
    for (SliderView *slider in self.sliders) {
        if (slider.service == choice) {
            
            slider.center = CGPointMake(slider.center.x+sliderShiftRight, slider.center.y);
        }
        else {
            slider.center = CGPointMake(slider.center.x-sliderShiftLeft, slider.center.y);
        }
    }
    [UIView commitAnimations];
    [self performSelector:@selector(showNewStuff) withObject:self afterDelay:0.5];

    NSLog(@"%@", self.backButton);
    self.navigationItem.leftBarButtonItem = self.backButton;

}

- (void) showNewStuff {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.placeMapView.hidden = FALSE;
    self.mehButton.hidden = FALSE;
    self.looksGoodButton.hidden = FALSE;
    [UIView commitAnimations];
}

- (void) goBackBetch {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.placeMapView.hidden = YES;
    self.mehButton.hidden = YES;
    self.looksGoodButton.hidden = YES;
    self.chooseSawtoothBanner.center = CGPointMake(self.chooseSawtoothBanner.center.x,
                                                   self.chooseSawtoothBanner.center.y + shiftHeight);
    for (SliderView *slider in self.sliders) {
        if (slider.service == @"wat") {
            
            slider.center = CGPointMake(slider.center.x-sliderShiftRight, slider.center.y);
        }
        else {
            slider.center = CGPointMake(slider.center.x+sliderShiftLeft, slider.center.y);
        }
    }
    [UIView commitAnimations];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void) sliderWasActivated:(SliderView *)slider {
    if ([slider.service isEqualToString:@"settings"]) {
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.choice = slider.service;
    [self sendJimmehChoice:slider.service];
    [self pushChoice:slider.service];
}

- (void)viewDidUnload
{
    [self setCoffeeSlider:nil];
    [self setQuickbiteSlider:nil];
    [self setSitdownSlider:nil];
    [self setChooseSawtoothBanner:nil];
    [self setBackButton:nil];
    [self setSettingsSlider:nil];
    [self setPlaceMapView:nil];
    [self setMehButton:nil];
    [self setLooksGoodButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)newPlaceRequest:(id)sender {
    [self sendJimmehChoice:self.choice];
}
@end
