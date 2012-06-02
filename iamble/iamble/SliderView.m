//
//  SliderView.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "SliderView.h"

@interface SliderView ()
@property BOOL left;
@end

@implementation SliderView

@synthesize imageView = _imageView;
@synthesize delegate = _delegate;
@synthesize service = _service;

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

- (void) setImageView:(UIImageView *)imageView {
    NSLog(@"Adding imageView.");
    _imageView = imageView;
    [self addSubview:self.imageView];
}

- (void) setupSlider {
    NSLog(@"setting up slider");
    self.alpha = 0.7;
    self.left = YES;
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
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            if (self.left) {
                self.center = CGPointMake(self.center.x + 200,
                                          self.center.y);
                self.alpha = 1.0;
                self.left = NO;
            }
            else {
                self.center = CGPointMake(self.center.x + 50,
                                          self.center.y);
                self.center = CGPointMake(self.center.x - 50,
                                          self.center.y);
            }

            [UIView commitAnimations];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            NSLog(@"Slider left.");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            if (!self.left) {
                self.center = CGPointMake(self.center.x - 200,
                                          self.center.y);
                self.alpha = 0.7;
                self.left = YES;
            }
            else {
                self.center = CGPointMake(self.center.x - 50,
                                          self.center.y);
                self.center = CGPointMake(self.center.x + 50,
                                          self.center.y);
            }
            [UIView commitAnimations];
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
