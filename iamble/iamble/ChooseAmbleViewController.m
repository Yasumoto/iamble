//
//  ChooseAmbleViewController.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "ChooseAmbleViewController.h"
#import "SinglyServiceConnection.h"
#import "iambleServiceConnection.h"

@interface ChooseAmbleViewController ()
@property (nonatomic, strong) SinglyServiceConnection *singly;
@property (nonatomic, strong) iambleServiceConnection *iamble;
- (void) setupAuth;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    selectionScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 400);
	selectionScrollView.clipsToBounds = YES;
	selectionScrollView.delegate = self;
    
    [self setupAuth];
}

- (void) viewDidAppear:(BOOL)animated {
    UIImage *foursquareLogo = [UIImage imageNamed:@"foursquare-logo.png"];
    self.foursquareSlider.imageView = [[UIImageView alloc] initWithImage:foursquareLogo];
    self.foursquareSlider.imageView.frame = CGRectMake(0, 0, 256, 70);
    self.foursquareSlider.delegate = self;
    
    self.twitterSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_twitter_withbird_1000_white_blue.png"]];
    self.twitterSlider.backgroundColor = [UIColor grayColor];
    self.twitterSlider.imageView.frame = CGRectMake(10, 5, 296, 55);
    self.twitterSlider.delegate = self;

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

- (void) setupAuth {
    
}

# pragma mark SliderActivatedDelegate

- (void) sliderWasActivated:(SliderView *)slider {
    NSLog(@"Slider's Service: %@", slider.service);
}

@end
