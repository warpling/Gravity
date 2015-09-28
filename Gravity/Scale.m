//
//  Scale.m
//  Gravity
//
//  Created by Ryan McLeod on 9/23/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "Scale.h"

@interface Scale ()

@property (nonatomic, readwrite) CGFloat tareForce;
@property (nonatomic, assign) NSMassFormatterUnit currentMassUnit;

@end


@implementation Scale

- (instancetype) initWithSpoon:(Spoon*)spoon {
    self = [super init];
    if (self) {
        self.spoon = spoon;
    }
    return self;
}

/**
 @param currentForce
        A force value from a 3D touch.
 */
- (void) recordNewForce:(CGFloat)currentForce {
    _currentForce = currentForce;
    [self sendOutWeightChange];
}

- (void) tare {
    self.tareForce = self.currentForce;
    [self sendOutWeightChange];
}

- (void) sendOutWeightChange {
    
    CGFloat rawWeight, tareWeight;
    
    if ([self.spoon isCalibrated]) {
        rawWeight   = [self.spoon weightFromForce:self.currentForce];
        tareWeight  = [self.spoon weightFromForce:self.tareForce];
    }
    
    [self.scaleOutputDelegate currentWeightDidChange:(rawWeight - tareWeight)];
}

@end
