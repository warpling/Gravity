//
//  CoinHolder.h
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol CoinSelectionDelegate <NSObject>

- (void) coinSelected:(NSUInteger)coinIndex;

@end



@interface CoinHolder : UIStackView

@property (weak, nonatomic) id<CoinSelectionDelegate> coinSelectionDelegate;

- (instancetype) initWithFrame:(CGRect)frame coinType:(CoinType)coinType numCoins:(NSUInteger)numCoins;

@end
