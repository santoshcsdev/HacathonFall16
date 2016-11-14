//
//  ScanningOverlayView.m
//  EyeVerifyFrameworks
//

#import "ScanningOverlayView.h"

#define LEFT_RIGHT_MARGIN_FAR 20
#define TOP_BOTTOM_MARGIN_FAR 30

#define LEFT_RIGHT_MARGIN_CLOSE 5
#define TOP_BOTTOM_MARGIN_CLOSE 7

static CGRect scanlineRect;
static int scanlineStartY;
static int scanlineStopY;

@interface ScanningOverlayView () {
    int topBottomMargin;
    int rightLeftMargin;
    int targetLineWidthNotHighlighted;
    int targetLineWidthHighlighted;
    int targetLineLength;
}

@end

@implementation ScanningOverlayView

- (void) dealloc {
    NSLog(@"ScanningOverlayView deallocated");
}

- (void) initializeConstants {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = false;
    topBottomMargin = TOP_BOTTOM_MARGIN_FAR;
    rightLeftMargin = LEFT_RIGHT_MARGIN_FAR;
    targetLineWidthNotHighlighted = 3;
    targetLineWidthHighlighted = 5;
    targetLineLength = 20;
    //self.targetHighlighted = YES;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    scanlineRect = CGRectMake(rightLeftMargin, 0, frame.size.width - 2 * rightLeftMargin, 2);
    scanlineStartY = frame.origin.y + topBottomMargin;
    scanlineStopY = frame.size.height - topBottomMargin;
    [self setNeedsDisplay];
}

- (void)setTargetHighlighted:(bool)targetHighlighted {
    _targetHighlighted = targetHighlighted;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //CGRectMake(0, 0, rect.size.width, topBottomMargin)
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (!topBottomMargin) {
        [self initializeConstants];
    }

    [self drawOverlay:rect context:context];
    [self drawTarget:rect context:context];
}

- (void)drawOverlay:(CGRect)rect context:(CGContextRef)context
{
    //draw outside overlay
    UIColor * overlayColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
    CGContextSetFillColorWithColor(context, overlayColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, topBottomMargin));//top
    CGContextFillRect(context, CGRectMake(0, rect.size.height - topBottomMargin, rect.size.width, topBottomMargin));//bottom
    CGContextFillRect(context, CGRectMake(0, topBottomMargin,
                                          rightLeftMargin, rect.size.height - 2 * topBottomMargin));//left
    CGContextFillRect(context, CGRectMake(rect.size.width - rightLeftMargin, topBottomMargin,
                                          rightLeftMargin, rect.size.height - 2 * topBottomMargin));//right
}

- (void)drawTarget:(CGRect)rect context:(CGContextRef)context
{
    //draw target
    UIColor * targetColorHighlighted = [UIColor colorWithRed:0.4 green:0.8 blue:0.4 alpha:1.0];
    UIColor * targetColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];

    CGContextSetFillColorWithColor(context, (self.targetHighlighted ? targetColorHighlighted : targetColor).CGColor);
    int targetLineWidth = self.targetHighlighted ? targetLineWidthHighlighted : targetLineWidthNotHighlighted;

    //top left corner:
    CGContextFillRect(context, CGRectMake(rightLeftMargin - targetLineWidth, topBottomMargin - targetLineWidth,
                                          targetLineLength, targetLineWidth));
    CGContextFillRect(context, CGRectMake(rightLeftMargin - targetLineWidth, topBottomMargin,
                                          targetLineWidth, targetLineLength - targetLineWidth));

    //top right corner:
    CGContextFillRect(context, CGRectMake(rect.size.width - rightLeftMargin - targetLineLength + targetLineWidth,
                                          topBottomMargin - targetLineWidth,
                                          targetLineLength, targetLineWidth));
    CGContextFillRect(context, CGRectMake(rect.size.width - rightLeftMargin, topBottomMargin,
                                          targetLineWidth, targetLineLength - targetLineWidth));

    //bottom right corner:
    CGContextFillRect(context, CGRectMake(rect.size.width - rightLeftMargin - targetLineLength + targetLineWidth,
                                          rect.size.height - topBottomMargin,
                                          targetLineLength, targetLineWidth));
    CGContextFillRect(context, CGRectMake(rect.size.width - rightLeftMargin,
                                          rect.size.height - topBottomMargin - targetLineLength + targetLineWidth,
                                          targetLineWidth, targetLineLength - targetLineWidth));

    //bottom left corner:
    CGContextFillRect(context, CGRectMake(rightLeftMargin - targetLineWidth, rect.size.height - topBottomMargin,
                                          targetLineLength, targetLineWidth));
    CGContextFillRect(context, CGRectMake(rightLeftMargin - targetLineWidth,
                                          rect.size.height - topBottomMargin - targetLineLength + targetLineWidth,
                                          targetLineWidth, targetLineLength - targetLineWidth));
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };

    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void) setDistanceClose {
    rightLeftMargin = LEFT_RIGHT_MARGIN_CLOSE;
    topBottomMargin = TOP_BOTTOM_MARGIN_CLOSE;

    [self setFrame:self.frame];
}


- (void) setDistanceFar {
    rightLeftMargin = LEFT_RIGHT_MARGIN_FAR;
    topBottomMargin = TOP_BOTTOM_MARGIN_FAR;

    [self setFrame:self.frame];
}

@end

@implementation Scanline

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.hidden = YES;
    }
    return self;
}

- (void) startAnimating {
    self.frame = scanlineRect;
    self.center = CGPointMake(self.center.x, scanlineStartY);
    self.hidden = NO;

    __weak Scanline * weakSelf = self;
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                     animations: ^(void) {
                         weakSelf.center = CGPointMake(weakSelf.center.x, scanlineStopY);
                     }
                     completion:NULL];
}

- (void) stopAnimating {
    [self.layer removeAllAnimations];
    self.hidden = YES;
}

@end
