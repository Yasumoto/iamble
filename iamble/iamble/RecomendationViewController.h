//
//  RecomendationViewController.h
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gtm-oauth/GTMOAuthAuthentication.h"

@interface RecomendationViewController : UIViewController
@property (nonatomic, strong) GTMOAuthAuthentication *auth;
@end
