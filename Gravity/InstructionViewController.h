//
//  InstructionViewController.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GhostButton.h"

@interface InstructionViewController : UIViewController

@property (nonatomic) NSUInteger stepNumber;
@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic) NSString *continueButtonText;
@property (copy,   nonatomic) VoidBlock continueButtonAction;

@property (strong, nonatomic, readonly) UITextView *contentTextView;
@property (strong, nonatomic, readonly) GhostButton *continueButton;

@end
