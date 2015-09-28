//
//  UIStackView+RemoveAllArrangedSubviews.m
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "UIStackView+RemoveAllArrangedSubviews.h"

@implementation UIStackView (RemoveAllArrangedSubviews)

- (void) removeAllArrangedSubviews {
    for (UIView *arrangedView in self.arrangedSubviews) {
        [self removeArrangedSubview:arrangedView];
    }
}

- (void) removeAllArrangedSubviewsFromSuperView {
    for (UIView *arrangedView in self.arrangedSubviews) {
        [arrangedView removeFromSuperview];
    }
}

@end
