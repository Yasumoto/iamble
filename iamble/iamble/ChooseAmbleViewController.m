//
//  ChooseAmbleViewController.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "ChooseAmbleViewController.h"

@interface ChooseAmbleViewController ()

@end

@implementation ChooseAmbleViewController
@synthesize facebookSlider;
@synthesize twitterSlider;
@synthesize foursquareSlider;
@synthesize backgroundImage;
@synthesize selectionScrollView;

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
    //CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	selectionScrollView.clipsToBounds = YES;
	selectionScrollView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
    UIImage *foursquareLogo = [UIImage imageNamed:@"foursquare-logo.png"];
    self.foursquareSlider.imageView = [[UIImageView alloc] initWithImage:foursquareLogo];
    self.foursquareSlider.imageView.frame = CGRectMake(0, 0, 256, 70);
    
    self.twitterSlider.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_twitter_withbird_1000_white_blue.png"]];
    self.twitterSlider.backgroundColor = [UIColor grayColor];
    self.twitterSlider.imageView.frame = CGRectMake(10, 5, 296, 55);

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

# pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


@end
