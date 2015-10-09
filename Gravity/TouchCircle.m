//
//  TouchCircle.m
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "TouchCircle.h"
#import <Pop.h>
#import "CAMediaTimingFunction+BasicFunctions.h"

@interface TouchCircle ()
@property (strong, nonatomic, readwrite) CircularTextView *circularLabel;
@property (strong, nonatomic, readwrite) CKShapeView *fillCircle;
@property (strong, nonatomic, readwrite) CKShapeView *rippleCircle;

@end

@implementation TouchCircle

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
        self.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.8] CGColor];
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = frame.size.width/2.f;
        
        CGFloat inset = -30;
        CircularTextView *circularLabel = [[CircularTextView alloc] initWithFrame:CGRectInset(self.bounds, inset, inset)];
        [self addSubview:circularLabel];
        circularLabel.backgroundColor = [UIColor clearColor];
        
        self.fillCircle = [[CKShapeView alloc] initWithFrame:self.bounds];
        self.fillCircle.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        self.fillCircle.fillColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self addSubview:self.fillCircle];
        
        self.rippleCircle = [[CKShapeView alloc] initWithFrame:self.bounds];
        self.rippleCircle.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        self.rippleCircle.fillColor = [UIColor clearColor];
        self.rippleCircle.lineWidth = 2;
        self.rippleCircle.strokeColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:self.rippleCircle];
    }
    return self;
}

- (void) expand {
    
    POPSpringAnimation *growAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    growAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.001, 0.001)];
    growAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    growAnimation.springSpeed = 8;
    
    POPSpringAnimation *fillExpandAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    fillExpandAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
    fillExpandAnimation.springSpeed = 4;
    
    [self pop_addAnimation:growAnimation forKey:@"scale"];
    [self.fillCircle pop_addAnimation:fillExpandAnimation forKey:@"scale"];
    
    
    CGFloat duration = 3.0;
    CGFloat delay = 1.88;
    [self.rippleCircle.layer setTransform:CATransform3DIdentity];
    POPBasicAnimation *holeRippleScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    holeRippleScaleAnimation.duration           = duration;
    holeRippleScaleAnimation.fromValue          = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    holeRippleScaleAnimation.toValue            = [NSValue valueWithCGSize:CGSizeMake(3, 3)];
    holeRippleScaleAnimation.timingFunction     = [CAMediaTimingFunction easeIn];
    holeRippleScaleAnimation.beginTime          = CACurrentMediaTime() + delay;
    holeRippleScaleAnimation.repeatForever      = YES;
    
    POPBasicAnimation *holeRippleOpacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    holeRippleOpacityAnimation.duration           = duration;
    holeRippleOpacityAnimation.fromValue          = @1;
    holeRippleOpacityAnimation.toValue            = @0;
    holeRippleOpacityAnimation.timingFunction     = [CAMediaTimingFunction CubicOut];
    holeRippleOpacityAnimation.beginTime          = CACurrentMediaTime() + delay;
    holeRippleOpacityAnimation.repeatForever      = YES;

    [self.rippleCircle.layer pop_addAnimation:holeRippleOpacityAnimation forKey:@"opacity"];
    [self.rippleCircle.layer pop_addAnimation:holeRippleScaleAnimation   forKey:@"scale"];
}

- (void) contractOnCompletion:(VoidBlock)onCompletion {
    
    POPSpringAnimation *shrinkAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    shrinkAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.001, 0.001)];
    shrinkAnimation.springSpeed = 8;

    POPSpringAnimation *fillContractAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    fillContractAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    fillContractAnimation.springSpeed = 8;
    fillContractAnimation.completionBlock = ^(POPAnimation* animation, BOOL completed) {
        if (onCompletion) {
            onCompletion();
        }
    };
    
    [self pop_addAnimation:shrinkAnimation forKey:@"scale"];
    [self.fillCircle pop_addAnimation:fillContractAnimation forKey:@"scale"];
}

@end
