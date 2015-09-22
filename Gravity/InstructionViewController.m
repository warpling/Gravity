//
//  InstructionViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()

@property (strong, nonatomic) UILabel *label;

@end


@implementation InstructionViewController

- (void) viewDidLoad {
    self.label = [UILabel new];
}

- (void) setTitleText:(NSString *)titleText {
    [self.label setText:titleText];
}

@end
