//
//  CalibrationViewController.h
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinHolder.h"
#import "Spoon.h"
#import "WeighArea.h"

@protocol SpoonCalibrationDelegate <NSObject>
- (void) spoonCalibrated:(Spoon*)spoon;
@end


@interface CalibrationViewController : UIViewController <CoinSelectionDelegate, WeighAreaEventsDelegate>

@property (copy, nonatomic) VoidBlock onCalibrationFinished;
@property (weak, nonatomic) id<SpoonCalibrationDelegate> spoonCalibrationDelegate;

@end
