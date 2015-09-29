//
//  RecalibrateButton.m
//  Gravity
//
//  Created by Ryan McLeod on 9/28/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "RecalibrateBar.h"
#import "Constants.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+Adjust.h"
#import "Masonry.h"

@interface RecalibrateBar ()

@property (strong, nonatomic) UIButton *recalibrateButton;

@end

@implementation RecalibrateBar

static const CGFloat cornerRadius = 10;

static const CGFloat horizontalInsets = 25;
static const CGFloat verticalInsets = 4;
static const CGFloat additionalTopInset = 20;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *recalibrateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recalibrateButton setTitle:@"recalibrate" forState:UIControlStateNormal];
        [recalibrateButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:20]];
        
        [recalibrateButton.layer setCornerRadius:cornerRadius];
        [recalibrateButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [recalibrateButton.titleLabel setContentMode:UIViewContentModeCenter];
        
        recalibrateButton.layer.masksToBounds = YES;
        
        [recalibrateButton setContentEdgeInsets:UIEdgeInsetsMake((verticalInsets + additionalTopInset), horizontalInsets, verticalInsets, horizontalInsets)];
        [recalibrateButton setTitleEdgeInsets:UIEdgeInsetsMake(-verticalInsets, -horizontalInsets, -verticalInsets, -horizontalInsets)];
        
        self.recalibrateButton = recalibrateButton;
        [self.recalibrateButton setUserInteractionEnabled:NO];
        [self addSubview:self.recalibrateButton];
        
        [self.recalibrateButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottom).with.offset(-additionalTopInset);
            make.centerX.equalTo(self);
        }];
        
        // Touch stuff
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchEnd) forControlEvents:(UIControlEventTouchCancel | UIControlEventTouchDragExit | UIControlEventTouchDragOutside)];
        
    }
    return self;
}

- (void) touchDown {
    [self setBackgroundColor:[UIColor changeBrightness:self.fillColor amount:0.8]];
    [self.recalibrateButton setBackgroundImage:[UIImage imageWithColor:[UIColor changeBrightness:self.fillColor amount:0.8]] forState:UIControlStateNormal];
}

- (void) touchUpInside {
    if (self.buttonAction) {
        self.buttonAction();
    }
    
    [self setBackgroundColor:self.fillColor];
    [self.recalibrateButton setBackgroundImage:[UIImage imageWithColor:self.fillColor] forState:UIControlStateNormal];
}

- (void) touchEnd {
    [self setBackgroundColor:self.fillColor];
    [self.recalibrateButton setBackgroundImage:[UIImage imageWithColor:self.fillColor] forState:UIControlStateNormal];
}

- (void) setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    [self setBackgroundColor:fillColor];
    
    [self.recalibrateButton setBackgroundImage:[UIImage imageWithColor:fillColor] forState:UIControlStateNormal];
    [self.recalibrateButton setBackgroundImage:[UIImage imageWithColor:[UIColor changeBrightness:fillColor amount:0.8]] forState:UIControlStateHighlighted];
}

- (void) setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    [self.recalibrateButton setTitleColor:textColor forState:UIControlStateNormal];
}

#pragma mark - Custom Hit Testing

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    else if (CGRectContainsPoint(self.bounds, point) || CGRectContainsPoint(self.recalibrateButton.frame, point)) {
        return self;
    }
//    else if (CGRectContainsPoint(self.recalibrateButton.frame, point)) {
//        return self.recalibrateButton;
//    }
    else {
        return nil;
    }
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.recalibrateButton.frame, point)) {
        return YES;
    }
    
    return [super pointInside:point withEvent:event];
}


@end
