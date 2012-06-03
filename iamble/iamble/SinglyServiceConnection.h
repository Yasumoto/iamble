//
//  SinglyServiceConnection.h
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuthViewControllerTouch.h"

@interface SinglyServiceConnection : NSObject <NSURLConnectionDelegate>
- (UIViewController *)authorize:(NSString *)service;
@property (nonatomic, strong) GTMOAuthAuthentication *ambleAuth;
@end
