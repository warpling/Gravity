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
#import "ScaleDisplay.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructionsVC;
@property (strong, nonatomic) CalibrationViewController *calibrationVC;

@property (strong, nonatomic) WeighArea *weighArea;
@property (strong, nonatomic) UILabel *debugLabel;
@property (strong, nonatomic) ScaleDisplay *scaleDisplay;
@property (strong, nonatomic) UIButton *tareButton;
@property (strong, nonatomic) UIButton *unitsButton;
@property (strong, nonatomic) UIView *buttonDivider;

@property (strong, nonatomic) CoinHolder *coinHolder;

@end


@implementation MainViewController

static const CGFloat outputLabelMinHeight = 65;
static const CGFloat outputLabelMaxHeight = 90;

static const CGFloat buttonsMinHeight = 50;
static const CGFloat buttonsMaxHeight = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scale = [[Scale alloc] initWithSpoon:nil];
    
    [self.view setBackgroundColor:[UIColor gravityPurple]];

    self.weighArea = [WeighArea new];
    [self.weighArea setWeightAreaDelegate:self];
    [self.weighArea setTouchCirclesEnabled:YES];
    [self.weighArea setBackgroundColor:[UIColor moonGrey]];
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
    [debugLabel setHidden:!self.debugInfoBarEnabled];
    self.debugLabel = debugLabel;
    [self.debugLabel setText:@"––––"];
    [self.view addSubview:self.debugLabel];
    #endif
    
    ScaleDisplay *scaleDisplay = [ScaleDisplay new];
    self.scaleDisplay = scaleDisplay;
    [self.scale setScaleOutputDelegate:self.scaleDisplay];
    [self.view addSubview:self.scaleDisplay];
    
    UIButton *tareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[UIColor gravityPurple]] forState:UIControlStateNormal];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[[UIColor gravityPurple] add_colorWithBrightness:0.8]] forState:UIControlStateHighlighted];
    [tareButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:30]];
    [tareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tareButton setTitleColor:[UIColor gravityPurpleDark] forState:UIControlStateNormal];
    [tareButton setTitle:@"zero" forState:UIControlStateNormal];
    [tareButton addTarget:self action:@selector(tare) forControlEvents:UIControlEventTouchUpInside];
    self.tareButton = tareButton;
    [self.view addSubview:tareButton];
    
    UIButton *unitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[UIColor gravityPurple]] forState:UIControlStateNormal];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[[UIColor gravityPurple] add_colorWithBrightness:0.75]] forState:UIControlStateHighlighted];
    [unitsButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:30]];
    [unitsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [unitsButton setTitleColor:[UIColor gravityPurpleDark] forState:UIControlStateNormal];
    [unitsButton setTitle:@"units" forState:UIControlStateNormal];
    [unitsButton addTarget:self action:@selector(switchUnits) forControlEvents:UIControlEventTouchUpInside];
    self.unitsButton = unitsButton;
    [self.view addSubview:unitsButton];
    
    UIView *buttonDivider = [UIView new];
    [buttonDivider setBackgroundColor:[UIColor gravityPurpleDark]];
    self.buttonDivider = buttonDivider;
    [self.view addSubview:buttonDivider];
    
    
    self.instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];

    self.calibrationVC = [CalibrationViewController new];
    self.calibrationVC.spoonCalibrationDelegate = self;
    self.calibrationVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.calibrationVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self createConstraints];
}

- (void) createConstraints {
    
    [self.weighArea makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (UIView*)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.bottom);
        make.bottom.equalTo(self.scaleDisplay.top);
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
    
    [self.scaleDisplay makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.tareButton.top);
        
        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(outputLabelMaxHeight));
        make.height.greaterThanOrEqualTo(@(outputLabelMinHeight));
    }];
    
    [self.buttonDivider makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = 2;
        CGFloat verticalInset = 5;
        make.width.equalTo(@(width));
        make.top.equalTo(self.tareButton).with.offset(verticalInset);
        make.bottom.equalTo(self.tareButton).with.offset(-verticalInset);
        make.left.equalTo(self.tareButton.right).with.offset(-(width/2));
    }];
    
    #ifdef DEBUG
    [self.debugLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.scaleDisplay.top);
    }];
    #endif
}

- (void) viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:InstructionsCompleted] boolValue]) {
        [self showIntroAnimated:NO];
    }
    
    [self setDebugInfoBarEnabled:NO];
}

#pragma mark WeighAreaEventsDelegate

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce {
    self.weighArea.backgroundColor = [UIColor moonGrey];

    // TODO: It's unclear if this value ever changes, so we'll just record it everytime
    [self.scale setMaximumPossibleForce:maxiumPossibleForce];
    [self.scale recordNewForce:force];
}

- (void) multipleTouchesDetected {
    self.weighArea.backgroundColor = [UIColor roverRed];
}

- (void) allTouchesEnded {
    self.weighArea.backgroundColor = [UIColor moonGrey];
}

- (void) debugDataUpdated:(NSString*)debugData {
    [self.debugLabel setText:debugData];
}

#pragma UI Events

- (void) tare {
    [self.scale tare];
}

- (void) switchUnits {
    if ([self.scaleDisplay massUnit] == NSMassFormatterUnitGram) {
        [self.scaleDisplay setMassUnit:NSMassFormatterUnitOunce];
    }
    else {
        [self.scaleDisplay setMassUnit:NSMassFormatterUnitGram];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@([self.scaleDisplay massUnit]) forKey:DefaultMassDisplayUnits];
}

#pragma mark UI Updating

- (void) setCurrentWeight:(CGFloat)grams {
    [self.scaleDisplay setWeight:grams];
}

- (void) setDebugInfoBarEnabled:(BOOL)debugInfoBarEnabled {
    _debugInfoBarEnabled = debugInfoBarEnabled;
    self.debugLabel.hidden = !debugInfoBarEnabled;
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

#pragma mark SpoonCalibrationDelegate
- (void) spoonCalibrated:(Spoon *)spoon {
    [self.scale setSpoon:spoon];
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
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
