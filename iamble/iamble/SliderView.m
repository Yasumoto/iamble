//
//  SliderView.m
//  iamble
//
//  Created by Joe Smith on 6/2/12.
//  Copyright (c) 2012 iamble. All rights reserved.
//

#import "SliderView.h"
#import <QuartzCore/QuartzCore.h>

static int shiftLength = 400;

@interface SliderView ()
@property BOOL left;
@end

@implementation SliderView
@synthesize left = _left;
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
    _imageView = imageView;
    [self addSubview:self.imageView];
}

- (void) setupSlider {
    self.alpha = 0.7;
    self.left = YES;
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingGesture:)];
    swipeGestureRecognizer.direction =  UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingGesture:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGestureRecognizer];
    [self addGestureRecognizer:leftSwipeGestureRecognizer];
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(-2, 5);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.5;
}

- (void) slideRight:(BOOL)atStartup {
    if (!atStartup) {
        [UIView animateWithDuration:0.5 animations:^{
            if (self.left) {
                self.center = CGPointMake(self.center.x + shiftLength,
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
        } completion:^(BOOL finished){
            if (finished) {
                [self.delegate sliderWasActivated:self];
            }
        }];
    } else {
        self.center = CGPointMake(self.center.x + shiftLength,
                                  self.center.y);
        self.alpha = 1.0;
        self.left = NO;
    }
}

- (void) slideLeft {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (!self.left) {
        self.center = CGPointMake(self.center.x - shiftLength,
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

- (void)slidingGesture:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            [self slideRight:NO];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self slideLeft];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 CGContextRef currentContext = UIGraphicsGetCurrentContext();
 CGContextSaveGState(currentContext);
 CGContextSetShadow(currentContext, CGSizeMake(-15, 20), 5);
 [super drawRect: rect];
 CGContextRestoreGState(currentContext);
 }*/


@end
