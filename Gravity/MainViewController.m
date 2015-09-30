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
#import "SpoonView.h"
#import "RecalibrateBar.h"
#import "Track.h"
#import "DeviceUnsupportedViewController.h"
#import "UIDevice+Platform.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructionsVC;
@property (strong, nonatomic) CalibrationViewController *calibrationVC;

@property (strong, nonatomic) RecalibrateBar *recalibrateBar;

@property (strong, nonatomic) WeighArea *weighArea;
@property (strong, nonatomic) SpoonView *spoonView;
@property (strong, nonatomic) UILabel *debugLabel;
@property (strong, nonatomic) ScaleDisplay *scaleDisplay;
@property (strong, nonatomic) UIButton *tareButton;
@property (strong, nonatomic) UIButton *unitsButton;
@property (strong, nonatomic) UIView *buttonDivider;

@end


@implementation MainViewController

static const CGFloat scaleDisplayMinHeight = 65;
static const CGFloat scaleDisplayMaxHeight = 90;

static const CGFloat buttonsMinHeight = 50;
static const CGFloat buttonsMaxHeight = 60;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSavedScale];
    }
    return self;
}

- (void) loadSavedScale {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedScale;
    if ((encodedScale = [defaults objectForKey:Gravity_ScaleKey])) {
        Scale *scale = [NSKeyedUnarchiver unarchiveObjectWithData:encodedScale];
        self.scale = scale;
        NSLog(@"Scale restored from saved scale");
    }
    else {
        self.scale = [Scale new];
        NSLog(@"New scale created");
    }
    
    [self.scale addScaleOutputDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor gravityPurple]];

    self.weighArea = [WeighArea new];
    [self.weighArea setWeightAreaDelegate:self];
    [self.weighArea setTouchCirclesEnabled:YES];
    [self.view addSubview:self.weighArea];
    
    self.spoonView = [SpoonView new];
    [self.spoonView setUserInteractionEnabled:NO];
    [self.view addSubview:self.spoonView];
    
    #ifdef DEBUG
    UILabel *debugLabel = [UILabel new];
    [debugLabel setFont:[UIFont systemFontOfSize:14]];
    [debugLabel setTextColor:[UIColor gravityPurpleDark]];
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
    [self.scale addScaleOutputDelegate:self.scaleDisplay];
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
    
    self.recalibrateBar = [RecalibrateBar new];
    [self.recalibrateBar setUserInteractionEnabled:YES];
    __weak __typeof__(self) weakSelf = self;
    [self.recalibrateBar setButtonAction:^{
        [weakSelf showCalibrationScreenAnimated:YES];
    }];
    [self.view addSubview:self.recalibrateBar];
    
    [self setVisualsToErrorState:NO];

    [self createConstraints];
}

- (void) createConstraints {
    
    [self.recalibrateBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_topLayoutGuideBottom).with.offset(4);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.weighArea makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (UIView*)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.bottom);
        make.bottom.equalTo(self.scaleDisplay.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.spoonView makeConstraints:^(MASConstraintMaker *make) {
        // Try to guarantee that the center of the spoon bowl is in the center of the screen
        make.left.equalTo(self.view.centerX).with.offset(-132);
        make.centerY.equalTo(self.weighArea);
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
        make.height.lessThanOrEqualTo(@(scaleDisplayMaxHeight));
        make.height.greaterThanOrEqualTo(@(scaleDisplayMinHeight));
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
    
    // TODO: this is a hack to fix a bug where a calibration touch get's stuck on the MainVC's WeighArea
    [self.weighArea reset];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:Gravity_InstructionsCompleted] boolValue]) {
        [self showIntroAnimated:NO];
    }
}

#pragma mark WeighAreaEventsDelegate

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce {
    [self setVisualsToErrorState:NO];
    
    // TODO: It's unclear if this value ever changes, so we'll just record it everytime
    [self.scale setMaximumPossibleForce:maxiumPossibleForce];
    [self.scale recordNewForce:force];
}

- (void) multipleTouchesDetected {
    [self setVisualsToErrorState:YES];
    [self.scale invalidateCurrentForce];
}

- (void) allTouchesEnded {
    [self setVisualsToErrorState:NO];
    [self.scale invalidateCurrentForce];
}

- (void) debugDataUpdated:(NSString*)debugData {
    [self.debugLabel setText:debugData];
}

