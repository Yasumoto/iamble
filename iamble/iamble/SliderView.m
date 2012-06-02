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
    self.alpha = 0.7;
    [self addSubview:self.imageView];
    [self setBackgroundColor:[UIColor redColor]];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingGesture:)];
    swipeGestureRecognizer.direction =  UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingGesture:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGestureRecognizer];
    [self addGestureRecognizer:leftSwipeGestureRecognizer];
}

- (void)slidingGesture:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"Slider right.");
            //CGPoint translation = [swipe locationInView:self.superview];
            //CGPoint translation = [swipe translationInView:gestureRecognizer.view];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            self.center = CGPointMake(self.center.x + 350,
                                      self.center.y);
            self.alpha = 1.0;
            //self.frame = CGRectMake(0,-10,320,400);
            [UIView commitAnimations];
            //[swipe setTranslation:CGPointZero inView:self.superview];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            NSLog(@"Slider left.");
            //CGPoint translation = [swipe locationInView:self.superview];
            //CGPoint translation = [swipe translationInView:gestureRecognizer.view];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            self.center = CGPointMake(self.center.x - 350,
                                      self.center.y);
            self.alpha = 0.7;
            //self.frame = CGRectMake(0,-10,320,400);
            [UIView commitAnimations];
            //[swipe setTranslation:CGPointZero inView:self.superview];
        }
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
