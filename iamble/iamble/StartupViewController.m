//
//  StartupViewController.m
//  iamble
//
//  Created by Joe Smith on 6/15/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "StartupViewController.h"
#import "CyphtServiceConnection.h"

static NSString *const kHasStartedBefore = @"hasLaunched";
static NSString *const kFirstLaunchSegue = @"firstLaunchSegue";
static NSString *const kSettingsSegue = @"settingsSegue";
static NSString *const kNormalSegue = @"normalSegue";

@interface StartupViewController ()

@end

@implementation StartupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
	// Do any additional setup after appearing
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![defaults objectForKey:kHasStartedBefore]) {
    [self performSegueWithIdentifier:kFirstLaunchSegue sender:self];
  }
  [defaults setValue:@"FTW" forKey:kHasStartedBefore];
  CyphtServiceConnection *cypht = [[CyphtServiceConnection alloc] init];
  if ([cypht.auth canAuthorize]) {
    [self performSegueWithIdentifier:kNormalSegue sender:self];
  }
  [self performSegueWithIdentifier:kSettingsSegue sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNormalSegue]) {
        [[[segue.destinationViewController viewControllers] objectAtIndex:0] setAuth:[[[CyphtServiceConnection alloc] init] auth]];
    }
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

@end
