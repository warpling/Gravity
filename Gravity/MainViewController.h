//
//  ViewController.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scale.h"

@interface MainViewController : UIViewController <ScaleDisplayDelegate>

@property (strong, nonatomic) Scale *scale;

@end

