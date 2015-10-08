//
//  CAMediaTimingFunction+BasicFunctions.m
//
//
//  Created by Ryan McLeod on 7/1/15.
//
//
#import "CAMediaTimingFunction+BasicFunctions.h"

@implementation CAMediaTimingFunction (BasicFunctions)

#pragma mark - Defaults

+ (CAMediaTimingFunction*) linear {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

+ (CAMediaTimingFunction*) easeOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

+ (CAMediaTimingFunction*) easeIn {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

+ (CAMediaTimingFunction*) easeInEaseOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
}

+ (CAMediaTimingFunction*) default {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
}

//  Created by Arkadiusz
+ (CAMediaTimingFunction *)swiftOut
{
    CGPoint controlPoint1 = CGPointMake(0.4, 0.0);
    CGPoint controlPoint2 = CGPointMake(0.2, 1.0);
    return [self functionWithControlPoints:controlPoint1.x :controlPoint1.y :controlPoint2.x :controlPoint2.y];
}

#pragma mark - Custom Timing Functions

+ (CAMediaTimingFunction*) SineIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.45 :0 :1 :1];
}
+ (CAMediaTimingFunction*) SineOut {
    return [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.55 :1];
}
+ (CAMediaTimingFunction*) SineInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.45 :0 :0.55 :1];
}

+ (CAMediaTimingFunction*) QuadIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.43 :0 :0.82 :0.60];
}
+ (CAMediaTimingFunction*) QuadOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.18 :0.4 :0.57 :1];
}
+ (CAMediaTimingFunction*) QuadInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.43 :0 :0.57 :1];
}

+ (CAMediaTimingFunction*) CubicIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.67 :0 :0.84 :0.54];
}
+ (CAMediaTimingFunction*) CubicOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.16 :0.46 :0.33 :1];
}
+ (CAMediaTimingFunction*) CubicInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.65 :0 :0.35 :1];
}

+ (CAMediaTimingFunction*) QuartIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.81 :0 :0.77 :0.34];
}
+ (CAMediaTimingFunction*) QuartOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.23 :0.66 :0.19 :1];
}
+ (CAMediaTimingFunction*) QuartInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.81 :0 :0.19 :1];
}

+ (CAMediaTimingFunction*) QuintIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.89 :0 :0.81 :0.27];
}
+ (CAMediaTimingFunction*) QuintOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.19 :0.73 :0.11 :1];
}
+ (CAMediaTimingFunction*) QuintInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.9 :0 :0.1 :1];
}

+ (CAMediaTimingFunction*) ExpoIn {
    return [CAMediaTimingFunction functionWithControlPoints:1.04 :0 :0.88 :0.49];
}
+ (CAMediaTimingFunction*) ExpoOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.12 :0.51 :-0.4 :1];
}
+ (CAMediaTimingFunction*) ExpoInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.95 :0 :0.05 :1];
}

+ (CAMediaTimingFunction*) CircIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.6 :0 :1 :0.45];
}
+ (CAMediaTimingFunction*) CircOut {
    return [CAMediaTimingFunction functionWithControlPoints:1 :0.55 :0.4 :1];
}
+ (CAMediaTimingFunction*) CircInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.82 :0 :0.18 :1];
}

+ (CAMediaTimingFunction*) BackIn {
    return [CAMediaTimingFunction functionWithControlPoints:0.77 :-0.63 :1 :1];
}
+ (CAMediaTimingFunction*) BackOut {
    return [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.23 :1.37];
}
+ (CAMediaTimingFunction*) BackInOut {
    return [CAMediaTimingFunction functionWithControlPoints:0.77 :-0.63 :0.23 :1.37];
}

@end
