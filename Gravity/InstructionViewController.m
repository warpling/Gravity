//
//  InstructionViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "InstructionViewController.h"
#import "Masonry.h"
#import "GhostButton.h"

@interface InstructionViewController ()

@property (strong, nonatomic, readwrite) UILabel *stepNumberLabel;
@property (strong, nonatomic, readwrite) UITextView *contentTextView;
@property (strong, nonatomic, readwrite) GhostButton *continueButton;

@end


@implementation InstructionViewController

//static const CGFloat stepNumberSize = 50;

//- (UILabel*) stepNumberLabel {
//    if (!_stepNumberLabel) {
//        _stepNumberLabel = [UILabel new];
//        _stepNumberLabel.textAlignment = NSTextAlignmentCenter;
//        _stepNumberLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:28];
//        _stepNumberLabel.adjustsFontSizeToFitWidth = YES;
//        _stepNumberLabel.textColor = [UIColor gravityPurple];
//        _stepNumberLabel.backgroundColor = [UIColor gravityPurpleDark];
//        _stepNumberLabel.numberOfLines = 1;
//        _stepNumberLabel.layer.cornerRadius = stepNumberSize/2.f;
//        _stepNumberLabel.layer.masksToBounds = YES;
//        
//        _stepNumberLabel.hidden = YES;
//        
//        [self.view addSubview:_stepNumberLabel];
//        
//        [_stepNumberLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.width.equalTo(@(stepNumberSize));
//            make.height.equalTo(_stepNumberLabel.width);
//            make.top.equalTo(self.view).with.offset(80);
//        }];
//    }
//    
//    return _stepNumberLabel;
//}

- (UITextView*) contentTextView {
    if (!_contentTextView) {
        _contentTextView = [UITextView new];
        _contentTextView.scrollEnabled = NO;
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        _contentTextView.textColor = [UIColor colorWithWhite:1 alpha:0.925];
        _contentTextView.backgroundColor = [UIColor clearColor];
        [_contentTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        
        [self.view addSubview:_contentTextView];
        
        [_contentTextView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.lessThanOrEqualTo(@230);
            make.height.greaterThanOrEqualTo(@100).priorityHigh();
        }];
    }
    
    return _contentTextView;
}

- (UIButton*) continueButton {
    if (!_continueButton) {
        _continueButton = [GhostButton new];
        _continueButton.fillColor = [UIColor gravityPurple];
        _continueButton.borderColor = [UIColor whiteColor];
        _continueButton.invertedStyle = YES;
        _continueButton.fontSize = 22;
        
        [_continueButton addTarget:self action:@selector(runButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_continueButton];
        
        [_continueButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.greaterThanOrEqualTo(self.contentTextView.bottom).with.offset(35);
            make.bottom.lessThanOrEqualTo(self.view).with.offset(-35);
        }];
    }
    
    return _continueButton;
}

//- (void) setStepNumber:(NSUInteger)stepNumber {
//    [self.stepNumberLabel setText:[NSString stringWithFormat:@"%d", (int)stepNumber]];
//}

- (void) setContentText:(NSString *)contentText {
    [self.contentTextView setText:contentText];
    // Set the font if we're not using attributed strings
    [self.contentTextView setFont:[UIFont fontWithName:AvenirNextRegular size:20]];
}

- (void) setContinueButtonText:(NSString *)continueButtonText {
    [self.continueButton setTitle:continueButtonText forState:UIControlStateNormal];
}

- (void) runButtonAction {
    if (self.continueButtonAction) {
        self.continueButtonAction();
    }
}

@end
