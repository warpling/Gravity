//
//  TouchCircle.h
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CircularTextView.h"
#import "CKShapeView.h"

@interface TouchCircle : UIView

@property (strong, nonatomic, readonly) CircularTextView *circularLabel;
@property (strong, nonatomic, readonly) CKShapeView *fillCircle;

- (void) expand;
- (void) contractOnCompletion:(VoidBlock)onCompletion;

@end
