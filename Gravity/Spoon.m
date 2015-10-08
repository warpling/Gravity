//
//  Spoon.m
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "Spoon.h"
#import "Constants.h"

@interface Spoon ()
@property (nonatomic, readwrite) CGFloat spoonForce;
@property (strong, nonatomic, readwrite) NSDictionary *calibrationForces;
@property (strong, nonatomic, readwrite) LinearFunction *bestFit;

@end

@implementation Spoon

- (instancetype) init {
    self = [super init];
    if (self) {
        self.calibrationForces = [NSDictionary new];
    }
    return self;
}

// Record the force created by the spoon
- (void) recordBaseForce:(CGFloat)force {
    self.spoonForce = force;
}

// Record the force created by a known weight on the spoon
- (void) recordCalibrationForce:(CGFloat)force forKnownWeight:(CGFloat)knownWeight {
    NSMutableDictionary *newCalibrationForces = [self.calibrationForces mutableCopy];
    [newCalibrationForces setObject:@(force) forKey:@(knownWeight)];
    self.calibrationForces = newCalibrationForces;
    [self calculateBestFit];
}

- (void) calculateBestFit {
    // X axis: Apple Force
    NSArray *xValues = [self.calibrationForces allValues];
    // Y axis: Weight in grams
    NSArray *yValues = [self.calibrationForces allKeys];
    
    self.bestFit = [LinearFunction bestFitWithXValues:xValues yValues:yValues];
}

// Returns weight in grams
- (CGFloat) weightFromForce:(CGFloat)force {
    return [self.bestFit solveGivenX:force];
}

- (BOOL) isCalibrated {
    return ([self.calibrationForces count] >= 4);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.calibrationForces forKey:Gravity_CalibrationForcesKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.calibrationForces = [decoder decodeObjectForKey:Gravity_CalibrationForcesKey];
        [self calculateBestFit];
    }
    return self;
}

@end
