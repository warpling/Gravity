//
//  GhostButton.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "GhostButton.h"
#import "UIImage+ImageWithColor.h"

@implementation GhostButton

static const CGFloat borderWidth = 2;
static const CGFloat horizontalInsets = 24;
static const CGFloat verticalInsets = 8;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:20]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        
        self.layer.borderWidth   = borderWidth;
        self.layer.masksToBounds = YES;
        
        [self setContentEdgeInsets:UIEdgeInsetsMake(verticalInsets, horizontalInsets, verticalInsets, horizontalInsets)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-verticalInsets, -horizontalInsets, -verticalInsets, -horizontalInsets)];     
    }
    return self;
}

- (void) setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    self.layer.backgroundColor = self.fillColor.CGColor;
    [self setBackgroundImage:[UIImage imageWithColor:self.fillColor] forState:UIControlStateNormal];
    [self setTitleColor:self.fillColor forState:UIControlStateHighlighted];
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    self.layer.borderColor = self.borderColor.CGColor;
    [self setBackgroundImage:[UIImage imageWithColor:self.borderColor] forState:UIControlStateHighlighted];
    [self setTitleColor:self.borderColor forState:UIControlStateNormal];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height/2.f;
}

@end
