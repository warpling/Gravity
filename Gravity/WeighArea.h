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

- (void) debugDataUpdated:(NSString*)debugData;

@end

@interface WeighArea : UIView

@property (weak, nonatomic) id<WeighAreaEventsDelegate> weightAreaDelegate;
@property (nonatomic) BOOL forceAvailable;

@end
