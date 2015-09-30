//
//  ViewController.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "WeighArea.h"
#import "Scale.h"
#import "CoinHolder.h"
#import "CalibrationViewController.h"
#import "iRate.h"

@interface MainViewController : UIViewController <WeighAreaEventsDelegate, UITraitEnvironment, SpoonCalibrationDelegate, ScaleOutputDelegate, iRateDelegate>

@property (strong, nonatomic) Scale *scale;

@property (nonatomic) BOOL debugInfoBarEnabled;

@end

