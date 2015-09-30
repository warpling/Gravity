//
//  CommonMacros.h
//  Created by Tom Adriaenssen (@inferis)
//  Inspired by the awesome work by Piet Jaspers (@pjaspers)
//

/*
 * How to use this file:
 *  1. Find your .pch file
 *  2. Import this file
 *  3. Make sure to import this file after UIKit and Foundation
 *  4. Use the functions in your app.
 */


/*
 * Some general useful things
 * **************************
 */
// Logs a frame of an object (eg a UIView)
#define LogFrame(x) NSLog(@"%s.frame: %@", #x, NSStringFromCGRect((x).frame))
#define LogBounds(x) NSLog(@"%s.bounds: %@", #x, NSStringFromCGRect((x).bounds))

// Blatantly picked up from [Wil Shipley](http://blog.wilshipley.com/2005/10/pimp-my-code-interlude-free-code.html)
//
// > Essentially, if you're wondering if an NSString or NSData or
// > NSAttributedString or NSArray or NSSet has actual useful data in
// > it, this is your macro. Instead of checking things like
// > `if (inputString == nil || [inputString length] == 0)` you just
// > say, "if (IsEmpty(inputString))".
//
// It rocks.
static inline BOOL IsEmpty(id thing) {
    if (thing == nil) return YES;
    if ([thing isEqual:[NSNull null]]) return YES;
    if ([thing respondsToSelector:@selector(count)]) return [thing performSelector:@selector(count)] == 0;
    if ([thing respondsToSelector:@selector(length)]) return [thing performSelector:@selector(length)] == 0;
    return NO;
}

// The inverse for IsEmpty
static inline BOOL IsPresent(id thing) {
    return !IsEmpty(thing);
}


/*
 * Feature checking
 * ****************
 */

// Check if we're running in the simulator.
// You can use the define in your code too, but this makes it easier to use
// in an if statement if you want.
static inline BOOL IsInSimulator() {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#endif
    return NO;
}

// A check to see if we're running on an iPad. Mainly because the function call is
// a lot shorter than the equality check
static inline BOOL IsIPad() {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

static inline BOOL IsIPhoneRunOnIpad() {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad || [[[UIDevice currentDevice] model] hasPrefix:@"iPad"]);
}

