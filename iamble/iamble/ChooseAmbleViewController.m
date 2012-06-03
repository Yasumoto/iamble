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

static NSString *const kRecommendSegue = @"recommendSegue";

@interface ChooseAmbleViewController ()
@property (nonatomic, strong) SinglyServiceConnection *singly;
@property (nonatomic, strong) iambleServiceConnection *iamble;
@end

@implementation ChooseAmbleViewController
@synthesize facebookSlider = _facebookSlider;
@synthesize twitterSlider = _twitterSlider;
@synthesize foursquareSlider = _foursquareSlider;
@synthesize selectionScrollView;
@synthesize settingsSlider = _settingsSlider;
@synthesize singly = _singly;
@synthesize iamble = _iamble;

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
	// Do any additional setup after loading the view.
    selectionScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 400);
	selectionScrollView.clipsToBounds = YES;
	selectionScrollView.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.facebookSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.facebookSlider.backgroundColor = [UIColor whiteColor];
    self.facebookSlider.imageView.frame = CGRectMake(10, 5, 296, 55);
    self.facebookSlider.delegate = self;
    
    UIImage *foursquareLogo = [UIImage imageNamed:@"foursquare-logo.png"];
    self.foursquareSlider.imageView = [[UIImageView alloc] initWithImage:foursquareLogo];
    self.foursquareSlider.imageView.frame = CGRectMake(0, 0, 256, 70);
    self.foursquareSlider.delegate = self;
    if ([defaults valueForKey:@"foursquare"]) {
        [self.foursquareSlider slideRight];
    }
    
    
    self.twitterSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_twitter_withbird_1000_white_blue.png"]];
    self.twitterSlider.backgroundColor = [UIColor grayColor];
    self.twitterSlider.imageView.frame = CGRectMake(10, 5, 296, 55);
    self.twitterSlider.delegate = self;
    if ([defaults valueForKey:@"twitter"]) {
        [self.twitterSlider slideRight];
    }
    
    self.settingsSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.settingsSlider.backgroundColor = [UIColor whiteColor];
    self.settingsSlider.imageView.frame = CGRectMake(10, 5, 296, 55);
    self.settingsSlider.delegate = self;

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
    [self.navigationController pushViewController:[self.singly authorize:service] animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

@end
