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

- (instancetype) init {
    self = [super init];
    if (self) {        
        self.currentMassUnit = (NSMassFormatterUnit)[[[NSUserDefaults standardUserDefaults] objectForKey:DefaultUnits] intValue];
    }
    return self;
}

/**
 @param currentForce
        A force value from a 3D touch.
 */
- (void) setCurrentForce:(CGFloat)currentForce {
    
    _currentForce = currentForce;
    
    self.currentMass = [self applyTare:[self convertForceToGrams:currentForce]];
    
    NSString *displayString = [Scale displayString:self.currentMass units:self.currentMassUnit];
    [self.scaleDisplayDelegate displayStringDidChange:displayString];
}

- (void) setCurrentMassUnits:(NSMassFormatterUnit)currentMassUnit {
    _currentMassUnit = currentMassUnit;
    
    // Force out a string since the units changed
    [self massComponentsDidChange];
}

- (void) massComponentsDidChange {
    
    CGFloat taredMass = self.currentMass - self.tareMass;
    
    NSString *displayString = [Scale displayString:taredMass units:self.currentMassUnit];
    [self.scaleDisplayDelegate displayStringDidChange:displayString];
}

+ (NSString*) displayString:(CGFloat)mass units:(NSMassFormatterUnit)units {
    
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
    self.tareMass = self.currentMass;
    [self massComponentsDidChange];
}

- (CGFloat) convertForceToGrams:(CGFloat)force {
    return force;
}

- (CGFloat) applyTare:(CGFloat)grams {
    return (grams - self.tareMass);
}

- (void) switchUnits {
    if (self.currentMassUnit == NSMassFormatterUnitGram) {
        self.currentMassUnit = NSMassFormatterUnitOunce;
    }
    else {
        self.currentMassUnit = NSMassFormatterUnitGram;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@(self.currentMassUnit) forKey:DefaultUnits];
    
    [self massComponentsDidChange];
}

@end
