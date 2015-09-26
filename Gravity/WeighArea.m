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

//@property (strong, nonatomic) NSMutableSet *activeTouches;
@property (strong, nonatomic) NSMutableDictionary *activeTouches;

@end


@implementation WeighArea

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        
        self.multipleTouchEnabled = YES;
        self.activeTouches = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark

- (void) registerTouch:(UITouch*)touch {
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    circle.backgroundColor = [UIColor clearColor];
    circle.layer.backgroundColor = [[UIColor clearColor] CGColor];
    circle.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.8] CGColor];
    circle.layer.borderWidth = 3;
    circle.layer.cornerRadius = 50;
    circle.center = [touch locationInView:self];
    [self addSubview:circle];
    
    CGFloat inset = -30;
    CircularTextView *circularLabel = [[CircularTextView alloc] initWithFrame:CGRectInset(circle.bounds, inset, inset)];
    [circle addSubview:circularLabel];
    circularLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.activeTouches setObject:circle forKey:[NSValue valueWithNonretainedObject:touch]];
}

- (void) updateTouch:(UITouch*)touch {
    UIView *circle = [self.activeTouches objectForKey:[NSValue valueWithNonretainedObject:touch]];
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
        NSLog(@"Force: %f", touch.force, touch.maximumPossibleForce);
    }
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:infoString attributes:attributes];
    [((CircularTextView*)circle.subviews.firstObject) setAttributedText:attrString];
}

- (void) deregisterTouch:(UITouch*)touch {
    [[self.activeTouches objectForKey:[NSValue valueWithNonretainedObject:touch]] removeFromSuperview];
    [self.activeTouches removeObjectForKey:[NSValue valueWithNonretainedObject:touch]];
}

#pragma mark Touch Events

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self registerTouch:touch];
        [self updateTouch:touch];
    }
    
    [self updateDebugInfo];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self updateTouch:touch];
    }

    [self updateDebugInfo];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self deregisterTouch:touch];
    }
    
    [self updateDebugInfo];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self deregisterTouch:touch];
    }
    
    [self updateDebugInfo];
}

#pragma mark Debug Stats
- (void) updateDebugInfo {
    
    if (self.forceAvailable) {
        if ([self.activeTouches count] > 1) {
            [self.weightAreaDelegate multipleTouchesDetected];
        } else {
            UITouch *touch = [[[self.activeTouches allKeys] firstObject] nonretainedObjectValue];
            [self.weightAreaDelegate singleTouchDetectedWithForce:touch.force maximumPossibleForce:touch.maximumPossibleForce];
        }
    }
    
    NSMutableString *debugString = [NSMutableString new];
    
    for (NSValue *touchValue in [self.activeTouches allKeys]) {
        if (self.forceAvailable) {
            UITouch *touch = [touchValue nonretainedObjectValue];
            [debugString appendString:[NSString stringWithFormat:@"Force: %f\t (max: %f)\n", touch.force, touch.maximumPossibleForce]];
        } else {
            [debugString appendString:@"Force Touch not available\n"];
        }
    }
    
    [self.weightAreaDelegate debugDataUpdated:debugString];
}

@end
