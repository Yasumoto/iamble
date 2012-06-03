//
//  ChooseAmbleViewController.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "ChooseAmbleViewController.h"
#import "SinglyServiceConnection.h"
#import "RecomendationViewController.h"
#import "LocationManager.h"

static NSString *const kRecommendSegue = @"recommendSegue";

@interface ChooseAmbleViewController ()
@property (nonatomic, strong) SinglyServiceConnection *singly;
@property (nonatomic, strong) iambleServiceConnection *iamble;
@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation ChooseAmbleViewController
@synthesize facebookSlider = _facebookSlider;
@synthesize twitterSlider = _twitterSlider;
@synthesize foursquareSlider = _foursquareSlider;
@synthesize selectionScrollView;
@synthesize settingsSlider = _settingsSlider;
@synthesize singly = _singly;
@synthesize iamble = _iamble;
@synthesize locationManager = _locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (SinglyServiceConnection *)singly {
    if (!_singly) {
        _singly = [[SinglyServiceConnection alloc] init];
    }
    return _singly;
}

- (iambleServiceConnection *)iamble {
    if (!_iamble) {
        _iamble = [[iambleServiceConnection alloc] init];
        _iamble.delegate = self;
    }
    return _iamble;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *img = [UIImage imageNamed:@"logo_header.png"];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.locationManager = [[LocationManager alloc] init];

    selectionScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 400);
	selectionScrollView.clipsToBounds = YES;
	selectionScrollView.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.facebookSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_bar.png"]];
    self.facebookSlider.delegate = self;
    if ([defaults valueForKey:@"facebook"]) {
        [self.facebookSlider slideRight:YES];
    }
    
    UIImage *foursquareLogo = [UIImage imageNamed:@"foursquare_bar.png"];
    self.foursquareSlider.imageView = [[UIImageView alloc] initWithImage:foursquareLogo];
    self.foursquareSlider.delegate = self;
    if ([defaults valueForKey:@"foursquare"]) {
        [self.foursquareSlider slideRight:YES];
    }
    
    
    self.twitterSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter_bar.png"]];
    self.twitterSlider.delegate = self;
    if ([defaults valueForKey:@"twitter"]) {
        [self.twitterSlider slideRight:YES];
    }
    
    self.settingsSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finish_bar.png"]];
    self.settingsSlider.delegate = self;
    self.settingsSlider.frame = CGRectMake(-172, 321, self.settingsSlider.frame.size.width, self.settingsSlider.frame.size.height);

}

- (void) viewWillAppear:(BOOL)animated {
        self.settingsSlider.frame = CGRectMake(-172, 321, self.settingsSlider.frame.size.width, self.settingsSlider.frame.size.height);
}

- (void)viewDidUnload
{
    [self setSelectionScrollView:nil];
    [self setTwitterSlider:nil];
    [self setFacebookSlider:nil];
    [self setTwitterSlider:nil];
    [self setFoursquareSlider:nil];
    [self setSettingsSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RecomendationViewController class]]) {
        RecomendationViewController *controller = (RecomendationViewController *) segue.destinationViewController;
        controller.auth = self.iamble.auth;
        controller.locationManager = self.locationManager;
    }
}

# pragma mark SliderActivatedDelegate

- (void) sliderWasActivated:(SliderView *)slider {
    if ([slider.service isEqualToString:@"finished"]) {
        [self performSegueWithIdentifier:kRecommendSegue sender:self];
        return;
    }
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    if (self.iamble.authenticated == NO) {
        [self.navigationController pushViewController:[self.iamble authorizeAmble:slider.service] animated:YES];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        UIViewController *controller = [self.singly authorize:slider.service];
        if (controller) {
            [self.navigationController pushViewController:controller animated:YES];
        }
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

#pragma mark iambleServiceConnection
- (void) connectedToAmble:(NSString *)service {
    self.singly.ambleAuth = self.iamble.auth;
    [self.navigationController pushViewController:[self.singly authorize:service] animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

@end
