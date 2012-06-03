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
static int shiftHeight = 77;
static int sliderShiftRight = 150;
static int sliderShiftLeft = 150;

@interface RecomendationViewController ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *sliders;
@end

@implementation RecomendationViewController
@synthesize locationManager = _locationManager;
@synthesize auth = _auth;
@synthesize backButton = _backButton;
@synthesize chooseSawtoothBanner = _chooseSawtoothBanner;
@synthesize coffeeSlider = _coffeeSlider;
@synthesize quickbiteSlider = _quickbiteSlider;
@synthesize sitdownSlider = _sitdownSlider;
@synthesize name = _name;
@synthesize sliders = _sliders;

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
    [self sendUpdatedLocation];
    self.coffeeSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coffee_bar.png"]];
    self.coffeeSlider.delegate = self;
    
    self.quickbiteSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quickbite_bar.png"]];
    self.quickbiteSlider.delegate = self;
    
    self.sitdownSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sitdown_bar.png"]];
    self.sitdownSlider.delegate = self;
    
    self.sliders = [NSArray arrayWithObjects:self.coffeeSlider, self.quickbiteSlider, self.sitdownSlider, nil];
    
    UIImage *backButtonImage = [UIImage imageWithContentsOfFile:@"bg.png"];
    NSLog(@"%@", backButtonImage);
    self.backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(goBackBetch)];
    NSLog(@"%@", self.backButton);
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

- (void) sendJimmehChoice:(NSString *) choice{
    
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
    NSLog(@"%@", self.backButton);
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void) goBackBetch {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
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
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
