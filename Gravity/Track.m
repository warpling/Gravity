//
//  Track.m
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "Track.h"
#import <Crashlytics/Answers.h>
#import "Constants.h"
#import "UIDevice+Platform.h"

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

+ (void) spoonCalibrated:(Spoon*)spoon {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://sheetsu.com/apis/9a495cdf"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Generate ISO8601 date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    
    NSDictionary *quarters = spoon.calibrationForces;
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *data = @{@"date"  : [dateFormatter stringFromDate:[NSDate date]],
                           @"build" : build,
                           @"device" : [UIDevice platformNiceString],
                           @"spoon_force"     : @(spoon.spoonForce),
                           @"quarter_1_force" : [quarters objectForKey:@(1*CoinWeightUSQuarter)],
                           @"quarter_2_force" : [quarters objectForKey:@(2*CoinWeightUSQuarter)],
                           @"quarter_3_force" : [quarters objectForKey:@(3*CoinWeightUSQuarter)],
                           @"quarter_4_force" : [quarters objectForKey:@(4*CoinWeightUSQuarter)],
                           @"slope"            : @(spoon.bestFit.slope),
                           @"y_intercept"     : @(spoon.bestFit.yIntercept),
                           @"r_squared"       : @(spoon.bestFit.rSquared),
                           };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [postDataTask resume];

}

@end
