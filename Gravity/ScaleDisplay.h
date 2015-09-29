//
//  ScaleOutput.h
//  Gravity
//
//  Created by Ryan McLeod on 9/28/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Scale.h"

@interface ScaleDisplay : UILabel <ScaleOutputDelegate>

@property (nonatomic, assign) CGFloat weight; // grams
@property (nonatomic, assign) NSMassFormatterUnit massUnit;

@end
