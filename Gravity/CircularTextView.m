//
//  CircularTextView.m
//  Wormhole
//
//  Created by Ryan McLeod on 5/5/15.
//  Copyright (c) 2015 Ryan McLeod. All rights reserved.
//

#import "CircularTextView.h"
#import <CoreText/CoreText.h>

@implementation CircularTextView

@synthesize attributedText = _attributedText;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert((self.bounds.size.width == self.bounds.size.height), @"%@ can only draw using a square frame!", [self class]);
    }
    return self;
}

- (NSAttributedString*) attributedText {
    return _attributedText;
}

- (void) setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    [self setNeedsDisplay];
}

// Modified from: https://invasivecode.com/weblog/core-text
- (void) drawRect:(CGRect)rect {
    
    [super drawRect:rect]; // 3-4
    
    if (!self.attributedText) {
        return;
    }
    
    CGFloat radius = self.bounds.size.width/2.f;
    
    CGContextRef context = UIGraphicsGetCurrentContext(); // 4-4
    CGContextSetTextMatrix(context, CGAffineTransformIdentity); // 5-4
    
    CGContextTranslateCTM(context, radius, radius); // 6-4
    CGContextScaleCTM(context, 1.0, -1.0); // 7-4
    CGContextRotateCTM(context, M_PI_2); // 8-4
 
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attributedText);// 9-4
    CFIndex glyphCount = CTLineGetGlyphCount(line); // 10-4
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray); // 11-4
    
    NSMutableArray *widthArray = [[NSMutableArray alloc] init]; // 12-4
    
    CFIndex glyphOffset = 0;
    for (CFIndex i = 0; i < runCount; i++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, i);
        CFIndex runGlyphCount = CTRunGetGlyphCount((CTRunRef)run);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            NSNumber *widthValue = [NSNumber numberWithDouble:CTRunGetTypographicBounds((CTRunRef)run, CFRangeMake(runGlyphIndex, 1), NULL, NULL, NULL)];
            [widthArray insertObject:widthValue atIndex:(runGlyphIndex + glyphOffset)];  // 13-4
        }
        glyphOffset = runGlyphCount + 1;
    }
    
    CGFloat lineLength = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
    
    NSMutableArray *angleArray = [[NSMutableArray alloc] init]; // 14-4
    
    CGFloat prevHalfWidth =  [[widthArray objectAtIndex:0] floatValue] / 2.0;
    NSNumber *angleValue = [NSNumber numberWithDouble:(prevHalfWidth / lineLength) * 2 * M_PI];
    [angleArray insertObject:angleValue atIndex:0];
    
    for (CFIndex lineGlyphIndex = 1; lineGlyphIndex < glyphCount; lineGlyphIndex++) {
        CGFloat halfWidth = [[widthArray objectAtIndex:lineGlyphIndex] floatValue] / 2.0;
        CGFloat prevCenterToCenter = prevHalfWidth + halfWidth;
        // spread over whole circle
//        NSNumber *angleValue = [NSNumber numberWithDouble:(prevCenterToCenter / lineLength) * 2 * M_PI];
        // actually spaced in a rational way
        NSNumber *angleValue = [NSNumber numberWithDouble:(atan2(prevCenterToCenter/2.f, radius) * 2)];
        
        [angleArray insertObject:angleValue atIndex:lineGlyphIndex]; // 15-4
        prevHalfWidth = halfWidth;
    }
    
    
    // Warning: This will not work as expected for strings with mixed fonts/sizes!
    // Calculate line height from the first run in the string
    CTFontRef fontRef = CFAttributedStringGetAttribute((CFAttributedStringRef)self.attributedText, 0, kCTFontAttributeName, NULL);
    CGFloat lineHeight = 0.0;
    lineHeight = CTFontGetAscent(fontRef) + CTFontGetDescent(fontRef) + CTFontGetLeading(fontRef);
    
    
    // TODO: use actual height of font
    CGPoint textPosition = CGPointMake(0.0, radius - lineHeight - self.inset);
    CGContextSetTextPosition(context, textPosition.x, textPosition.y);
    
    glyphOffset = 0;
    for (CFIndex runIndex = 0; runIndex < runCount; runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CFIndex runGlyphCount = CTRunGetGlyphCount(run);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            
            CFRange glyphRange = CFRangeMake(runGlyphIndex, 1);
            
            CGContextRotateCTM(context, -[[angleArray objectAtIndex:(runGlyphIndex + glyphOffset)] floatValue]); // 16-4
            
            CGFloat glyphWidth = [[widthArray objectAtIndex:(runGlyphIndex + glyphOffset)] floatValue];
            CGFloat halfGlyphWidth = glyphWidth / 2.0;
            CGPoint positionForThisGlyph = CGPointMake(textPosition.x - halfGlyphWidth, textPosition.y); // 17-4
            
            textPosition.x -= glyphWidth;
            
            CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
            textMatrix.tx = positionForThisGlyph.x; textMatrix.ty = positionForThisGlyph.y;
            CGContextSetTextMatrix(context, textMatrix);
            
            CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
            CGGlyph glyph; CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            CGContextSetFont(context, cgFont);
            CGContextSetFontSize(context, CTFontGetSize(runFont));
            
            CGContextSetRGBFillColor(context, 0.9, 0.9, 0.9, 1.0);
            CGContextShowGlyphsAtPositions(context, &glyph, &position, 1);
            
//            CGContextSetRGBFillColor(context, 1, 0, 1, 0.4);
//            CGContextFillRect(context, CGRectMake(positionForThisGlyph.x, positionForThisGlyph.y, glyphWidth, 2));
            
            CFRelease(cgFont);
        }
        glyphOffset += runGlyphCount;
    }
}


