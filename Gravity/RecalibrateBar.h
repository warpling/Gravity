//
//  RecalibrateButton.h
//  Gravity
//
//  Created by Ryan McLeod on 9/28/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface RecalibrateBar : UIControl

@property (copy, nonatomic) VoidBlock buttonAction;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *textColor;

@end
