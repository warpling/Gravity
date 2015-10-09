//
//  CalibrationViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "CalibrationViewController.h"
#import "CKShapeView.h"
#import "SpoonView.h"
#import "Masonry.h"
#import "GhostButton.h"
#import "UIStackView+RemoveAllArrangedSubviews.h"
#import "CoinInfo.h"
#import "Track.h"

@interface CalibrationViewController ()

typedef NS_ENUM(NSInteger, CalibrationStep) {
    CalibrationStepLayFlat,
    CalibrationStepWeighSpoon,
    CalibrationStepAddCoins,
    CalibrationStepRemoveSpoon,
    CalibrationStepFinish
};

@property (nonatomic) CalibrationStep calibrationStep;

@property (strong, nonatomic) Spoon *spoon;
@property (strong, nonatomic) Spoon *altSpoon;

@property (strong, nonatomic) WeighArea *weighArea;

@property (strong, nonatomic) UIView *statusBarBackground;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) SpoonView *spoonView;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) CoinHolder *coins;

@property (strong, nonatomic) UIStackView *buttonBar;
@property (strong, nonatomic) GhostButton *cancelButton;
@property (strong, nonatomic) GhostButton *nextButton;
@property (strong, nonatomic) GhostButton *resetButton;
@property (strong, nonatomic) GhostButton *finishButton;

@end


@implementation CalibrationViewController

//static CGFloat const staleTimestampThreshold = 0.2;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.spoon = [Spoon new];
    self.altSpoon = [Spoon new];
    
    [self.view setBackgroundColor:[UIColor gravityPurple]];
    
    self.statusBarBackground = [UIView new];
    [self.statusBarBackground setBackgroundColor:[UIColor gravityPurpleDark]];
    [self.view addSubview:self.statusBarBackground];
    
    UILabel *headerLabel = [UILabel new];
    headerLabel.backgroundColor = [UIColor gravityPurpleDark];
    [headerLabel setTextColor:[UIColor gravityPurple]];
    [headerLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setNumberOfLines:0];
    [headerLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.headerLabel = headerLabel;
    [self.view addSubview:self.headerLabel];

    UILabel *topLabel = [UILabel new];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setNumberOfLines:0];
    [topLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.topLabel = topLabel;
    [self.view addSubview:self.topLabel];
    
    UILabel *bottomLabel = [UILabel new];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomLabel setNumberOfLines:0];
    [bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.bottomLabel = bottomLabel;
    [self.view addSubview:self.bottomLabel];
    
    
    self.coins = [[CoinHolder alloc] initWithFrame:CGRectZero coinType:CoinTypeUSQuarter numCoins:4];
    self.coins.coinSelectionDelegate = self;
    [self.view addSubview:self.coins];
    
    [self setupButtonBar];
    
    
    // Weigh area
    self.weighArea = [WeighArea new];
    self.weighArea.weightAreaDelegate = self;
    [self.weighArea setTouchCirclesEnabled:YES];
    [self.view addSubview:self.weighArea];
    
    self.spoonView = [SpoonView new];
    [self.spoonView setUserInteractionEnabled:NO];
    [self.view addSubview:self.spoonView];

    
    [self setupViewConstraints];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.spoon = [Spoon new];
    self.altSpoon = [Spoon new];
    [self.coins reset];
    
    [self setCalibrationStep:CalibrationStepWeighSpoon];
}

