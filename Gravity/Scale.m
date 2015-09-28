//
//  Scale.m
//  Gravity
//
//  Created by Ryan McLeod on 9/23/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "Scale.h"

@interface Scale ()

@property (nonatomic, readwrite) CGFloat tareMass;
@property (nonatomic, readwrite) CGFloat currentMass;
@property (nonatomic, assign) NSMassFormatterUnit currentMassUnit;

@end


@implementation Scale

- (instancetype) initWithSpoon:(Spoon*)spoon {
    self = [super init];
    if (self) {
        self.spoon = spoon;
        // TODO: refactor into scaleDisplayView
        self.currentMassUnit = (NSMassFormatterUnit)[[[NSUserDefaults standardUserDefaults] objectForKey:DefaultUnits] intValue];
    }
    return self;
}

/**
 @param currentForce
        A force value from a 3D touch.
 */
- (void) recordNewForce:(CGFloat)currentForce {
    
    _currentForce = currentForce;
    
//    self.currentMass = [self applyTare:[self convertForceToGrams:currentForce]];
    if ([self.spoon isCalibrated]) {
        self.currentMass = [self.spoon weightFromForce:self.currentForce];
    }
}

- (void) setCurrentMass:(CGFloat)currentMass {
    _currentMass = currentMass;
    
    [self sendOutWeightChange];
}

- (void) setCurrentMassUnits:(NSMassFormatterUnit)currentMassUnit {
    _currentMassUnit = currentMassUnit;
    
    [self sendOutWeightChange];
}

- (void) tare {
    [self.spoon recordBaseForce:self.currentForce];

    self.tareMass = self.currentMass;
    [self sendOutWeightChange];
}

- (void) sendOutWeightChange {
    // TODO: Taring
    [self.scaleOutputDelegate currentWeightDidChange:self.currentMass];
}

@end
