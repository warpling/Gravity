//
//  Scale.m
//  Gravity
//
//  Created by Ryan McLeod on 9/23/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "Scale.h"
#import "Track.h"

@interface Scale ()

@property (nonatomic) BOOL currentForceIsDirty;
@property (nonatomic, readwrite) CGFloat tareForce;
@property (nonatomic, assign) NSMassFormatterUnit currentMassUnit;
@property (nonatomic, strong) NSHashTable *scaleOutputDelegates;

@end


@implementation Scale

- (instancetype) init {
    self = [super init];
    if (self) {
        self.scaleOutputDelegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void) setSpoon:(Spoon *)spoon {
    _spoon = spoon;
    // Pre-tare for the user
    [self setTareForce:spoon.spoonForce];
    
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
    self.currentForceIsDirty = NO;

    [self sendOutWeightChange];
}

- (void) invalidateCurrentForce {
    self.currentForceIsDirty = YES;
    
    [self sendOutWeightChange];
}

- (void) tare {
    if (!self.currentForceIsDirty) {
        self.tareForce = self.currentForce;
        
        [Track scaleTared];
        [self sendOutWeightChange];
    }
}

- (void) sendOutWeightChange {
    
    if (self.currentForceIsDirty) {
        [self sendDelegatesCurrentWeightIsDirty];
        return;
    }
    // Maximum weight reached, display MAX and get out
    if ((self.maximumPossibleForce - self.currentForce) <= 0.001) {
        [self sendDelegatesCurrentWeightAtMaximum];
//        [Track scaleMaxedOut];
        return;
    }
    
    // Go about business as usual
    CGFloat rawWeight, tareWeight;
    if ([self isCalibrated]) {
        rawWeight   = [self.spoon weightFromForce:self.currentForce];
        tareWeight  = [self.spoon weightFromForce:self.tareForce];
        
        [self sendDelegatesCurrentWeightDidChange:(rawWeight - tareWeight)];
    }
}

#pragma mark - Delegation

- (void) addScaleOutputDelegate: (id<ScaleOutputDelegate>) delegate {
    [_scaleOutputDelegates addObject: delegate];
}

// calling this method is optional, because the hash table will automatically remove the delegate when it gets released
- (void) removeScaleOutputDelegate: (id<ScaleOutputDelegate>) delegate {
    [_scaleOutputDelegates removeObject: delegate];
}

// TODO: DRY

- (void) sendDelegatesCurrentWeightDidChange:(CGFloat)currentWeight {
    for (id<ScaleOutputDelegate> scaleOutputDelegate in [self.scaleOutputDelegates allObjects]) {
        if ([scaleOutputDelegate respondsToSelector:@selector(currentWeightDidChange:)]) {
            [scaleOutputDelegate currentWeightDidChange:currentWeight];
        }
    }
}

- (void) sendDelegatesCurrentWeightAtMaximum {
    for (id<ScaleOutputDelegate> scaleOutputDelegate in [self.scaleOutputDelegates allObjects]) {
        if ([scaleOutputDelegate respondsToSelector:@selector(currentWeightAtMaximum)]) {
            [scaleOutputDelegate currentWeightAtMaximum];
        }
    }
}

- (void) sendDelegatesCurrentWeightIsDirty {
    for (id<ScaleOutputDelegate> scaleOutputDelegate in [self.scaleOutputDelegates allObjects]) {
        if ([scaleOutputDelegate respondsToSelector:@selector(currentWeightIsDirty)]) {
            [scaleOutputDelegate currentWeightIsDirty];
        }
    }
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.spoon forKey:Gravity_SpoonKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [self init])) {
        self.spoon = [decoder decodeObjectForKey:Gravity_SpoonKey];
    }
    return self;
}

@end
