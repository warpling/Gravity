//
//  ScaleOutput.m
//  Gravity
//
//  Created by Ryan McLeod on 9/28/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "ScaleDisplay.h"
#import "Constants.h"

@implementation ScaleDisplay

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.massUnit = (NSMassFormatterUnit)[[[NSUserDefaults standardUserDefaults] valueForKey:DefaultUnits] intValue];
        
        [self setFont:[UIFont fontWithName:AvenirNextBold size:46]];
        [self setTextColor:[UIColor whiteColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setNumberOfLines:1];
        [self setAdjustsFontSizeToFitWidth:YES];
        
        [self clear];
    }
    return self;
}

- (void) clear {
    [self setText:@"----"];
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
    
    CGFloat convertedWeight = (self.massUnit == NSMassFormatterUnitGram) ? self.weight : (gramToOzMultiplier * self.weight);
    
    NSString *massString = [massFormatter stringFromValue:convertedWeight unit:self.massUnit];
    [self setText:massString];
}

#pragma mark - ScaleDisplayDelegate

- (void) currentWeightDidChange:(CGFloat)grams {
    [self setWeight:grams];
}

@end
