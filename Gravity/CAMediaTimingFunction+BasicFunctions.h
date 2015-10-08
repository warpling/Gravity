//
//  CAMediaTimingFunction+BasicFunctions.h
//
//
//  Created by Ryan McLeod on 7/1/15.
//
//

#import <QuartzCore/QuartzCore.h>

@interface CAMediaTimingFunction (BasicFunctions)

+ (CAMediaTimingFunction*) linear;
+ (CAMediaTimingFunction*) easeOut;
+ (CAMediaTimingFunction*) easeIn;
+ (CAMediaTimingFunction*) easeInEaseOut;
+ (CAMediaTimingFunction*) default;
+ (CAMediaTimingFunction *) swiftOut;

+ (CAMediaTimingFunction*) SineIn;
+ (CAMediaTimingFunction*) SineOut;
+ (CAMediaTimingFunction*) SineInOut;
+ (CAMediaTimingFunction*) QuadIn;
+ (CAMediaTimingFunction*) QuadOut;
+ (CAMediaTimingFunction*) QuadInOut;
+ (CAMediaTimingFunction*) CubicIn;
+ (CAMediaTimingFunction*) CubicOut;
+ (CAMediaTimingFunction*) CubicInOut;
+ (CAMediaTimingFunction*) QuartIn;
+ (CAMediaTimingFunction*) QuartOut;
+ (CAMediaTimingFunction*) QuartInOut;
+ (CAMediaTimingFunction*) QuintIn;
+ (CAMediaTimingFunction*) QuintOut;
+ (CAMediaTimingFunction*) QuintInOut;
+ (CAMediaTimingFunction*) ExpoIn;
+ (CAMediaTimingFunction*) ExpoOut;
+ (CAMediaTimingFunction*) ExpoInOut;
+ (CAMediaTimingFunction*) CircIn;
+ (CAMediaTimingFunction*) CircOut;
+ (CAMediaTimingFunction*) CircInOut;
+ (CAMediaTimingFunction*) BackIn;
+ (CAMediaTimingFunction*) BackOut;
+ (CAMediaTimingFunction*) BackInOut;

@end
