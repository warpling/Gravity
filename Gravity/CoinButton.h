//
//  CoinButton.h
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface CoinButton : UIButton

@property (nonatomic, copy) VoidBlock action;

+ (instancetype) buttonWithCoinType:(CoinType)coinType fillColor:(UIColor*)fillColor accentColor:(UIColor*)accentColor disabledAccentColor:(UIColor*)disabledAccentColor;

@end
