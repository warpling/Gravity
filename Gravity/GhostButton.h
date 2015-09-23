//
//  GhostButton.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GhostButton : UIButton

// The button border color in it's normal state
@property (strong, nonatomic) UIColor *borderColor;
// The button fill color in it's normal state
@property (strong, nonatomic) UIColor *fillColor;
// Used for the text color when selected
//@property (strong, nonatomic) UIColor *highlightColor;

@end
