//
//  LoginViewController.h
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)signInToSingly:(UIButton *)sender;
@property (nonatomic) NSString *accessToken;

@end
