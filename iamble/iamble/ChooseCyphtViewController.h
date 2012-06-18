//
//  ChooseCyphtViewController.h
//  Cypht
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 Cypht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"
#import "CyphtServiceConnection.h"

@interface ChooseCyphtViewController : UIViewController <UIScrollViewDelegate, SliderActivatedDelegate>
@property (weak, nonatomic) IBOutlet SliderView *facebookSlider;
@property (weak, nonatomic) IBOutlet SliderView *twitterSlider;
@property (weak, nonatomic) IBOutlet SliderView *foursquareSlider;
@property (weak, nonatomic) IBOutlet SliderView *settingsSlider;
@property (weak, nonatomic) IBOutlet UIScrollView *selectionScrollView;

@end
