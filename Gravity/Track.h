//
//  Track.h
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

+ (void) instructionsViewed;
+ (void) calibrationViewed;

+ (void) calibrationBegan;
+ (void) calibrationReset;
+ (void) calibrationInterupted;
+ (void) calibrationEndedWithSlope:(CGFloat)slope yIntercept:(CGFloat)yIntercept rSquared:(CGFloat)rSquared;
+ (void) calibrationErrorNoSpoonDetected;

+ (void) scaleTared;
+ (void) scaleMaxedOut;
+ (void) scaleMultitouched;
+ (void) scaleSwitchedUnits:(NSMassFormatterUnit)units;

@end
