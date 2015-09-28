//
//  Constants.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>

// Void Block
typedef void (^VoidBlock)(void);


// Maths
extern const float gramToOzMultiplier;

// Coin Types
typedef NS_ENUM(NSInteger, CoinType) {
    CoinTypeUSPenny,
    CoinTypeUSNickel,
    CoinTypeUSDime,
    CoinTypeUSQuarter
};

// Coin Weights
extern const float CoinWeightUSPenny;
extern const float CoinWeightUSNickel;
extern const float CoinWeightUSDime;
extern const float CoinWeightUSQuarter;

// Flags
extern NSString * const InstructionsCompleted;
extern NSString * const DefaultMassDisplayUnits;

// Fonts
extern NSString * const AvenirNextMedium;
extern NSString * const AvenirNextDemiBold;
extern NSString * const AvenirNextBold;
extern NSString * const AvenirNextHeavy;
