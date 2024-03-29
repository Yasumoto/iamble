//
//  ChooseCyphtViewController.m
//  Cypht
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 Cypht. All rights reserved.
//

#import "ChooseCyphtViewController.h"
#import "SinglyServiceConnection.h"
#import "RecomendationViewController.h"
#import "LocationManager.h"

static NSString *const kRecommendSegue = @"recommendSegue";

@interface ChooseCyphtViewController ()
@property (nonatomic, strong) SinglyServiceConnection *singly;
@property (nonatomic, strong) CyphtServiceConnection *cypht;
@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation ChooseCyphtViewController
@synthesize facebookSlider = _facebookSlider;
@synthesize twitterSlider = _twitterSlider;
@synthesize foursquareSlider = _foursquareSlider;
@synthesize selectionScrollView;
@synthesize settingsSlider = _settingsSlider;
@synthesize singly = _singly;
@synthesize cypht = _cypht;
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

- (CyphtServiceConnection *)cypht {
  if (!_cypht) {
    _cypht = [[CyphtServiceConnection alloc] init];
  }
  return _cypht;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:191.0/255 green:219.0/255 blue:103.0/255 alpha:1.0]];
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

- (void) viewDidAppear:(BOOL)animated {
    if (![self.cypht.auth canAuthorize]) {
        UIViewController *cyphtAuth = [self.cypht authorizeAmble];
        [self.navigationController pushViewController:cyphtAuth animated:YES];
    }
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
  UINavigationController *controller = (UINavigationController *) segue.destinationViewController;
  RecomendationViewController *myController = [controller.viewControllers objectAtIndex:0];
  myController.auth = self.cypht.auth;
  myController.locationManager = self.locationManager;
}

# pragma mark SliderActivatedDelegate

- (void) sliderWasActivated:(SliderView *)slider {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

  if ([slider.service isEqualToString:@"finished"]) {
    [self performSegueWithIdentifier:kRecommendSegue sender:self];
  }
  else {
    self.singly.ambleAuth = self.cypht.auth;            
    UIViewController *controller = [self.singly authorize:slider.service];
    [self.navigationController pushViewController:controller animated:YES];
  }    
}

@end
