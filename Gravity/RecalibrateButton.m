//
//  RecalibrateButton.m
//  Gravity
//
//  Created by Ryan McLeod on 9/28/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "RecalibrateButton.h"
#import "Constants.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+Adjust.h"

@implementation RecalibrateButton

static const CGFloat cornerRadius = 10;

static const CGFloat horizontalInsets = 25;
static const CGFloat verticalInsets = 4;
static const CGFloat additionalTopInset = 20;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"recalibrate" forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:20]];
        
        [self.layer setCornerRadius:cornerRadius];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        
        self.layer.masksToBounds = YES;
        
        [self setContentEdgeInsets:UIEdgeInsetsMake((verticalInsets + additionalTopInset), horizontalInsets, verticalInsets, horizontalInsets)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-verticalInsets, -horizontalInsets, -verticalInsets, -horizontalInsets)];
    }
    return self;
}

- (void) setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    [self setBackgroundImage:[UIImage imageWithColor:fillColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor changeBrightness:fillColor amount:0.8]] forState:UIControlStateHighlighted];
}

- (void) setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end
