//
//  mkPlaceAnotationTHing.h
//  iamble
//
//  Created by Joe Smith on 6/3/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface mkPlaceAnotationTHing : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * subtitle;
@end

