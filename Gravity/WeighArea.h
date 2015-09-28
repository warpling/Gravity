//
//  WeighArea.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeighAreaEventsDelegate <NSObject>

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce;
- (void) multipleTouchesDetected;

@optional
- (void) debugDataUpdated:(NSString*)debugData;

@end

@interface WeighArea : UIView

@property (weak, nonatomic) id<WeighAreaEventsDelegate> weightAreaDelegate;
//@property (nonatomic, readonly) BOOL forceAvailable;

// Could be stale! Must check timestamp before using
@property (nonatomic, readonly) UITouch *lastActiveTouch;

@property (nonatomic) BOOL debugLabelsEnabled;
@property (nonatomic) BOOL touchCirclesEnabled;

@end
