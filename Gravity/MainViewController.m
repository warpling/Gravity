//
//  ViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "MainViewController.h"
#import "InstructionsViewController.h"
#import "CalibrationViewController.h"
#import "WeighArea.h"
#import "UIImage+ImageWithColor.h"
#import "Masonry.h"
#import "UIColor+Additions.h"
#import "CoinHolder.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructionsVC;
@property (strong, nonatomic) CalibrationViewController *calibrationVC;

@property (strong, nonatomic) WeighArea *weighArea;
@property (strong, nonatomic) UILabel *debugLabel;
@property (strong, nonatomic) UILabel *outputLabel;
@property (strong, nonatomic) UIButton *tareButton;
@property (strong, nonatomic) UIButton *unitsButton;

@property (strong, nonatomic) CoinHolder *coinHolder;

@end


@implementation MainViewController

static const CGFloat outputLabelMinHeight = 65;
static const CGFloat outputLabelMaxHeight = 90;

static const CGFloat buttonsMinHeight = 50;
static const CGFloat buttonsMaxHeight = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scale = [Scale new];
    [self.scale setScaleDisplayDelegate:self];
    

    self.weighArea = [WeighArea new];
    self.weighArea.weightAreaDelegate = self;
    [self.view addSubview:self.weighArea];
    
//    self.coinHolder = [[CoinHolder alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 50) coinType:CoinTypeUSQuarter numCoins:4];
//    self.coinHolder.coinSelectionDelegate = self;
//    [self.view addSubview:self.coinHolder];
    
    #ifdef DEBUG
    UILabel *debugLabel = [UILabel new];
    [debugLabel setBackgroundColor:[[UIColor gravityPurple] colorWithAlphaComponent:0.9]];
    [debugLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:14]];
    [debugLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [debugLabel setTextAlignment:NSTextAlignmentLeft];
    [debugLabel setNumberOfLines:0];
    [debugLabel setAdjustsFontSizeToFitWidth:YES];
    self.debugLabel = debugLabel;
    [self.debugLabel setText:@"––––"];
    [self.view addSubview:self.debugLabel];
    #endif
    
    UILabel *outputLabel = [UILabel new];
    [outputLabel setBackgroundColor:[UIColor gravityPurpleDark]];
    [outputLabel setFont:[UIFont fontWithName:AvenirNextBold size:42]];
    [outputLabel setTextColor:[UIColor whiteColor]];
    [outputLabel setTextAlignment:NSTextAlignmentCenter];
    [outputLabel setNumberOfLines:1];
    [outputLabel setAdjustsFontSizeToFitWidth:YES];
    self.outputLabel = outputLabel;
    [self.outputLabel setText:@"––––"];
    [self.view addSubview:self.outputLabel];
    
    UIButton *tareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[UIColor gravityPurple]] forState:UIControlStateNormal];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[[UIColor gravityPurple] add_colorWithBrightness:0.8]] forState:UIControlStateHighlighted];
    [tareButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:30]];
    [tareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tareButton setTitleColor:[UIColor gravityPurpleDark] forState:UIControlStateNormal];
    [tareButton setTitle:@"zero" forState:UIControlStateNormal];
    [tareButton addTarget:self.scale action:@selector(tare) forControlEvents:UIControlEventTouchUpInside];
    self.tareButton = tareButton;
    [self.view addSubview:tareButton];
    
    UIButton *unitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[UIColor gravityPurple]] forState:UIControlStateNormal];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[[UIColor gravityPurple] add_colorWithBrightness:0.75]] forState:UIControlStateHighlighted];
    [unitsButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:30]];
    [unitsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [unitsButton setTitleColor:[UIColor gravityPurpleDark] forState:UIControlStateNormal];
    [unitsButton setTitle:@"units" forState:UIControlStateNormal];
    [unitsButton addTarget:self.scale action:@selector(switchUnits) forControlEvents:UIControlEventTouchUpInside];
    self.unitsButton = unitsButton;
    [self.view addSubview:unitsButton];
    
    
    self.instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];

    self.calibrationVC = [CalibrationViewController new];
    self.calibrationVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.calibrationVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self createConstraints];
}

- (void) createConstraints {
    
    [self.weighArea makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (UIView*)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.bottom);
        #ifdef DEBUG
        make.bottom.equalTo(self.debugLabel.top);
        #else
        make.bottom.equalTo(self.outputLabel.top);
        #endif
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
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
        
        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(outputLabelMaxHeight));
        make.height.greaterThanOrEqualTo(@(outputLabelMinHeight));
    }];
    
    #ifdef DEBUG
    [self.debugLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.outputLabel.top);
    }];
    #endif
}

- (void) viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:InstructionsCompleted] boolValue]) {
        [self showIntroAnimated:NO];
    }
}

#pragma mark ScaleDisplayDelegate

- (void) displayStringDidChange:(NSString*)displayString {
    [self.outputLabel setText:displayString];
}

#pragma mark WeighAreaEventsDelegate

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce {
    self.weighArea.backgroundColor = [UIColor moonGrey];
    [self.scale recordNewForce:force];
}

- (void) multipleTouchesDetected {
    self.weighArea.backgroundColor = [UIColor roverRed];
}

- (void) debugDataUpdated:(NSString*)debugData {
    [self.debugLabel setText:debugData];
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
    [self presentViewController:self.instructionsVC animated:animated completion:nil];
}

- (void) showCalibrationScreenAnimated:(BOOL)animated {
    [self presentViewController:self.calibrationVC animated:animated completion:nil];
}

- (void) resetIntro {
//    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:InstructionsCompleted];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self showIntroAnimated:YES];
    
    [self showCalibrationScreenAnimated:YES];
}

#pragma mark Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Shaking
-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self resetIntro];
    }
}

#pragma mark Temporary

- (void) coinSelected:(NSUInteger)coinIndex {
    [self.scale recordCalibrationForCountNum:coinIndex];
}

#pragma mark Trait Collection
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    UIForceTouchCapability forceTouchCapability = [self.traitCollection forceTouchCapability];
    switch (forceTouchCapability) {
        case UIForceTouchCapabilityUnknown:
            NSLog(@"Force Touch support unknown");
            break;
        case UIForceTouchCapabilityUnavailable:
            NSLog(@"Force Touch unavailable");
            break;
        case UIForceTouchCapabilityAvailable:
            NSLog(@"Force Touch enabled");
            break;
    }
    
    if (forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self.weighArea setForceAvailable:YES];
    } else {
        [self.weighArea setForceAvailable:NO];
    }
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
