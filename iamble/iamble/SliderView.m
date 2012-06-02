//
//  SliderView.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) viewDidLoad {

}

- (void) setupSlider {
    [self setBackgroundColor:[UIColor redColor]];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliding:)];
    swipeGestureRecognizer.direction =  UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGestureRecognizer];
}

- (void)slidingGesture:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"oh yeah buddy.");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
