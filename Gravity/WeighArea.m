//
//  WeighArea.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "WeighArea.h"
#import "CircularTextView.h"
#import "Track.h"
#import "TouchCircle.h"

@interface WeighArea ()
@property (strong, nonatomic) NSMapTable *activeTouches;
@property (nonatomic, readwrite) UITouch *lastActiveTouch;
@property (nonatomic) BOOL forceAvailable;
@end


@implementation WeighArea

static CGFloat const touchCircleSize = 120;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.multipleTouchEnabled = YES;
        self.activeTouches = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
        
        UIForceTouchCapability forceTouchCapability = [self.traitCollection forceTouchCapability];
        self.forceAvailable = (forceTouchCapability == UIForceTouchCapabilityAvailable);
    }
    return self;
}

#pragma mark - In case Force permissions change

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    UIForceTouchCapability forceTouchCapability = [self.traitCollection forceTouchCapability];
    self.forceAvailable = (forceTouchCapability == UIForceTouchCapabilityAvailable);
}

#pragma mark - Touch Management

- (void) registerTouch:(UITouch*)touch {
    TouchCircle *circle = [[TouchCircle alloc] initWithFrame:CGRectMake(0, 0, touchCircleSize, touchCircleSize)];
    circle.hidden = !self.touchCirclesEnabled;
    circle.circularLabel.hidden = !self.debugLabelsEnabled;
    self.center = [touch locationInView:self];
    
    [self addSubview:circle];
    [circle expand];
    
    [self.activeTouches setObject:circle forKey:touch];
}

- (void) updateTouch:(UITouch*)touch {
    TouchCircle *circle = [self.activeTouches objectForKey:touch];
    circle.center = [touch locationInView:self];
    
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    static NSDictionary *attributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      attributes = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18],
                     NSForegroundColorAttributeName: (id)[[UIColor whiteColor] CGColor],
                     NSParagraphStyleAttributeName: paragraphStyle,
                     NSKernAttributeName: @6
                     };
    });
    
    
    NSString *infoString = @"Non-force touch";
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        infoString = [NSString stringWithFormat:@"%f", touch.force];
        #ifdef DEBUG
        NSLog(@"Force: %f", touch.force);
        #endif
    }
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:infoString attributes:attributes];
    [circle.circularLabel setAttributedText:attrString];
}

- (void) deregisterTouch:(UITouch*)touch {
    TouchCircle *touchCircle = [self.activeTouches objectForKey:touch];
    [self.activeTouches removeObjectForKey:touch];
    
    [touchCircle contractOnCompletion:^{
        [touchCircle removeFromSuperview];
    }];
}

#pragma mark Touch Events

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        [self registerTouch:touch];
        [self updateTouch:touch];
    }
    
    [self touchesDidChange];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    for (UITouch *touch in touches) {
        [self updateTouch:touch];
    }

    [self touchesDidChange];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        [self deregisterTouch:touch];
    }
    
    [self touchesDidChange];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    for (UITouch *touch in touches) {
        [self deregisterTouch:touch];
    }
    
    [self touchesDidChange];
}

- (void) reset {
    for (UITouch *touch in [[self.activeTouches keyEnumerator] allObjects]) {
        [self deregisterTouch:touch];
    }
}

#pragma mark Debug Stats
- (void) touchesDidChange {
    
    // Clean-up: ended/cancelled touches should all be removed by this point in time, but sometimes
    //           when views transition they can be orphaned. This is where they breathe their last breath.
    for (UITouch *touch in [[self.activeTouches keyEnumerator] allObjects]) {
        if (([touch phase] == UITouchPhaseEnded) || ([touch phase] == UITouchPhaseCancelled)) {
            [self deregisterTouch:touch];
        }
    }
    
    if (self.forceAvailable) {
        if ([self.activeTouches count] > 1) {
            self.lastActiveTouch = nil;
            [self.weightAreaDelegate multipleTouchesDetected];
//            [Track scaleMultitouched];
        }
        else if ([self.activeTouches count] == 1) {
            UITouch *touch = [[[self.activeTouches keyEnumerator] allObjects] firstObject];
            self.lastActiveTouch = touch;
            [self.weightAreaDelegate singleTouchDetectedWithForce:touch.force maximumPossibleForce:touch.maximumPossibleForce];
        }
        else {
            self.lastActiveTouch = nil;
            [self.weightAreaDelegate allTouchesEnded];
        }
    }
    
    NSMutableString *debugString = [NSMutableString new];
    
    for (UITouch *touch in [[self.activeTouches keyEnumerator] allObjects]) {
        if (self.forceAvailable) {
            [debugString appendString:[NSString stringWithFormat:@"Force: %f\t (max: %f)\n", touch.force, touch.maximumPossibleForce]];
        } else {
            [debugString appendString:@"Force Touch not available\n"];
        }
    }
    
    if ([self.weightAreaDelegate respondsToSelector:@selector(debugDataUpdated:)]) {
        [self.weightAreaDelegate debugDataUpdated:debugString];
    }
}

@end
