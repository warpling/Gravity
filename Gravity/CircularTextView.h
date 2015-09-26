//
//  CircularTextView.h
//  Wormhole
//
//  Created by Ryan McLeod on 5/5/15.
//  Copyright (c) 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularTextView : UIView

@property (strong, nonatomic) NSAttributedString *attributedText;
@property CGFloat inset;

@end
