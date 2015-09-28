//
//  Scale.h
//  Gravity
//
//  Created by Ryan McLeod on 9/23/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Spoon.h"

#pragma mark - ScaleDisplayDelegate
// -----------------------------------------------

@protocol ScaleOutputDelegate <NSObject>

- (void) currentWeightDidChange:(CGFloat)grams;

@end

#pragma mark - Scale
// -----------------------------------------------

@interface Scale : NSObject

// Currently calibrated spoon
@property (strong, nonatomic) Spoon *spoon;

// The system reported force maximum value
@property (nonatomic) CGFloat maximumPossibleForce;
// TODO: hide behind recordCurrentForce: method
// The current force from a touch
@property (nonatomic, setter=recordNewForce:) CGFloat currentForce;
// The current set tare in grams
@property (nonatomic, readonly) CGFloat tareMass;
// The current estimated mass in grams.
@property (nonatomic, readonly) CGFloat currentMass;

@property (weak, nonatomic) id<ScaleOutputDelegate> scaleOutputDelegate;


- (instancetype) initWithSpoon:(Spoon*)spoon;

- (void) tare;

@end
