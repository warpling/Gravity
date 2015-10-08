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
@property (strong, nonatomic) NSMassFormatter *massFormatter;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@end

@implementation ScaleDisplay

static NSString * const dirtyString = @"----";

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.massFormatter = [NSMassFormatter new];
        [self.massFormatter setUnitStyle:NSFormattingUnitStyleShort];
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.massFormatter setNumberFormatter:_numberFormatter];

        // Setting the mass unit will set the right maxFractionDigits
        self.massUnit = (NSMassFormatterUnit)[[[NSUserDefaults standardUserDefaults] valueForKey:Gravity_DefaultMassDisplayUnits] intValue];
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
    
    // More digits for oz
    NSUInteger minFractionDigits = (self.massUnit == NSMassFormatterUnitGram) ? 1 : 2;
    NSUInteger maxFractionDigits = (self.massUnit == NSMassFormatterUnitGram) ? 1 : 2;
    [self.numberFormatter setMinimumFractionDigits:minFractionDigits];
    [self.numberFormatter setMaximumFractionDigits:maxFractionDigits];
    [self.massFormatter setNumberFormatter:self.numberFormatter];

    [self refreshDisplay];
}

- (void) refreshDisplay {
    NSString *outputString = dirtyString;
    
    if (![self weightIsDirty]) {
        CGFloat convertedWeight = (self.massUnit == NSMassFormatterUnitGram) ? self.weight : (gramToOzMultiplier * self.weight);
        outputString = [self.massFormatter stringFromValue:convertedWeight unit:self.massUnit];
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
