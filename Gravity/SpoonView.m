//
//  SpoonView.m
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "SpoonView.h"

@implementation SpoonView

+ (instancetype) new {
    SpoonView *spoon = [super new];
    if (spoon) {
        spoon.path = [SpoonView spoonPath];
        spoon.fillColor = [UIColor clearColor];
        spoon.strokeColor = [UIColor whiteColor];
        spoon.lineDashPattern = @[@8, @8];
        spoon.lineWidth = 2;
        spoon.lineCap = kCALineCapRound;
    }
    return spoon;
}

- (CGSize) intrinsicContentSize {
    return CGPathGetPathBoundingBox([[SpoonView spoonPath] CGPath]).size;
}

+ (UIBezierPath*) spoonPath {
    
    CGFloat scale = 0.5;
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(scale*713.55, scale*173.47)];
    [bezierPath addCurveToPoint: CGPointMake(scale*924.85, scale*184.67) controlPoint1: CGPointMake(scale*802.75, scale*178.17) controlPoint2: CGPointMake(scale*863.85, scale*181.57)];
    [bezierPath addCurveToPoint: CGPointMake(scale*1033.55, scale*189.17) controlPoint1: CGPointMake(scale*961.05, scale*186.47) controlPoint2: CGPointMake(scale*997.25, scale*188.17)];
    [bezierPath addCurveToPoint: CGPointMake(scale*1089.65, scale*169.37) controlPoint1: CGPointMake(scale*1054.55, scale*189.77) controlPoint2: CGPointMake(scale*1073.45, scale*182.97)];
    [bezierPath addCurveToPoint: CGPointMake(scale*1092.45, scale*100.97) controlPoint1: CGPointMake(scale*1112.15, scale*150.47) controlPoint2: CGPointMake(scale*1113.15, scale*121.77)];
    [bezierPath addCurveToPoint: CGPointMake(scale*1055.25, scale*80.97) controlPoint1: CGPointMake(scale*1082.05, scale*90.57) controlPoint2: CGPointMake(scale*1069.25, scale*84.67)];
    [bezierPath addCurveToPoint: CGPointMake(scale*993.05, scale*79.57) controlPoint1: CGPointMake(scale*1034.65, scale*75.37) controlPoint2: CGPointMake(scale*1013.75, scale*78.47)];
    [bezierPath addCurveToPoint: CGPointMake(scale*731.35, scale*93.27) controlPoint1: CGPointMake(scale*905.75, scale*83.87) controlPoint2: CGPointMake(scale*818.55, scale*88.57)];
    [bezierPath addCurveToPoint: CGPointMake(scale*451.65, scale*108.67) controlPoint1: CGPointMake(scale*638.15, scale*98.27) controlPoint2: CGPointMake(scale*544.95, scale*103.57)];
    [bezierPath addCurveToPoint: CGPointMake(scale*384.05, scale*74.47) controlPoint1: CGPointMake(scale*422.55, scale*110.27) controlPoint2: CGPointMake(scale*400.85, scale*98.17)];
    [bezierPath addCurveToPoint: CGPointMake(scale*349.25, scale*33.47) controlPoint1: CGPointMake(scale*373.75, scale*59.87) controlPoint2: CGPointMake(scale*362.05, scale*45.87)];
    [bezierPath addCurveToPoint: CGPointMake(scale*271.65, scale*0.57) controlPoint1: CGPointMake(scale*327.85, scale*12.87) controlPoint2: CGPointMake(scale*302.35, scale*-0.23)];
    [bezierPath addCurveToPoint: CGPointMake(scale*121.55, scale*24.47) controlPoint1: CGPointMake(scale*220.65, scale*1.87) controlPoint2: CGPointMake(scale*170.45, scale*9.47)];
    [bezierPath addCurveToPoint: CGPointMake(scale*31.45, scale*70.27) controlPoint1: CGPointMake(scale*88.85, scale*34.47) controlPoint2: CGPointMake(scale*57.55, scale*47.27)];
    [bezierPath addCurveToPoint: CGPointMake(scale*30.45, scale*196.57) controlPoint1: CGPointMake(scale*-9.85, scale*106.77) controlPoint2: CGPointMake(scale*-10.25, scale*159.57)];
    [bezierPath addCurveToPoint: CGPointMake(scale*103.25, scale*237.17) controlPoint1: CGPointMake(scale*51.55, scale*215.77) controlPoint2: CGPointMake(scale*76.75, scale*227.77)];
    [bezierPath addCurveToPoint: CGPointMake(scale*258.25, scale*266.57) controlPoint1: CGPointMake(scale*153.25, scale*254.97) controlPoint2: CGPointMake(scale*205.25, scale*263.27)];
    [bezierPath addCurveToPoint: CGPointMake(scale*333.55, scale*246.87) controlPoint1: CGPointMake(scale*285.85, scale*268.27) controlPoint2: CGPointMake(scale*310.95, scale*262.87)];
    [bezierPath addCurveToPoint: CGPointMake(scale*386.45, scale*190.17) controlPoint1: CGPointMake(scale*355.05, scale*231.57) controlPoint2: CGPointMake(scale*371.75, scale*211.97)];
    [bezierPath addCurveToPoint: CGPointMake(scale*449.35, scale*158.57) controlPoint1: CGPointMake(scale*401.35, scale*168.17) controlPoint2: CGPointMake(scale*422.85, scale*157.17)];
    [bezierPath addCurveToPoint: CGPointMake(scale*713.55, scale*173.47) controlPoint1: CGPointMake(scale*546.85, scale*163.77) controlPoint2: CGPointMake(scale*644.25, scale*169.57)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

@end
