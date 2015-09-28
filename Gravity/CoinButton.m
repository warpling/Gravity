//
//  CoinButton.m
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "CoinButton.h"
#import "Constants.h"
#import "UIImage+ImageWithColor.h"
#import "CoinInfo.h"

@interface CoinButton ()
@property (strong, nonatomic) UIColor *fillColor, *accentColor, *disabledAccentColor;
@end

@implementation CoinButton

static const CGFloat coinBorderWidth = 3;

+ (instancetype) buttonWithCoinType:(CoinType)coinType fillColor:(UIColor*)fillColor accentColor:(UIColor*)accentColor disabledAccentColor:(UIColor*)disabledAccentColor {
    CoinButton *button = [CoinButton buttonWithType:UIButtonTypeCustom];
    if (button) {
        
        button.fillColor = fillColor;
        button.accentColor = accentColor;
        button.disabledAccentColor = disabledAccentColor;
        
        button.layer.borderWidth   = coinBorderWidth;
        button.layer.borderColor   = [accentColor CGColor];
        button.layer.masksToBounds = YES;
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:accentColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:accentColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
        
        [button setTitleColor:accentColor forState:UIControlStateNormal];
        [button setTitleColor:fillColor forState:UIControlStateHighlighted];
        [button setTitleColor:fillColor forState:UIControlStateSelected];
        [button setTitleColor:disabledAccentColor forState:UIControlStateDisabled];
        
        [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[button titleLabel] setFont:[UIFont fontWithName:AvenirNextDemiBold size:18]];
        [button setTitle:[CoinInfo priceStringForCoinType:coinType] forState:UIControlStateNormal];
        
        [button addTarget:button action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width/2.f;
}

- (void) touchUpInside {
    [self setSelected:YES];
    
    if (self.action) {
        self.action();
    }
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setUserInteractionEnabled:(!selected)];
}


- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        self.layer.borderColor = [self.accentColor CGColor];
    } else {
        self.layer.borderColor = [self.disabledAccentColor CGColor];
    }
}

@end
