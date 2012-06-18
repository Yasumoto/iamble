//
//  ChooseAmbleViewController.h
//  iamble
//
//  Created by Joe Smith on 6/1/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"
#import "iambleServiceConnection.h"

@interface ChooseAmbleViewController : UIViewController <UIScrollViewDelegate, SliderActivatedDelegate>
@property (weak, nonatomic) IBOutlet SliderView *facebookSlider;
@property (weak, nonatomic) IBOutlet SliderView *twitterSlider;
@property (weak, nonatomic) IBOutlet SliderView *foursquareSlider;
@property (weak, nonatomic) IBOutlet UIScrollView *selectionScrollView;
@property (weak, nonatomic) IBOutlet SliderView *settingsSlider;

@end
