//
//  RecomendationViewController.h
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gtm-oauth/GTMOAuthAuthentication.h"
#import "LocationManager.h"
#import "SliderView.h"
#import <MapKit/MapKit.h>

@interface RecomendationViewController : UIViewController <SliderActivatedDelegate, MKMapViewDelegate>
@property (nonatomic, strong) GTMOAuthAuthentication *auth;
@property (weak, nonatomic) IBOutlet UIImageView *chooseSawtoothBanner;
@property (weak, nonatomic) IBOutlet SliderView *coffeeSlider;
@property (weak, nonatomic) IBOutlet SliderView *quickbiteSlider;
@property (weak, nonatomic) IBOutlet SliderView *sitdownSlider;
@property (weak, nonatomic) IBOutlet SliderView *settingsSlider;
@property (nonatomic, strong) LocationManager *locationManager;

#pragma mark Post-Flyout

@property (weak, nonatomic) IBOutlet UIView *superMapView;
@property (weak, nonatomic) IBOutlet MKMapView *placeMapView;
@property (weak, nonatomic) IBOutlet UIButton *mehButton;
@property (weak, nonatomic) IBOutlet UIButton *looksGoodButton;
- (IBAction)newPlaceRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackToChooseButton;
- (IBAction)slideBackChoose:(id)sender;


@end
