//
//  UIImage+ImageWithColor.m
//  Blackbox
//
//  Created by Ryan McLeod on 5/7/15.
//  Copyright (c) 2015 Ryan McLeod. All rights reserved.
//

#import "UIImage+ImageWithColor.h"

@implementation UIImage (ImageWithColor)

// Source: http://stackoverflow.com/questions/20300766/how-to-change-the-highlighted-color-of-a-uibutton
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
