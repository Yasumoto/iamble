//
//  ChooseAmbleViewController.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "ChooseAmbleViewController.h"
#import "SinglyServiceConnection.h"

@interface ChooseAmbleViewController ()
@property (nonatomic, strong) SinglyServiceConnection *singly;
@property (nonatomic, strong) iambleServiceConnection *iamble;
@end

@implementation ChooseAmbleViewController
@synthesize facebookSlider = _facebookSlider;
@synthesize twitterSlider = _twitterSlider;
@synthesize foursquareSlider = _foursquareSlider;
@synthesize backgroundImage;
@synthesize selectionScrollView;
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
}

- (void) viewDidAppear:(BOOL)animated {


}

- (void)viewDidUnload
{
    [self setBackgroundImage:nil];
    [self setSelectionScrollView:nil];
    [self setTwitterSlider:nil];
    [self setFacebookSlider:nil];
    [self setTwitterSlider:nil];
    [self setFoursquareSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark ServiceConnection setup


# pragma mark SliderActivatedDelegate

- (void) sliderWasActivated:(SliderView *)slider {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    if (self.iamble.authenticated == NO) {
        [self.navigationController pushViewController:[self.iamble authorizeAmble:slider.service] animated:YES];
    }
    else {
        [self.navigationController pushViewController:[self.singly authorize:slider.service] animated:YES];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

#pragma mark iambleServiceConnection
- (void) connectedToService:(NSString *)service {
    [self.navigationController pushViewController:[self.singly authorize:service] animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

@end
