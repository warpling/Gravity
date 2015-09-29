//
//  InstructionsViewController.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalibrationViewController.h"

@interface InstructionsViewController : UIViewController <UIPageViewControllerDataSource>

- (void) setupWithCalibrationViewController:(CalibrationViewController*)calibrationViewController;

@end
