//
//  ScaleOutput.m
//  Gravity
//
//  Created by Ryan McLeod on 9/28/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "ScaleDisplay.h"
#import "Constants.h"

@interface ScaleDisplay ()
@property (nonatomic) BOOL weightIsDirty;
@end

@implementation ScaleDisplay

static NSString * const dirtyString = @"----";

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _massUnit = (NSMassFormatterUnit)[[[NSUserDefaults standardUserDefaults] valueForKey:Gravity_DefaultMassDisplayUnits] intValue];
        _weightIsDirty = YES;

        [self setBackgroundColor:[UIColor gravityPurpleDark]];

        [self setFont:[UIFont fontWithName:AvenirNextBold size:46]];
        [self setTextColor:[UIColor whiteColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setNumberOfLines:1];
        [self setAdjustsFontSizeToFitWidth:YES];
        
        [self refreshDisplay];
    }
    return self;
}

- (void) setWeight:(CGFloat)grams {
    _weight = grams;
    [self refreshDisplay];
}

- (void) setMassUnit:(NSMassFormatterUnit)massUnit {
    _massUnit = massUnit;
    [self refreshDisplay];
}

- (void) refreshDisplay {
    static NSMassFormatter *massFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        massFormatter = [NSMassFormatter new];
        [massFormatter setUnitStyle:NSFormattingUnitStyleShort];
    });
    
    NSString *outputString = dirtyString;
    
    if (![self weightIsDirty]) {
        CGFloat convertedWeight = (self.massUnit == NSMassFormatterUnitGram) ? self.weight : (gramToOzMultiplier * self.weight);
        outputString = [massFormatter stringFromValue:convertedWeight unit:self.massUnit];
    }
    
    [self setText:outputString];
}

#pragma mark - ScaleDisplayDelegate

- (void) currentWeightDidChange:(CGFloat)grams {
    [self setWeight:grams];
    [self setWeightIsDirty:NO];
    [self setBackgroundColor:[UIColor gravityPurpleDark]];
}

- (void) currentWeightAtMaximum {
    [self setText:@"MAX"];
    [self setWeightIsDirty:NO];
    [self setBackgroundColor:[UIColor roverRedDark]];
}

- (void) currentWeightIsDirty {
    [self setText:dirtyString];
    [self setWeightIsDirty:YES];
    [self setBackgroundColor:[UIColor gravityPurpleDark]];
}

@end
