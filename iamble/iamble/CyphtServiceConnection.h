//
//  CyphtServiceConnection.h
//  Cypht
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 Cypht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMHTTPFetcher.h"
#import "GTMOAuthViewControllerTouch.h"

@interface CyphtServiceConnection : NSObject
- (UIViewController *) authorizeAmble;
@property (nonatomic, strong) GTMOAuthAuthentication *auth;
@end
