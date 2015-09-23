//
//  InstructionViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "InstructionViewController.h"
#define MAS_SHORTHAND
#import "Masonry.h"
#import "GhostButton.h"

@interface InstructionViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *captionLabel;
@property (strong, nonatomic) GhostButton *bottomButton;

@end


@implementation InstructionViewController

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:24];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.preferredMaxLayoutWidth = self.view.bounds.size.width;
                
        [self.view addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.lessThanOrEqualTo(@280);
            make.top.greaterThanOrEqualTo(self.view).with.offset(80);
            make.height.greaterThanOrEqualTo(@20).priorityHigh();
        }];
    }
    
    return _titleLabel;
}

- (UILabel*) captionLabel {
    if (!_captionLabel) {
        _captionLabel = [UILabel new];
        _captionLabel.textAlignment = NSTextAlignmentCenter;
        _captionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        _captionLabel.textColor = [UIColor colorWithWhite:1 alpha:0.925];
        _captionLabel.numberOfLines = 0;
        _captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _captionLabel.preferredMaxLayoutWidth = self.view.bounds.size.width;
        
        [self.view addSubview:_captionLabel];
        
        [_captionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.lessThanOrEqualTo(@280);
            make.top.greaterThanOrEqualTo(self.titleLabel).with.offset(40);
            make.height.greaterThanOrEqualTo(@20).priorityHigh();
        }];
    }
    
    return _captionLabel;
}

- (UIButton*) bottomButton {
    if (!_bottomButton) {
        _bottomButton = [GhostButton new];
        _bottomButton.fillColor = [UIColor gravityPurple];
        _bottomButton.borderColor = [UIColor whiteColor];
        
        [_bottomButton addTarget:self action:@selector(runButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_bottomButton];
        
        [_bottomButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.greaterThanOrEqualTo(self.view).with.offset(-40);
        }];
    }
    
    return _bottomButton;
}

- (void) setTitleText:(NSString *)titleText {
    [self.titleLabel setText:titleText];
}

- (void) setCaptionText:(NSString *)captionText {
    [self.captionLabel setText:captionText];
}

- (void) setBottomButtonText:(NSString *)bottomButtonText {
    [self.bottomButton setTitle:bottomButtonText forState:UIControlStateNormal];
}

- (void) runButtonAction {
    if (self.buttonAction) {
        self.buttonAction();
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