//static double Bezier(double t, double P0, double P1, double P2,
//                     double P3) {
//    return
//    (1-t)*(1-t)*(1-t) * P0
//    + 3 * (1-t)*(1-t) * t * P1
//    + 3 * (1-t) * t*t * P2
//    + t*t*t * P3;
//}
//
//- (CGPoint)pointForOffset:(double)t {
//    double x = Bezier(t, _P0.x, _P1.x, _P2.x, _P3.x);
//    double y = Bezier(t, _P0.y, _P1.y, _P2.y, _P3.y);
//    return CGPointMake(x, y);
//}
//
//// Simplistic routine to find the offset along Bezier that is
//// aDistance away from aPoint. anOffset is the offset used to
//// generate aPoint, and saves us the trouble of recalculating it
//// This routine just walks forward until it finds a point at least
//// aDistance away. Good optimizations here would reduce the number
//// of guesses, but this is tricky since if we go too far out, the
//// curve might loop back on leading to incorrect results. Tuning
//// kStep is good start.
//- (double)offsetAtDistance:(double)aDistance
//                 fromPoint:(CGPoint)aPoint
//                 andOffset:(double)anOffset {
//    const double kStep = 0.001; // 0.0001 - 0.001 work well
//    double newDistance = 0;
//    double newOffset = anOffset + kStep;
//    while (newDistance <= aDistance && newOffset < 1.0) {
//        newOffset += kStep;
//        newDistance = Distance(aPoint,
//                               [self pointForOffset:newOffset]);
//    }
//    return newOffset;
//}
//
//- (void) drawRect:(CGRect)rect {
//    
//    [super drawRect:rect];
//
//    if ([self.attributedText length] == 0) { return; }
//    
//    NSLayoutManager *layoutManager = self.layoutManager;
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    NSRange glyphRange;
//    CGRect lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:0
//                                                      effectiveRange:&glyphRange];
//    
//    double offset = 0;
//    CGPoint lastGlyphPoint = self.P0;
//    CGFloat lastX = 0;
//    for (NSUInteger glyphIndex = glyphRange.location;
//         glyphIndex < NSMaxRange(glyphRange);
//         ++glyphIndex) {
//        CGContextSaveGState(context);
//        
//        CGPoint location = [layoutManager locationForGlyphAtIndex:glyphIndex];
//        
//        CGFloat distance = location.x - lastX;  // Assume single line
//        offset = [self offsetAtDistance:distance
//                              fromPoint:lastGlyphPoint
//                              andOffset:offset];
//        CGPoint glyphPoint = [self pointForOffset:offset];
//        double angle = [self angleForOffset:offset];
//        
//        lastGlyphPoint = glyphPoint;
//        lastX = location.x;
//        
//        CGContextTranslateCTM(context, glyphPoint.x, glyphPoint.y);
//        CGContextRotateCTM(context, angle);
//        
//        [layoutManager drawGlyphsForGlyphRange:NSMakeRange(glyphIndex, 1)
//                                       atPoint:CGPointMake(-(lineRect.origin.x + location.x),
//                                                           -(lineRect.origin.y + location.y))];
//        
//        CGContextRestoreGState(context);
//    }
//
//}

@end
