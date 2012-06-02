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

- (void) awakeFromNib {
    [self setupSlider];
}

- (void) setupSlider {
    NSLog(@"setting up slider");
    [self addSubview:self.imageView];
    [self setBackgroundColor:[UIColor redColor]];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingGesture:)];
    swipeGestureRecognizer.direction =  UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGestureRecognizer];
}

- (void)slidingGesture:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
        //if (swipe.state == UIGestureRecognizerStateChanged) {
            NSLog(@"oh yeah buddy.");
            CGPoint translation = [swipe locationInView:self.superview];
            //CGPoint translation = [swipe translationInView:gestureRecognizer.view];
            self.center = CGPointMake(self.center.x + translation.x,
                                 self.center.y);
            //[UIView beginAnimations:nil context:NULL];
            //[UIView setAnimationDuration:0.25];
            //self.frame = CGRectMake(0,-10,320,400);
            //[UIView commitAnimations];
            //[swipe setTranslation:CGPointZero inView:self.superview];
        //}
    }
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
