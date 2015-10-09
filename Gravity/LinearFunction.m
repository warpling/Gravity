    //
//  LinearFunction.m
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "LinearFunction.h"

@interface LinearFunction ()

@property (nonatomic, readwrite) CGFloat slope;
@property (nonatomic, readwrite) CGFloat yIntercept;
@property (nonatomic, readwrite) CGFloat rSquared;

@end

@implementation LinearFunction

+ (instancetype) linearFunctionWithSlope:(CGFloat)slope yIntercept:(CGFloat)yIntercept {
    return [LinearFunction linearFunctionWithSlope:slope yIntercept:yIntercept rSquared:0];
}

+ (instancetype) linearFunctionWithSlope:(CGFloat)slope yIntercept:(CGFloat)yIntercept rSquared:(CGFloat)rSquared {
    LinearFunction *linearFunction = [[LinearFunction alloc] init];
    
    linearFunction.slope      = slope;
    linearFunction.yIntercept = yIntercept;
    linearFunction.rSquared   = rSquared;
    
    return linearFunction;
}

// Expects arrays of NSNumbers encapsulating floats
// Based on http://stackoverflow.com/a/18989440/522498
+ (instancetype) bestFitWithXValues:(NSArray*)xValues yValues:(NSArray*)yValues {
    NSAssert(([xValues count] == [yValues count]), @"Expected equal number of x and y values.");
    
    CGFloat sumX, sumX2, sumY, sumY2, sumXY;
    CGFloat numPoints = [xValues count];
    
    
    for (int ctr = 0; ctr < numPoints; ctr++) {
        CGFloat x = [xValues[ctr] floatValue];
        CGFloat y = [yValues[ctr] floatValue];
        
        sumX  += x;
        sumX2 += powf(x, 2);
        sumXY += x * y;
        sumY  += y;
        sumY2 += powf(y, 2);
    }
    
    CGFloat denominator = (numPoints * sumX2 - powf(sumX, 2));
    if (denominator == 0) {
        // singular matrix. Can't solve the problem.
        NSLog(@"Could not calculate best fit!");
        return nil;
    }
    
    CGFloat slope = ((numPoints * sumXY) - (sumX * sumY)) / denominator;
//    CGFloat slope = ((numPoints * sumXY) - (sumX * sumY)) / (numPoints * sumX2 - sumX * sumX);
    CGFloat yIntercept = (sumY * sumX2 - sumX * sumXY) / denominator;
//    CGFloat yIntercept = (sumY - slope *sumX) / numPoints;
    CGFloat rSquared = (sumXY - sumX * sumY / numPoints)
                        / sqrtf((sumX2 - powf(sumX, 2)/numPoints)
                        * (sumY2 - powf(sumY, 2) / numPoints));
    
    
//    CGFloat slope = ((numPoints * sumXY) - (sumX * sumY)) / ((numPoints * sumX2) - (sumX * sumX));
////    CGFloat yIntercept = ((sumY * sumX2) - (slope * sumXY))/((numPoints * sumX2) - (sumX * sumX));
//    CGFloat yIntercept = (sumY - slope * sumX) / numPoints;
//    CGFloat rSquared = ((numPoints * sumXY) - (sumX * sumY)) / (sqrt(numPoints * sumX2 - (sumX * sumX)) * sqrt(numPoints * sumY2 - (sumY * sumY)));
//

    return [LinearFunction linearFunctionWithSlope:slope
                                        yIntercept:yIntercept
                                          rSquared:rSquared];
}

- (CGFloat) solveGivenX:(CGFloat)x {
    // y = mx + b
    return ((_slope * x) + _yIntercept);
}

- (CGFloat) solveGivenY:(CGFloat)y {
    // x = (y - b)/m
    return ((y - _yIntercept) / _slope);
}

- (CGFloat) xIntercept {
    // 0 = mx + b
    return (-_yIntercept/_slope);
}

# pragma mark - Description

- (NSString*) description {
    return [NSString stringWithFormat:@"Best Fit: y = %.3fx + %.3f (r: %f)", self.slope, self.yIntercept, self.rSquared];
}

@end
