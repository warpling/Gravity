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
@optional
- (void) currentWeightDidChange:(CGFloat)grams;
- (void) currentWeightAtMaximum;
- (void) currentWeightIsDirty;
@end

#pragma mark - Scale
// -----------------------------------------------

@interface Scale : NSObject

// Currently calibrated spoon
@property (strong, nonatomic) Spoon *spoon;

// The system reported force maximum value
@property (nonatomic) CGFloat maximumPossibleForce;

// The current force from a touch
@property (nonatomic, setter=recordNewForce:) CGFloat currentForce;
// The recorded tare force
@property (nonatomic, readonly) CGFloat tareForce;

- (void) addScaleOutputDelegate: (id<ScaleOutputDelegate>) delegate;
- (void) removeScaleOutputDelegate: (id<ScaleOutputDelegate>) delegate;

- (void) invalidateCurrentForce;

- (BOOL) isCalibrated;
- (void) tare;

@end
