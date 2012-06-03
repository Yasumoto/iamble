//
//  LocationManager.m
//  iamble
//
//  Created by Joe Smith on 6/3/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager
@synthesize locationManager = _locationManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send loc updates to myself
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 500;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.currentLocation = newLocation;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"CoreLocation Error: %@", [error description]);
}


@end
