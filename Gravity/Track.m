//
//  Track.m
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "Track.h"
#import <Crashlytics/Answers.h>

@implementation Track

static NSString * const CalibrationLevel = @"Calibration";

#pragma mark - Views

+ (void) instructionsViewed {
    [Answers logContentViewWithName:@"Intro Instructions"
                        contentType:nil
                          contentId:nil
                   customAttributes:nil];
}

+ (void) calibrationViewed {
    [Answers logContentViewWithName:@"Calibration"
                        contentType:nil
                          contentId:nil
                   customAttributes:nil];
}

#pragma mark - Calibration

+ (void) calibrationBegan {
    [Answers logLevelStart:CalibrationLevel
          customAttributes:@{}];
}

+ (void) calibrationReset {
    [Answers logCustomEventWithName:@"Spoon Calibration Reset"
                   customAttributes:@{}];
}

+ (void) calibrationInterupted {
    [Answers logLevelEnd:CalibrationLevel
                   score:nil
                 success:@NO
        customAttributes:@{}];
}

+ (void) calibrationEndedWithSlope:(CGFloat)slope yIntercept:(CGFloat)yIntercept rSquared:(CGFloat)rSquared {
    [Answers logLevelEnd:CalibrationLevel
                   score:@(100 * rSquared)
                 success:@YES
        customAttributes:@{
                           @"slope"      : @(slope),
                           @"yIntercept" : @(yIntercept),
                           @"rSquared"   : @(rSquared),
                           }];
    
    [Answers logCustomEventWithName:@"Spoon Calibrated"
                   customAttributes:@{
                                      @"slope"      : @(slope),
                                      @"yIntercept" : @(yIntercept),
                                      @"rSquared"   : @(rSquared),
                                      }];
}

+ (void) calibrationError:(NSString*)errorType {
    [Answers logCustomEventWithName:@"Calibration Error"
                   customAttributes:@{@"Type" : errorType}];
}

+ (void) calibrationErrorNoSpoonDetected {
    [Track calibrationError:@"No spoon"];
}

#pragma mark - Scale

//+ (void) scaleEvent:(NSString*)eventType {
//    [Answers logCustomEventWithName:@"Scale Event"
//                   customAttributes:@{@"Type" : eventType}];
//}

+ (void) scaleTared {
    [Answers logCustomEventWithName:@"Tare"
                   customAttributes:@{}];
}

+ (void) scaleMaxedOut {
    [Answers logCustomEventWithName:@"Scale Maxed"
                   customAttributes:@{}];
}

+ (void) scaleMultitouched {
    [Answers logCustomEventWithName:@"Scale Multitouched"
                   customAttributes:@{}];
}

+ (void) scaleSwitchedUnits:(NSMassFormatterUnit)units {

    NSString *unitsString;
    switch (units) {
        case NSMassFormatterUnitGram:
            unitsString = @"Gram";
            break;
        case NSMassFormatterUnitOunce:
            unitsString = @"Ounce";
            break;
        case NSMassFormatterUnitKilogram:
            unitsString = @"Kilogram";
            break;
        case NSMassFormatterUnitPound:
            unitsString = @"Pound";
            break;
        case NSMassFormatterUnitStone:
            unitsString = @"Stone";
            break;
    }
    
    [Answers logCustomEventWithName:@"Switch Units"
                   customAttributes:@{@"Units" : unitsString}];
}

@end