#pragma UI Events

- (void) setVisualsToErrorState:(BOOL)errorState {
    if (errorState) {
        [self.view setBackgroundColor:[UIColor roverRedDark]];
        [self.weighArea setBackgroundColor:[UIColor roverRed]];

        [self.recalibrateBar setFillColor:[UIColor roverRedDark]];
        [self.recalibrateBar setTextColor:[UIColor roverRed]];
    } else {
        [self.view setBackgroundColor:[UIColor gravityPurple]];
        [self.weighArea setBackgroundColor:[UIColor moonGrey]];

        [self.recalibrateBar setFillColor:[UIColor gravityPurple]];
        [self.recalibrateBar setTextColor:[UIColor moonGrey]];
    }
}

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
    
    [Track scaleSwitchedUnits:self.scaleDisplay.massUnit];
    [[NSUserDefaults standardUserDefaults] setValue:@([self.scaleDisplay massUnit]) forKey:Gravity_DefaultMassDisplayUnits];
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
    
    self.instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
    self.instructionsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.instructionsVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    self.calibrationVC = [CalibrationViewController new];
    self.calibrationVC.spoonCalibrationDelegate = self;
    
    [self.instructionsVC setupWithCalibrationViewController:self.calibrationVC];

    [self presentViewController:self.instructionsVC animated:animated completion:nil];
}

- (void) showCalibrationScreenAnimated:(BOOL)animated {

    self.calibrationVC = [CalibrationViewController new];
    self.calibrationVC.spoonCalibrationDelegate = self;
    self.calibrationVC.canBeCancelled = YES;
    self.calibrationVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.calibrationVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    __weak __typeof__(self) weakSelf = self;
    [self.calibrationVC setOnCalibrationFinished:^{
        [weakSelf.calibrationVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    if (![[self.presentedViewController class] isSubclassOfClass:[CalibrationViewController class]]) {
        [self presentViewController:self.calibrationVC animated:animated completion:nil];
    }
}

- (void) resetIntro {
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:Gravity_InstructionsCompleted];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self showIntroAnimated:YES];
    
//    [self showCalibrationScreenAnimated:YES];
}

- (void) showDeviceNotSupportedWarning {
    DeviceUnsupportedViewController *deviceUnsupportedVC = [DeviceUnsupportedViewController new];
    [self presentViewController:deviceUnsupportedVC animated:NO completion:nil];
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
    #ifdef DEBUG
    if (motion == UIEventSubtypeMotionShake)
    {
//        [self setDebugInfoBarEnabled:!self.debugInfoBarEnabled];
        [self resetIntro];
//        [self showDeviceNotSupportedWarning];
    }
    #endif
}

#pragma mark ScaleOutputDelegate {
- (void) currentWeightAtMaximum {
    [self.view setBackgroundColor:[UIColor roverRedDark]];
    [self.weighArea setBackgroundColor:[UIColor roverRed]];
}

- (void) currentWeightDidChange:(CGFloat)grams {
    [self.view setBackgroundColor:[UIColor gravityPurple]];
    [self.weighArea setBackgroundColor:[UIColor moonGrey]];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:Gravity_ForceTouchCapabilityBecameUnknown object:nil];
            break;
        case UIForceTouchCapabilityUnavailable:
            NSLog(@"Force Touch unavailable");
            [[NSNotificationCenter defaultCenter] postNotificationName:Gravity_ForceTouchCapabilityBecameUnavailable object:nil];

            if ([UIDevice has3DTouch]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"3D Touch is Disabled" message:@"It looks like you've disabled 3D Touch in Settings. You'll need to enable it in order to use Gravity.\n\nYou can find this Setting under:\nGeneral > Accessibility > 3D Touch" preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"Take me to Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    NSURL *settingsURL = [NSURL URLWithString:@"prefs:root=General"];
//                    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
//                        [[UIApplication sharedApplication] openURL:settingsURL];
//                    }
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Accessibility"]];
//                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil]];

                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [self showDeviceNotSupportedWarning];
            }
            break;
        case UIForceTouchCapabilityAvailable:
            NSLog(@"Force Touch enabled");
            [[NSNotificationCenter defaultCenter] postNotificationName:Gravity_ForceTouchCapabilityBecameAvailable object:nil];
            break;
    }
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
