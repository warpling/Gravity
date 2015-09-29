//
//  DeviceUnsupportedViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "DeviceUnsupportedViewController.h"
#import "Constants.h"
#import <Masonry.h>

@interface DeviceUnsupportedViewController ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation DeviceUnsupportedViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        UIFont *largeFont = [UIFont fontWithName:AvenirNextBold size:28];
        UIFont *smallFont = [UIFont fontWithName:AvenirNextMedium size:17];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"😟\nGravity only works with iPhone 6s and iPhone 6s+\n\n"
                                                                                                   attributes:@{
                                                                                                                NSFontAttributeName: largeFont,
                                                                                                                NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                                }];
        
        [attributedText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"(If you purchased this app in error, "
                                                                                              attributes:@{
                                                                                                           NSFontAttributeName: smallFont,
                                                                                                           NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                           NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.9]
                                                                                                           }]];
        
        
        
        
        NSMutableAttributedString *refundLink = [[NSMutableAttributedString alloc] initWithString:@"please contact Apple for refund." attributes:@{
                                                                                                                                      NSFontAttributeName: smallFont,
                                                                                                                                      NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                                                      NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.9]
                                                                                                                                      }];
        [refundLink addAttribute: NSLinkAttributeName value:@"https://reportaproblem.apple.com/" range: NSMakeRange(0, refundLink.length)];
        [attributedText appendAttributedString:refundLink];
        UIColor *linkColor = [UIColor colorWithWhite:1 alpha:0.9];
        self.textView.linkTextAttributes = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                             NSForegroundColorAttributeName:linkColor};
        
        [attributedText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@")"
                                                                                      attributes:@{
                                                                                                   NSFontAttributeName: smallFont,
                                                                                                   NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.9]
                                                                                                   }]];
        
        [self.textView setAttributedText:attributedText];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor gravityPurple]];
}

- (UITextView*) textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.scrollEnabled = NO;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.textColor = [UIColor colorWithWhite:1 alpha:0.925];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.editable = NO;
        [_textView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        
        [self.view addSubview:_textView];
        
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).with.offset(-30);
            make.width.lessThanOrEqualTo(@280);
            make.height.greaterThanOrEqualTo(@100).priorityHigh();
        }];
    }
    
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange {
    return YES;
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
