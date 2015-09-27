//
//  LinearFunctionTests.m
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LinearFunction.h"

@interface LinearFunctionTests : XCTestCase

@end

@implementation LinearFunctionTests

static CGFloat floatAccuracy = 0.001;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasicFn {

    LinearFunction *basicFn = [LinearFunction linearFunctionWithSlope:2.5 yIntercept:1.25 rSquared:0];
    
    CGFloat yResult = [basicFn solveGivenX:50];
    XCTAssertEqualWithAccuracy(yResult, 126.25, floatAccuracy);
}

- (void)testBasicFn2 {
    
    LinearFunction *basicFn = [LinearFunction linearFunctionWithSlope:-10 yIntercept:0 rSquared:0];
    
    CGFloat yResult = [basicFn solveGivenX:-50];
    XCTAssertEqualWithAccuracy(yResult, 500, floatAccuracy);
}

- (void)testFlat {
    
    LinearFunction *basicFn = [LinearFunction linearFunctionWithSlope:0 yIntercept:0 rSquared:0];
    
    CGFloat yResult = [basicFn solveGivenX:50];
    XCTAssertEqualWithAccuracy(yResult, 0, floatAccuracy);
}

- (void)testBestFitOnePoint {
    
    NSArray *xValues = @[@(1)];
    NSArray *yValues = @[@(2)];
    
    LinearFunction *fitFn = [LinearFunction bestFitWithXValues:xValues yValues:yValues];
    
    XCTAssertNil(fitFn);
}

- (void)testBestFitFewPoints {
    NSArray *xValues = @[@1, @2, @4, @5, @10, @20];
    NSArray *yValues = @[@4, @6, @12, @15, @34, @68];
    
    LinearFunction *fitFn = [LinearFunction bestFitWithXValues:xValues yValues:yValues];
    
    XCTAssertEqualWithAccuracy(fitFn.slope, 3.4365, floatAccuracy);
    XCTAssertEqualWithAccuracy(fitFn.yIntercept, -0.8889, floatAccuracy);
    XCTAssertEqualWithAccuracy(fitFn.rSquared, 0.9984, floatAccuracy);
}

- (void)testBestFitFewPoints2 {
    NSArray *xValues = @[@0.41667,
                         @0.533333,
                         @0.63333,
                         @0.75000,
                         @0.850000,
                         @2.633,
                         @2.25];
    
    NSArray *yValues = @[@28.77,
                         @34.59,
                         @40.44,
                         @46.26,
                         @51.52,
                         @151.52,
                         @128.77];
    
    LinearFunction *fitFn = [LinearFunction bestFitWithXValues:xValues yValues:yValues];
    
    XCTAssertEqualWithAccuracy(fitFn.slope, 55.312, floatAccuracy);
    XCTAssertEqualWithAccuracy(fitFn.yIntercept, 5.1009, floatAccuracy);
    XCTAssertEqualWithAccuracy(fitFn.rSquared, 0.9999, floatAccuracy);
}

@end
