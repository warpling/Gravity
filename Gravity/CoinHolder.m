//
//  CoinHolder.m
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "CoinHolder.h"
#import "CoinButton.h"
#import "Masonry.h"

@interface CoinHolder ()
    @property (strong, nonatomic) NSArray *coinButtons;
@end

@implementation CoinHolder

static const CGFloat minCoinSize = 88;
static const CGFloat maxCoinSize = 88;
static const CGFloat coinSpacing = 20;

- (instancetype) initWithFrame:(CGRect)frame coinType:(CoinType)coinType numCoins:(NSUInteger)numCoins {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setAxis:UILayoutConstraintAxisHorizontal];
        [self setAlignment:UIStackViewAlignmentCenter];
        [self setDistribution:UIStackViewDistributionFillEqually];

        [self setLayoutMarginsRelativeArrangement:YES];
        [self setLayoutMargins:UIEdgeInsetsMake(0, coinSpacing, 0, coinSpacing)];

        [self setSpacing:coinSpacing];
        
        self.coinButtons = [NSArray new];
        
        for (int ctr = 0; ctr < numCoins; ctr++) {
            CoinButton *coinButton = [CoinButton buttonWithCoinType:CoinTypeUSQuarter color:[UIColor whiteColor] highlightColor:[UIColor gravityPurple]];
            
            // TODO: Make Coin Constraints here
            [coinButton makeConstraints:^(MASConstraintMaker *make) {
//                make.width.greaterThanOrEqualTo(@(minCoinSize));
//                make.width.lessThanOrEqualTo(@(maxCoinSize));
//                make.width.equalTo(@(100)).priorityLow();
                make.height.equalTo(coinButton.width);
            }];
            
            [coinButton setAction:^{
                [self coinSelected:ctr];
            }];
            
            self.coinButtons = [self.coinButtons arrayByAddingObject:coinButton];
            [self addArrangedSubview:coinButton];
        }
    }
    return self;
}

- (void) coinSelected:(NSUInteger)coinIndex {
    NSLog(@"Coin Selected: %ld", coinIndex);
    [self.coinSelectionDelegate coinSelected:coinIndex];
}

- (void) reset {
    for (CoinButton *coinButton in self.coinButtons) {
        [coinButton setSelected:NO];
        [coinButton setUserInteractionEnabled:YES];
    }
}

@end
