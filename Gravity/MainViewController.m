//
//  ViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "MainViewController.h"
#import "InstructionsViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructions;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.instructions = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
}

- (void) viewDidAppear:(BOOL)animated {
    [self presentViewController:self.instructions animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
