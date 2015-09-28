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

@interface MainViewController : UIViewController <ScaleDisplayDelegate, WeighAreaEventsDelegate, UITraitEnvironment, SpoonCalibrationDelegate>

@property (strong, nonatomic) Scale *scale;

@end

