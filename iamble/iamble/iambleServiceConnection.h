//
//  iambleServiceConnection.h
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMHTTPFetcher.h"
#import "GTMOAuthViewControllerTouch.h"

@class iambleServiceConnection;

@protocol iAmbleServiceDelegate <NSObject>
-(void)connectedToAmble:(NSString *)service;
@end

@interface iambleServiceConnection : NSObject
- (UIViewController *) authorizeAmble:(NSString *)service;
@property BOOL authenticated;
@property (nonatomic, strong) id <iAmbleServiceDelegate> delegate;
@property (nonatomic, strong) GTMOAuthAuthentication *auth;
@end