- (void) viewDidAppear:(BOOL)animated {
    [Track calibrationViewed];
    [Track calibrationBegan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

#pragma mark - The only way out

- (void) applicationWillTerminate:(NSNotification*)notification {
    [Track calibrationInterupted];
}

#pragma mark - Views

- (void) setupButtonBar {
    UIStackView *buttonBar = [UIStackView new];
    [buttonBar setAlignment:UIStackViewAlignmentCenter];
    [buttonBar setAxis:UILayoutConstraintAxisHorizontal];
    [buttonBar setDistribution:UIStackViewDistributionEqualSpacing];
    [buttonBar setSpacing:30];
    self.buttonBar = buttonBar;

    GhostButton *cancelButton = [GhostButton new];
    cancelButton.fillColor = [UIColor gravityPurple];
    cancelButton.borderColor = [UIColor gravityPurpleDark];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(calibrationCancelled) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;
    
    GhostButton *nextButton = [GhostButton new];
    nextButton.fillColor = [UIColor gravityPurple];
    nextButton.borderColor = [UIColor whiteColor];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton = nextButton;

    GhostButton *resetButton = [GhostButton new];
    resetButton.fillColor = [UIColor gravityPurple];
    resetButton.borderColor = [UIColor gravityPurpleDark];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    self.resetButton = resetButton;
    
    GhostButton *finishButton = [GhostButton new];
    finishButton.fillColor = [UIColor whiteColor];
    finishButton.borderColor = [UIColor gravityPurple];
    [finishButton setTitle:@"Finish" forState:UIControlStateNormal];
    self.finishButton = finishButton;
    
    [self.view addSubview:self.buttonBar];
}

- (void) setupViewConstraints {
    
    CGFloat labelHorizontalMargin = 15;
    
    [self.statusBarBackground makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.headerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBarBackground.bottom);
        make.topMargin.equalTo(self.mas_topLayoutGuideBottom).multipliedBy(2).priorityHigh();
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(55));
    }];
    
    [self.topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.bottom);
        make.bottom.equalTo(self.spoonView.top);
        make.left.equalTo(self.view).with.offset(labelHorizontalMargin);
        make.right.equalTo(self.view).with.offset(-labelHorizontalMargin);
    }];
    
    [self.spoonView makeConstraints:^(MASConstraintMaker *make) {
        // Try to guarantee that the center of the spoon bowl is in the center of the screen
        make.left.equalTo(self.view.centerX).with.offset(-132);
        // Approximately the height of the bottom buttons in the main view
        make.centerY.equalTo(self.view).with.offset(-62);
    }];
    
    [self.bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@100);
        make.top.greaterThanOrEqualTo(self.spoonView.bottom).priorityHigh();
        make.top.equalTo(self.spoonView.bottom).with.offset(40).priorityLow();
        make.bottom.equalTo(self.coins.top);
        make.left.equalTo(self.view).with.offset(labelHorizontalMargin);
        make.right.equalTo(self.view).with.offset(-labelHorizontalMargin);
    }];
    
    [self.coins makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLabel.bottom);
        make.bottom.equalTo(self.buttonBar.top);
        make.centerX.equalTo(self.view);
        make.height.lessThanOrEqualTo(@100);
        make.height.equalTo(self.view).priorityLow();
        make.width.equalTo(self.view).with.offset(-20);
    }];
    
    [self.buttonBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).priorityHigh();
        make.centerX.equalTo(self.view);
        make.height.lessThanOrEqualTo(@100);
    }];
    
    
    // Transparent weigh area
    [self.weighArea makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.bottom);
        make.bottom.equalTo(self.coins.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

#pragma mark - Calibration State

- (void) setCalibrationStep:(CalibrationStep)calibrationStep {
    _calibrationStep = calibrationStep;
    
    // Defaults
    [self.headerLabel setText:@""];
    [self.spoonView setHidden:NO];
    [self.topLabel setText:@""];
    [self.bottomLabel setText:@""];
    [self.headerLabel setTextColor:[UIColor gravityPurple]];

    switch (calibrationStep) {
            
        case CalibrationStepLayFlat:
        {
            // NSLog(@">> Lay Flat");
            
            [self.headerLabel setText:@"Set device on flat surface"];
            [self.headerLabel setTextColor:[UIColor whiteColor]];
            
            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            if (self.canBeCancelled) {
                [self.buttonBar addArrangedSubview:self.cancelButton];   
            }
            [self.buttonBar addArrangedSubview:self.nextButton];

            [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.nextButton addTarget:self action:@selector(phoneHasBeenLayedFlat) forControlEvents:UIControlEventTouchUpInside];
            
            [self.spoonView setHidden:YES];
            [self.coins setHidden:YES];
            
            break;
        }
            
        case CalibrationStepWeighSpoon:
        {
            // NSLog(@">> Weigh Spoon");

            [self.headerLabel setText:@"Set device on flat surface"];

            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            if (self.canBeCancelled) {
                [self.buttonBar addArrangedSubview:self.cancelButton];
            }
            [self.buttonBar addArrangedSubview:self.nextButton];
            
            [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.nextButton addTarget:self action:@selector(recordSpoonForce) forControlEvents:UIControlEventTouchUpInside];
            
            [self.topLabel setText:@"Gently place spoon below"];
            [self.coins setHidden:YES];
            
            break;
        }
            
        case CalibrationStepAddCoins:
        {
            // NSLog(@">> Add Coins");

            [self.headerLabel setText:@"Set device on flat surface"];
   
            [self.resetButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.resetButton addTarget:self action:@selector(resetCalibration) forControlEvents:UIControlEventTouchUpInside];

            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            [self.buttonBar addArrangedSubview:self.resetButton];
            
            [self.coins setHidden:NO];
            
            switch ([self.coins activeCoinButtonIndex]) {
                case 0:
                    [self.bottomLabel setText:@"Drop one quarter into the spoon then gently touch the icon below."];
                    break;
                case 1:
                    [self.bottomLabel setText:@"Drop another!\nTry to not touch the spoon.👇"];
                    break;
                case 2:
                    [self.bottomLabel setText:@"Another one!\n Press the buttons gently 👌"];
                    break;
                case 3:
                    [self.bottomLabel setText:@"One last time!\n"];
                    break;
                default:
                    [self.bottomLabel setText:@"Place one quarter into the spoon and touch the icon below."];
            }

            break;
        }
            
        case CalibrationStepRemoveSpoon:
        {
            // NSLog(@">> Remove Spoon");
            
            [self.headerLabel setText:@"Set device on flat surface"];

            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            
            [self.headerLabel setText:@"Remove spoon to continue"];
            [self.coins setHidden:YES];
            [self.bottomLabel setText:@"Remove spoon to continue 🍴"];

            break;
        }
            
        case CalibrationStepFinish:
        {
            // NSLog(@">> Done");

            [self.headerLabel setText:@"Set device on flat surface"];
            
            CGFloat rSquared = self.spoon.bestFit.rSquared;
            if (rSquared >= 0.985) {
                [self.bottomLabel setText:@"Nice job calibrating! You're ready to go!"];
            }
            else if (rSquared >= 0.970) {
                [self.bottomLabel setText:@"You're calibrated."];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Calibrate again?" message:@"Our math is saying that your scale should work fine, but your accuracy may be improved if you recalibrate. Want to try recalibrating?" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Let's recalibrate!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self resetCalibration];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"No thanks" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];

            }
            else {
                [self.bottomLabel setText:@""];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oh no!" message:@"Our math is saying that the scale would be more accurate if we recalibrated.\n\nWe highly recommend recalibrating, otherwise your results may be innaccurate!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Let's recalibrate!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self resetCalibration];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"I understand" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            [self.resetButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.resetButton addTarget:self action:@selector(resetCalibration) forControlEvents:UIControlEventTouchUpInside];

            [self.finishButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.finishButton addTarget:self action:@selector(calibrationFinished) forControlEvents:UIControlEventTouchUpInside];

            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            [self.buttonBar addArrangedSubview:self.resetButton];
            [self.buttonBar addArrangedSubview:self.finishButton];
            
            [self.coins setHidden:YES];
            [self.bottomLabel setText:@"You're calibrated and ready!"];

            break;
        }
    }
}

#pragma mark - Button actions

- (void) phoneHasBeenLayedFlat {
    [self setCalibrationStep:CalibrationStepWeighSpoon];
}

- (void) resetCalibration {
    self.spoon = [Spoon new];
    self.altSpoon = [Spoon new];
    [self.coins reset];
    [self setCalibrationStep:CalibrationStepWeighSpoon];
    
    [Track calibrationReset];
}

#pragma mark - Calibration actions

- (void) recordSpoonForce {
    
    // record it
    UITouch *lastActiveTouch = self.weighArea.lastActiveTouch;
//    CGFloat systemUptime = [[NSProcessInfo processInfo] systemUptime];
//    if ((systemUptime - touch.timestamp) < staleTimestampThreshold) {
    if (lastActiveTouch) {
        [self.spoon recordBaseForce:lastActiveTouch.force];
        
        dispatch_async_main_after(0.1, ^{
            UITouch *lastActiveTouch = self.weighArea.lastActiveTouch;
            [self.altSpoon recordBaseForce:lastActiveTouch.force];
        });
        //    [self.spoon recordCalibrationForce:0 forKnownWeight:0];

        [self setCalibrationStep:CalibrationStepAddCoins];
    }
    else {
//        NSLog(@"Record spoon weight: touch was stale by %fs", (systemUptime - lastActiveTouch.timestamp));

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No spoon?" message:@"Gravity isn't detecting a metal spoon on the screen. Try slightly dampening the back of the spoon or using a different spoon." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        [Track calibrationErrorNoSpoonDetected];
    }
}


- (void) calibrationFinished {
    [self.spoonCalibrationDelegate spoonCalibrated:self.spoon];
    
//    #ifdef DEBUG
    [Track spoonCalibrated:self.spoon];
//    #endif
    
    if (self.onCalibrationFinished) {
        self.onCalibrationFinished();
    }
}

- (void) calibrationCancelled {
    if (self.onCalibrationFinished) {
        self.onCalibrationFinished();
    }
}

#pragma mark - WeighAreaEventDelegate

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce {
    [self.weighArea setBackgroundColor:[UIColor clearColor]];
}

- (void) allTouchesEnded {
    // TODO: touches could potentially end before CalibrationStepRemoveSpoon and then the user would never be able to advance without resetting
    if (self.calibrationStep == CalibrationStepRemoveSpoon) {
        
        LinearFunction *bestFit = [self.spoon bestFit];
        // NSLog(@"Spoon: %@", bestFit);
        
        LinearFunction *altBestFit = [self.altSpoon bestFit];
        // NSLog(@"Alt Spoon: %@", altBestFit);
     
        // If the alternate spoon has a better fit value, use it
        // This is what we call "fuzzy logic"
        if (altBestFit.rSquared > bestFit.rSquared) {
            self.spoon = self.altSpoon;
        }
        
        if (bestFit.rSquared < 0.995) {
            NSLog(@"Previously you would have trashed this spoon");
        }
        
        [self setCalibrationStep:CalibrationStepFinish];
        [Track calibrationEndedWithSlope:bestFit.slope yIntercept:bestFit.yIntercept rSquared:bestFit.rSquared];
    }
}

- (void) multipleTouchesDetected {
    [self.weighArea setBackgroundColor:[UIColor roverRed]];
}

#pragma mark CoinSelectionDelegate

- (void) coinSelected:(NSUInteger)coinIndex {
    
    // We call this again so the coin specific text refreshes
    [self setCalibrationStep:CalibrationStepAddCoins];
    
    // record it
    CGFloat knownWeight = (coinIndex+1) * [CoinInfo knownWeightForCoinType:[self.coins coinType]];
    
    UITouch *lastActiveTouch = self.weighArea.lastActiveTouch;
    // NSLog(@"TouchUp  : %f", lastActiveTouch.force);
    dispatch_async_main_after(0.1, ^{
        UITouch *lastActiveTouch = self.weighArea.lastActiveTouch;
        [self.altSpoon recordCalibrationForce:lastActiveTouch.force forKnownWeight:knownWeight];
        // NSLog(@"TouchUp- : %f", lastActiveTouch.force);
    });
//    CGFloat systemUptime = [[NSProcessInfo processInfo] systemUptime];
//    if ((systemUptime - touch.timestamp) < staleTimestampThreshold) {
    if (lastActiveTouch) {
        [self.spoon recordCalibrationForce:lastActiveTouch.force forKnownWeight:knownWeight];
    }
    else {
//        NSLog(@"Record coin %d: touch was stale by %fs", (int)(coinIndex+1), (systemUptime - touch.timestamp));
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No spoon?" message:@"Gravity isn't detecting a metal spoon on the screen. Try placing the spoon again or consider reseting with a new spoon." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Let me try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Reset the button
            [self.coins setActiveCoinButtonIndex:(self.coins.activeCoinButtonIndex-1)];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Reset Calibration" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [alert dismissViewControllerAnimated:YES completion:nil];
            [self resetCalibration];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        [Track calibrationErrorNoSpoonDetected];
    }
    
    if (coinIndex == ([self.coins numCoins] - 1)) {
        [self setCalibrationStep:CalibrationStepRemoveSpoon];
    }
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
