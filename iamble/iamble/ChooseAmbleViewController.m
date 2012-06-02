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
    //NSURL *url = [NSURL URLWithString:@"https://api.singly.com/oauth/authorize?client_id=4eed71589ff0a822458e50db4b9ebb42&redirect_uri=https://www.iamble.com/auth/singly&service=facebook"];
    selectionScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 500);
    //CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	selectionScrollView.maximumZoomScale = 1.0;
	selectionScrollView.minimumZoomScale = 1.0;
	selectionScrollView.clipsToBounds = YES;
	selectionScrollView.delegate = self;
	//[selectionScrollView addSubview:imageView];
    
}

- (void)viewDidUnload
{
    [self setBackgroundImage:nil];
    [self setSelectionScrollView:nil];
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

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}


@end
