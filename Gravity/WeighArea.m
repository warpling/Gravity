//
//  WeighArea.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "WeighArea.h"
#import "CircularTextView.h"

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
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, touchCircleSize, touchCircleSize)];
    circle.backgroundColor = [UIColor clearColor];
    circle.layer.backgroundColor = [[UIColor clearColor] CGColor];
    circle.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.8] CGColor];
    circle.layer.borderWidth = 3;
    circle.layer.cornerRadius = touchCircleSize/2.f;
    circle.center = [touch locationInView:self];
    circle.hidden = !self.touchCirclesEnabled;
    [self addSubview:circle];
    
    CGFloat inset = -30;
    CircularTextView *circularLabel = [[CircularTextView alloc] initWithFrame:CGRectInset(circle.bounds, inset, inset)];
    [circle addSubview:circularLabel];
    circularLabel.backgroundColor = [UIColor clearColor];
    circularLabel.hidden = !self.debugLabelsEnabled;
    
    [self.activeTouches setObject:circle forKey:touch];
}

- (void) updateTouch:(UITouch*)touch {
    UIView *circle = [self.activeTouches objectForKey:touch];
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
        NSLog(@"Force: %f", touch.force);
    }
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:infoString attributes:attributes];
    [((CircularTextView*)circle.subviews.firstObject) setAttributedText:attrString];
}

- (void) deregisterTouch:(UITouch*)touch {
    [[self.activeTouches objectForKey:touch] removeFromSuperview];
    [self.activeTouches removeObjectForKey:touch];
}

#pragma mark Touch Events

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self registerTouch:touch];
        [self updateTouch:touch];
    }
    
    [self touchesDidChange];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self updateTouch:touch];
    }

    [self touchesDidChange];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self deregisterTouch:touch];
    }
    
    [self touchesDidChange];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self deregisterTouch:touch];
    }
    
    [self touchesDidChange];
}

#pragma mark Debug Stats
- (void) touchesDidChange {
    
    if (self.forceAvailable) {
        if ([self.activeTouches count] > 1) {
            self.lastActiveTouch = nil;
            [self.weightAreaDelegate multipleTouchesDetected];
        }
        else if ([self.activeTouches count] == 1) {
            UITouch *touch = [[[self.activeTouches keyEnumerator] allObjects] firstObject];
            self.lastActiveTouch = touch;
            [self.weightAreaDelegate singleTouchDetectedWithForce:touch.force maximumPossibleForce:touch.maximumPossibleForce];
        }
        else {
            self.lastActiveTouch = nil;
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
