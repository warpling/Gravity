//
//  Coins.m
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "CoinInfo.h"

@implementation CoinInfo

+ (CGFloat) knownWeightForCoinType:(CoinType)coinType {
    switch (coinType) {
        case CoinTypeUSPenny:
            return CoinWeightUSPenny;
        case CoinTypeUSNickel:
            return CoinWeightUSNickel;
        case CoinTypeUSDime:
            return CoinWeightUSDime;
        case CoinTypeUSQuarter:
            return CoinWeightUSQuarter;
    }
}

+ (NSString*) priceStringForCoinType:(CoinType)coinType {
    switch (coinType) {
        case CoinTypeUSPenny:
            return @"1¢";
        case CoinTypeUSNickel:
            return @"5¢";
        case CoinTypeUSDime:
            return @"10¢";
        case CoinTypeUSQuarter:
            return @"25¢";
    }
}

@end
