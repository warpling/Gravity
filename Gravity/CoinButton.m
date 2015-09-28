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

@implementation CoinButton

static const CGFloat coinBorderWidth = 3;

+ (instancetype) buttonWithCoinType:(CoinType)coinType color:(UIColor*)color highlightColor:(UIColor*)highlightColor {
    CoinButton *button = [CoinButton buttonWithType:UIButtonTypeCustom];
    if (button) {
        
        // Square frames only
//        NSAssert(self.bounds.size.width == self.bounds.size.height, @"Frame must be square.");
        
        button.layer.borderWidth   = coinBorderWidth;
        button.layer.borderColor   = [color CGColor];
        button.layer.masksToBounds = YES;
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateSelected];
        
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [button setTitleColor:highlightColor forState:UIControlStateSelected];
        
        [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[button titleLabel] setFont:[UIFont fontWithName:AvenirNextDemiBold size:18]];
        [button setTitle:[CoinInfo priceStringForCoinType:coinType] forState:UIControlStateNormal];
        
        [button addTarget:button action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

//- (CGSize) intrinsicContentSize {
//    CGSize intrinsicSize = CGSizeMake(coinSize, coinSize);
//    // TODO: is this kosher? Is intrinsicContentSize unviolatable
//    self.layer.cornerRadius = intrinsicSize.width/2.f;
//    return intrinsicSize;
//}

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
    [self setUserInteractionEnabled:NO];
}

@end