static inline BOOL IsPhone() {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

// Checks for pre-iOS7
static inline BOOL IsPreIOS7() {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0;
}

// Checks for iOS7 or later
static inline BOOL IsIOS7OrLater() {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

// Checks for pre-iOS8
static inline BOOL IsPreIOS8() {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0;
}

// Checks for iOS8 or later
static inline BOOL IsIOS8OrLater() {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}


/*
 * GCD shortcuts
 * *************
 */
// dispatches a block on a background queue
// does not block the calling queue/thread
static inline void dispatch_async_bg(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

// dispatches a block on a background queue, but after a specified time interval
// does not block the calling queue/thread
static inline void dispatch_async_bg_after(NSTimeInterval after, dispatch_block_t block) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

// dispatches a block on the main queue
// does not block the calling queue/thread
static inline void dispatch_async_main(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}

// dispatches a block on the main queue, but after a specified time interval
// does not block the calling queue/thread
static inline void dispatch_async_main_after(NSTimeInterval after, dispatch_block_t block) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

// dispatches a block on the main queue
// blocks the calling queue/thread
static inline void dispatch_sync_main(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/*
 * Macros for dealing with CGRects
 * *******************************
 */
// makes whole numbers of a CGRects coordinates by taking the floorf() of each component.
#define CGRectFloor(rect) ({__typeof__(rect) __r = (rect); (CGRect) { floorf(__r.origin.x), floorf(__r.origin.y), ceilf(__r.size.width), ceilf(__r.size.height) }; })
// Set each component (x, y, width, height) of a CGRect indivually
#define CGRectSetX(rect, x) ((CGRect) { (x), (rect).origin.y, (rect).size })
#define CGRectSetY(rect, x) ((CGRect) { (rect).origin.x, (y), (rect).size })
#define CGRectSetWidth(rect, width) ((CGRect) { (rect).origin, (width), (rect).size.height })
#define CGRectSetHeight(rect, height) ((CGRect) { (rect).origin, (rect).size.width, (height) })
// Set the origin (a CGPoint) or the size (a CGSize) of a CGRect
#define CGRectSetOrigin(rect, origin) ((CGRect) { (origin), (rect).size })
#define CGRectSetSize(rect, size) ((CGRect) { (rect).origin, size })
// Offset a side of a rect, and shrink it a the same time (the other sides will remain where they are)
#define CGRectOffsetLeftAndShrink(rect, offset) ({__typeof__(rect) __r = (rect); __typeof__(offset) __o = (offset); (CGRect) { __r.origin.x + __o, __r.origin.y, __r.size.width-__o, __r.size.height }; })
#define CGRectOffsetRightAndShrink(rect, offset) ({__typeof__(rect) __r = (rect); __typeof__(offset) __o = (offset); (CGRect) { __r.origin.x, __r.origin.y, __r.size.width-__o, __r.size.height }; })
#define CGRectOffsetTopAndShrink(rect, offset) ({__typeof__(rect) __r = (rect); __typeof__(offset) __o = (offset); (CGRect) { __r.origin.x, __r.origin.y + __o, __r.size.width, __r.size.height-__o }; })
#define CGRectOffsetBottomAndShrink(rect, offset) ({__typeof__(rect) __r = (rect); __typeof__(offset) __o = (offset); (CGRect) { __r.origin.x, __r.origin.y, __r.size.width, __r.size.height-__o }; })
// this just shrinks the width and height
#define CGRectShrink(rect, w, h) ({__typeof__(rect) __r = (rect); __typeof__(w) __w = (w); __typeof__(h) __h = (h); (CGRect) { __r.origin, __r.size.width - __w, __r.size.height - __h }; })
// this shrinks the rect specified for each side
#define CGRectShrinkSides(rect, left, top, right, bottom) ({__typeof__(rect) __rt = (rect); __typeof__(left) __l = (left); __typeof__(right) __r = (right); __typeof__(top) __t = (top); __typeof__(bottom) __b = (bottom); (CGRect) { __rt.origin.x + __l, __rt.origin.y + __t, __rt.size.width - __l - __r, __rt.size.height - __t - __b }; })
// centers one rect inside another one
#define CGRectCenterInRect(rect, inRect) ({ __typeof__(rect) __r = (rect); __typeof__(rect) __ir = (inRect); (CGRect) { CGRectGetMinX(__ir) + floorf((__ir.size.width-__r.size.width)/2.0f), CGRectGetMinY(__ir) + floorf((__ir.size.height-__r.size.height)/2.0f), __r.size }; })
// centers one rect horizontally inside another one. Vertical placement is maintained.
#define CGRectCenterHorizontallyInRect(rect, inRect) ({ __typeof__(rect) __r = (rect); __typeof__(rect) __ir = (inRect); (CGRect) { CGRectGetMinX(__ir) + floorf((__ir.size.width-__r.size.width)/2.0f), CGRectGetMinY(__r), __r.size }; })
// centers one rect vertically inside another one. Horizontal placement is maintained.
#define CGRectCenterVerticallyInRect(rect, inRect) ({ __typeof__(rect) __r = (rect); __typeof__(rect) __ir = (inRect); (CGRect) { CGRectGetMinX(__r), CGRectGetMinY(__ir) + floorf((__ir.size.height-__r.size.height)/2.0f), __r.size }; })


/*
 * Macros for dealing with CGPoints
 * ********************************
 */
#define CGPointOffset(point, x, y)  ({__typeof__(point) __p = (point); CGPointMake(__p.x + x, __p.y + y); })


/*
 * Converting degrees to/from radians
 * **********************************
 */
inline static CGFloat Degrees2Radians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

inline static CGFloat Radians2Degrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};


#define NSStringFromProperty(property) ([[@"" #property componentsSeparatedByString:@"."] lastObject])


