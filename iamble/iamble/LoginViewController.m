//
//  LoginViewController.m
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "LoginViewController.h"
#import "GTMHTTPFetcher.h"
#import "GTMOAuth2ViewControllerTouch.h"

static NSString *const kMyClientID = @"4eed71589ff0a822458e50db4b9ebb42";
static NSString *const kMyClientSecret = @"d13bc8daa661cd7ea6bb3917ba687d29";

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (IBAction)signInToSingly:(UIButton *)sender {
}
@end
