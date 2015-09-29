//
//  GhostButton.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "GhostButton.h"
#import "UIImage+ImageWithColor.h"
#import "Constants.h"

@implementation GhostButton

static const CGFloat borderWidth = 2;
static const CGFloat horizontalInsets = 42;
static const CGFloat verticalInsets = 10;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFontSize:20];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        
        self.layer.borderWidth   = borderWidth;
        self.layer.masksToBounds = YES;
        
        [self setContentEdgeInsets:UIEdgeInsetsMake(verticalInsets, horizontalInsets, verticalInsets, horizontalInsets)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-verticalInsets, -horizontalInsets, -verticalInsets, -horizontalInsets)];     
    }
    return self;
}

- (void) setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
}

- (void) setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:fontSize]];
}

- (void) setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self updateStyle];
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self updateStyle];
}

- (void) setInvertedStyle:(BOOL)invertedStyle {
    _invertedStyle = invertedStyle;
    [self updateStyle];
}

- (void) updateStyle {

    if (self.invertedStyle) {
        self.layer.borderColor = self.borderColor.CGColor;

        [self setBackgroundImage:[UIImage imageWithColor:self.borderColor] forState:UIControlStateNormal];
        [self setTitleColor:self.fillColor forState:UIControlStateNormal];

        [self setBackgroundImage:[UIImage imageWithColor:self.fillColor] forState:UIControlStateHighlighted];
        [self setTitleColor:self.borderColor forState:UIControlStateHighlighted];
    }
    else {
        self.layer.borderColor = self.borderColor.CGColor;

        [self setBackgroundImage:[UIImage imageWithColor:self.fillColor] forState:UIControlStateNormal];
        [self setTitleColor:self.borderColor forState:UIControlStateNormal];

        [self setBackgroundImage:[UIImage imageWithColor:self.borderColor] forState:UIControlStateHighlighted];
        [self setTitleColor:self.fillColor forState:UIControlStateHighlighted];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height/2.f;
}

@end
