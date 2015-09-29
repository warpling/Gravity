//
//  TitleViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        UIFont *normalCaptionFont = [UIFont fontWithName:AvenirNextMedium size:24];
        UIFont *boldCaptionFont = [UIFont fontWithName:AvenirNextBold size:24];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        NSMutableAttributedString *attributedTextCaption1 = [[NSMutableAttributedString alloc] initWithString:@"Gravity"
                                                                                                   attributes:@{
                                                                                                                NSFontAttributeName: boldCaptionFont,
                                                                                                                NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                                }];
        
        [attributedTextCaption1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" turns your iPhone 6s into a digital scale."
                                                                                              attributes:@{
                                                                                                           NSFontAttributeName: normalCaptionFont,
                                                                                                           NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                           NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.9]
                                                                                                           }]];
        [self.contentTextView setAttributedText:attributedTextCaption1];
        
        [self setContinueButtonText:@"Continue"];
        [self.continueButton.layer setOpacity:0];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = @(1);
    fadeIn.duration = 3;
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeIn.beginTime = CACurrentMediaTime() + 1;
    
    [self.continueButton.layer addAnimation:fadeIn forKey:@"fadeIn"];
}

@end
