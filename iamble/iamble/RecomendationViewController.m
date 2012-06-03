//
//  RecomendationViewController.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "RecomendationViewController.h"
#import <SSKeychain.h>
#import <AFNetworking/AFNetworking.h>

static NSString *const ambleURL = @"https://ambleapp.appspot.com/";
static NSString *const jimmehPath = @"api/mobile";
static NSString *const kAmble = @"Amble";

@interface RecomendationViewController ()

@end

@implementation RecomendationViewController

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

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ambleToken = [SSKeychain passwordForService:kAmble account:[defaults valueForKey:kAmble]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:ambleURL]];
    [client setAuthorizationHeaderWithToken:ambleToken];
    [client getPath:jimmehPath  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Hold me taight!");
        NSLog(@"%@", error);
    }];
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
