//
//  UIDevice+Platform.m
//  Blackbox
//
//  Created by Ryan McLeod on 3/25/15.
//  Copyright (c) 2015 Ryan McLeod. All rights reserved.
//

#import "UIDevice+Platform.h"
#include <sys/types.h>
#include <sys/sysctl.h>
@import CoreTelephony;

@implementation UIDevice (Platform)

// Source: http://www.techrepublic.com/blog/software-engineer/better-code-determine-device-types-and-ios-versions/
+ (NSString *) platformRawString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *) platformNiceString {
    NSString *platform = [self platformRawString];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6+";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s+";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (4G,2)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G,3)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini 1G";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    // Misisng new iPads
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (unsigned long long) availableRAM {
    return [[NSProcessInfo processInfo] physicalMemory];
}

+ (int) has3DTouch {
    NSString *platformRaw = [UIDevice platformRawString];
    return ([platformRaw containsString:@"iPhone8,"] || // iPhone 6
            [platformRaw containsString:@"iPhone9,"]);  // iPhone 7?
}

+ (BOOL) celluarAvailable {
    CTTelephonyNetworkInfo* ctInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = ctInfo.subscriberCellularProvider;
    return (carrier != nil);
}

+ (BOOL) GPSAvailable {
    // A pretty good approximation of if GPS is available
    return [UIDevice celluarAvailable];
    
    // TODO: delete
    // Either it's a phone, or it's an iPad with cellular (meaning GPS too)
    // IsIPhoneRunOnIpad returns if the device truly is an iPad
    //    return (!IsIPhoneRunOnIpad() || [UIDevice celluarAvailable]);
}

+ (time_t) bootTime {
    struct timeval boottime;
    size_t size = sizeof(boottime);
    int ret = sysctlbyname("kern.boottime", &boottime, &size, NULL, 0);
    assert(ret == 0);
    return boottime.tv_sec;
}

@end
