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

@interface CalibrationViewController ()

typedef NS_ENUM(NSInteger, CalibrationStep) {
    CalibrationStepWeighSpoon,
    CalibrationStepAddCoins,
    CalibrationStepDone
};

@property (nonatomic) CalibrationStep calibrationStep;

@property (strong, nonatomic) UIView *statusBarBackground;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) CKShapeView *spoonView;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) CoinHolder *coins;

@property (strong, nonatomic) UIView *buttonBar;
@property (strong, nonatomic) UIView *buttonSpacer1;
@property (strong, nonatomic) UIView *buttonSpacer2;
@property (strong, nonatomic) GhostButton *nextButton;
@property (strong, nonatomic) GhostButton *resetButton;
@property (strong, nonatomic) GhostButton *doneButton;

@end


@implementation CalibrationViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
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
    
    CKShapeView *spoonView = [SpoonView new];
    self.spoonView = spoonView;
    [self.view addSubview:self.spoonView];
    
    UILabel *bottomLabel = [UILabel new];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomLabel setNumberOfLines:0];
    [bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.bottomLabel = bottomLabel;
    [self.view addSubview:self.bottomLabel];
    
    
    self.coins = [[CoinHolder alloc] initWithFrame:CGRectZero coinType:CoinTypeUSQuarter numCoins:4];
    [self.view addSubview:self.coins];
    
    [self setupButtonBar];
    
//
    [self.headerLabel setText:@"Set device on flat surface"];
    [self.topLabel setText:@"Gently place spoon below"];
    [self.bottomLabel setText:@"Place one quarter into the spoon and press the icon below."];
//
    
    [self setupViewConstraints];
}

- (void) setupButtonBar {
    UIView *buttonBar = [UIView new];
    [self.buttonBar setBackgroundColor:[UIColor redColor]];
    self.buttonBar = buttonBar;

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
    
    GhostButton *doneButton = [GhostButton new];
    doneButton.fillColor = [UIColor whiteColor];
    doneButton.borderColor = [UIColor gravityPurple];
    [doneButton setTitle:@"Finish" forState:UIControlStateNormal];
    self.doneButton = doneButton;
    
    self.buttonSpacer1 = [UIView new];
    self.buttonSpacer2 = [UIView new];

    [self.buttonBar addSubview:self.nextButton];
    [self.buttonBar addSubview:self.buttonSpacer1];
    [self.buttonBar addSubview:self.resetButton];
    [self.buttonBar addSubview:self.buttonSpacer2];
    [self.buttonBar addSubview:self.doneButton];
    [self.view addSubview:self.buttonBar];
}

- (void) setupViewConstraints {
    
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
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.spoonView makeConstraints:^(MASConstraintMaker *make) {
        // Try to guarantee that the center of the spoon bowl is in the center of the screen
        make.left.equalTo(self.view.centerX).with.offset(-132);
        // Approximately the height of the bottom buttons in the main view
        make.centerY.equalTo(self.view).with.offset(-62);
    }];
    
    [self.bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spoonView.bottom);
        make.bottom.equalTo(self.coins.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.coins makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLabel.bottom);
        make.bottom.equalTo(self.buttonBar.top);
        make.centerX.equalTo(self.view);
        make.height.lessThanOrEqualTo(@100);
        make.height.equalTo(self.view).priorityLow();
        make.width.equalTo(self.view).with.offset(-20);
    }];
    

    CGFloat buttonSpacerMinWidth = 15;
    CGFloat buttonSpacerWidth = 35;
    
    [self.buttonBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).priorityHigh();
        make.centerX.equalTo(self.view);
        make.height.lessThanOrEqualTo(@100);
        make.width.greaterThanOrEqualTo(@200);
    }];
    
    [self.nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.buttonBar.leading);
        make.trailing.equalTo(self.buttonSpacer1.leading);
        make.centerY.equalTo(self.buttonBar);
    }];
    
    [self.buttonSpacer1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@(buttonSpacerMinWidth));
        make.width.equalTo(@(buttonSpacerWidth));
        make.centerY.equalTo(self.buttonBar);
        make.leading.equalTo(self.nextButton.trailing);
        make.trailing.equalTo(self.resetButton.leading);
    }];
    
    [self.resetButton makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.buttonSpacer1.trailing);
        make.trailing.equalTo(self.buttonSpacer2.leading);
        make.centerY.equalTo(self.buttonBar);
    }];
    
    [self.buttonSpacer2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.buttonSpacer1);
        make.centerY.equalTo(self.buttonBar);
        make.leading.equalTo(self.resetButton.trailing);
        make.trailing.equalTo(self.doneButton.leading);
    }];
    
    [self.doneButton makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.buttonBar.trailing);
        make.centerY.equalTo(self.buttonBar);
    }];
    

}

#

- (void) setCalibrationStep:(CalibrationStep)calibrationStep {
    _calibrationStep = calibrationStep;

    switch (calibrationStep) {
        case CalibrationStepWeighSpoon:
        {
            
            break;
        }
        case CalibrationStepAddCoins:
        {
            
            break;
        }
        case CalibrationStepDone:
        {
            
            break;
        }
    }
}

#pragma mark CoinSelectionDelegate

- (void) coinSelected:(NSUInteger)coinIndex {
    //
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
