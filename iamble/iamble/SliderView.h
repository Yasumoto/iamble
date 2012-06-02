//
//  SliderView.h
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderView;

@protocol SliderActivatedDelegate <NSObject>
- (void) sliderWasActivated:(SliderView *)slider;
@end

@interface SliderView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id <SliderActivatedDelegate> delegate;
@property (nonatomic, strong) NSString *service;
@end


