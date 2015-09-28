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
        NSString *displayString = [Scale displayStringForMass:self.currentMass units:self.currentMassUnit];
        [self.scaleDisplayDelegate displayStringDidChange:displayString];
    }
}

- (void) setCurrentMassUnits:(NSMassFormatterUnit)currentMassUnit {
    _currentMassUnit = currentMassUnit;
    
    // Force out a string since the units changed
    [self recomputeDisplayValue];
}

- (void) recomputeDisplayValue {
    
    CGFloat taredMass = self.currentMass - self.tareMass;
    
    NSString *displayString = [Scale displayStringForMass:taredMass units:self.currentMassUnit];
    [self.scaleDisplayDelegate displayStringDidChange:displayString];
}

+ (NSString*) displayStringForMass:(CGFloat)mass units:(NSMassFormatterUnit)units {
    
    static NSMassFormatter *massFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        massFormatter = [NSMassFormatter new];
        [massFormatter setUnitStyle:NSFormattingUnitStyleShort];
    });
    
    // gram -> oz
    if (units == NSMassFormatterUnitOunce) {
        mass *= gramToOzMultiplier;
    }

    return [massFormatter stringFromValue:mass unit:units];
}

- (void) tare {
    [self.spoon recordBaseForce:self.currentForce];

    self.tareMass = self.currentMass;
    [self recomputeDisplayValue];
}

- (void) switchUnits {
    if (self.currentMassUnit == NSMassFormatterUnitGram) {
        self.currentMassUnit = NSMassFormatterUnitOunce;
    }
    else {
        self.currentMassUnit = NSMassFormatterUnitGram;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@(self.currentMassUnit) forKey:DefaultUnits];
    
    [self recomputeDisplayValue];
}


@end
