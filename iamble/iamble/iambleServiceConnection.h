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

-(void)connectedToService:(NSString *)service;

@end

@interface iambleServiceConnection : NSObject
@property BOOL authenticated;
- (UIViewController *) authorizeAmble:(NSString *)service;
@property (nonatomic, strong) id <iAmbleServiceDelegate> delegate;
@property (nonatomic, strong) GTMOAuthAuthentication *auth;
@end
