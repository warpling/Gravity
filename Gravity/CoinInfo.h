//
//  Coins.h
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface CoinInfo : NSObject

+ (CGFloat) knownWeightForCoinType:(CoinType)coinType;
+ (NSString*) priceStringForCoinType:(CoinType)coinType;

@end
