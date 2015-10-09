//
//  LinearFunction.h
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinearFunction : NSObject

@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat yIntercept;
@property (nonatomic, readonly) CGFloat rSquared;

+ (instancetype) linearFunctionWithSlope:(CGFloat)slope yIntercept:(CGFloat)yIntercept;
+ (instancetype) linearFunctionWithSlope:(CGFloat)slope yIntercept:(CGFloat)yIntercept rSquared:(CGFloat)rSquared;
+ (instancetype) bestFitWithXValues:(NSArray*)xValues yValues:(NSArray*)yValues;
- (CGFloat) solveGivenX:(CGFloat)x;
- (CGFloat) solveGivenY:(CGFloat)y;
- (CGFloat) xIntercept;

@end
