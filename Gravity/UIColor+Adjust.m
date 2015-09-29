//
//  UIColor+Adjust.m
//  
//
//  Created by Ryan McLeod on 4/25/15.
//
//

#import "UIColor+Adjust.h"

@implementation UIColor (Adjust)

/*!
 * 0.9 darkens by 10%. The percentage is relative to white, so 10% will lighten/darken the same amount
 * regardless of how dark or light the color originally was.
 * Source: http://a2apps.com.au/lighten-or-darken-a-uicolor/
 */
+ (UIColor*)changeBrightness:(UIColor*)color amount:(CGFloat)amount
{
    
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        brightness += (amount-1.0);
        brightness = MAX(MIN(brightness, 1.0), 0.0);
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    }
    
    CGFloat white;
    if ([color getWhite:&white alpha:&alpha]) {
        white += (amount-1.0);
        white = MAX(MIN(white, 1.0), 0.0);
        return [UIColor colorWithWhite:white alpha:alpha];
    }
    
    return nil;
}

@end
