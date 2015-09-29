//
//  UIDevice+Platform.h
//  Blackbox
//
//  Created by Ryan McLeod on 3/25/15.
//  Copyright (c) 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Platform)

+ (NSString *) platformRawString;
+ (NSString *) platformNiceString;
+ (unsigned long long) availableRAM;
+ (int) has3DTouch;
+ (BOOL) celluarAvailable;
+ (BOOL) GPSAvailable;
+ (time_t) bootTime;

@end
