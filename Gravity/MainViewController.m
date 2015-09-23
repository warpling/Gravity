//
//  ViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "MainViewController.h"
#import "InstructionsViewController.h"
#import "UIImage+ImageWithColor.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructions;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *resetIntroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetIntroButton setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [resetIntroButton setTitle:@"Reset Intro" forState:UIControlStateNormal];
    [resetIntroButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [resetIntroButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:UIControlStateNormal];
    [resetIntroButton addTarget:self action:@selector(resetIntro) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetIntroButton];
    
    self.instructions = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
}

- (void) viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:InstructionsCompleted] boolValue]) {
        [self showIntroAnimated:NO];
    }
}

- (void) showIntroAnimated:(BOOL)animated {
    [self presentViewController:self.instructions animated:animated completion:^{
        
    }];
}

- (void) resetIntro {
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:InstructionsCompleted];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self showIntroAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
