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

- (void) setSpoon:(Spoon *)spoon {
    _spoon = spoon;
    
    // Only keep good spoons
    if ([spoon isCalibrated]) {
        [self save];
    }
}

- (BOOL) isCalibrated {
    return [self.spoon isCalibrated];
}

- (void) save {
    NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedScale forKey:Gravity_ScaleKey];
    [defaults synchronize];
    NSLog(@"Scale saved");
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
    
    // Maximum weight reached, display MAX and get out
    if ((self.maximumPossibleForce - self.currentForce) <= 0.001) {
        [self.scaleOutputDelegate currentWeightAtMaximum];
        return;
    }
    
    // Go about business as usual
    CGFloat rawWeight, tareWeight;
    if ([self isCalibrated]) {
        rawWeight   = [self.spoon weightFromForce:self.currentForce];
        tareWeight  = [self.spoon weightFromForce:self.tareForce];
        
        [self.scaleOutputDelegate currentWeightDidChange:(rawWeight - tareWeight)];
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.spoon forKey:Gravity_SpoonKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.spoon = [decoder decodeObjectForKey:Gravity_SpoonKey];
    }
    return self;
}

@end
