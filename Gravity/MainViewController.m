//
//  ViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "MainViewController.h"
#import "InstructionsViewController.h"
#import "WeighArea.h"
#import "UIImage+ImageWithColor.h"
#define MAS_SHORTHAND
#import "Masonry.h"
#import "UIColor+Additions.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructions;

@property (strong, nonatomic) UIButton *resetIntroButton;
@property (strong, nonatomic) WeighArea *weighArea;
@property (strong, nonatomic) UILabel *outputLabel;
@property (strong, nonatomic) UIButton *tareButton;
@property (strong, nonatomic) UIButton *unitsButton;

//@property (nonatomic) NSUInteger currentMassUnits;

@end


@implementation MainViewController

static const CGFloat outputLabelMinHeight = 65;
static const CGFloat outputLabelMaxHeight = 80;

static const CGFloat buttonsMinHeight = 50;
static const CGFloat buttonsMaxHeight = 75;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *resetIntroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetIntroButton setTitle:@"Reset Intro" forState:UIControlStateNormal];
    [resetIntroButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [resetIntroButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:UIControlStateNormal];
    [resetIntroButton addTarget:self action:@selector(resetIntro) forControlEvents:UIControlEventTouchUpInside];
    self.resetIntroButton = resetIntroButton;
    [self.view addSubview:self.resetIntroButton];

    
    UILabel *outputLabel = [UILabel new];
    [outputLabel setBackgroundColor:[UIColor gravityPurple]];
    [outputLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:36]];
    [outputLabel setTextColor:[UIColor whiteColor]];
    [outputLabel setTextAlignment:NSTextAlignmentCenter];
    [outputLabel setNumberOfLines:1];
    [outputLabel setAdjustsFontSizeToFitWidth:YES];
    self.outputLabel = outputLabel;
    [self.outputLabel setText:@"--"];
    [self.view addSubview:self.outputLabel];
    
    UIButton *tareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[UIColor roverRed]] forState:UIControlStateNormal];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[[UIColor roverRed] add_colorWithBrightness:0.8]] forState:UIControlStateHighlighted];
    [tareButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:24]];
    [tareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tareButton setTitle:@"tare" forState:UIControlStateNormal];
    self.tareButton = tareButton;
    [self.view addSubview:tareButton];
    
    UIButton *unitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[UIColor lunarLilac]] forState:UIControlStateNormal];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[[UIColor lunarLilac] add_colorWithBrightness:0.75]] forState:UIControlStateHighlighted];
    [unitsButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:24]];
    [unitsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [unitsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [unitsButton setTitle:@"units" forState:UIControlStateNormal];
    self.unitsButton = unitsButton;
    [self.view addSubview:unitsButton];
    
    
    self.instructions = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
    
    [self createConstraints];
}

- (void) createConstraints {
    
    [self.resetIntroButton makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (id)self.topLayoutGuide;
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(topLayoutGuide.bottom);
        make.height.equalTo(@44);
    }];
    
    [self.tareButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
        
        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(buttonsMaxHeight));
        make.height.greaterThanOrEqualTo(@(buttonsMinHeight));
    }];
    
    [self.unitsButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view.width).multipliedBy(0.5);

        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(buttonsMaxHeight));
        make.height.greaterThanOrEqualTo(@(buttonsMinHeight));
    }];
    
    [self.outputLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.tareButton.top);
        make.width.equalTo(self.view);
        
        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(outputLabelMaxHeight));
        make.height.greaterThanOrEqualTo(@(outputLabelMinHeight));
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:InstructionsCompleted] boolValue]) {
        [self showIntroAnimated:NO];
    }
    
    [self setCurrentWeight:4.123991991234];
}

#pragma mark UI Updating

- (void) setCurrentWeight:(CGFloat)grams {
    static NSMassFormatter *massFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        massFormatter = [NSMassFormatter new];
        [massFormatter setUnitStyle:NSFormattingUnitStyleShort];
    });
    
    NSString *massString = [massFormatter stringFromValue:grams unit:NSMassFormatterUnitGram];
    
    [self.outputLabel setText:massString];
}

#pragma mark Intro

- (void) showIntroAnimated:(BOOL)animated {
    [self presentViewController:self.instructions animated:animated completion:^{
        
    }];
}

- (void) resetIntro {
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:InstructionsCompleted];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self showIntroAnimated:YES];
}

#pragma mark Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
