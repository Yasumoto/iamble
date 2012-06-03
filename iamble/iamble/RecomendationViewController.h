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

@interface RecomendationViewController : UIViewController <SliderActivatedDelegate>
@property (nonatomic, strong) GTMOAuthAuthentication *auth;
@property (weak, nonatomic) UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *chooseSawtoothBanner;
@property (weak, nonatomic) IBOutlet SliderView *coffeeSlider;
@property (weak, nonatomic) IBOutlet SliderView *quickbiteSlider;
@property (weak, nonatomic) IBOutlet SliderView *sitdownSlider;
@property (weak, nonatomic) IBOutlet SliderView *settingsSlider;
@property (nonatomic, strong) LocationManager *locationManager;
@end
