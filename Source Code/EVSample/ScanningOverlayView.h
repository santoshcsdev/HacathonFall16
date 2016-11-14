//
//  ScanningOverlayView.h
//  EyeVerifyFrameworks
//

#import <UIKit/UIKit.h>

@interface ScanningOverlayView : UIView

@property (assign, nonatomic) bool targetHighlighted;

- (void) setDistanceClose;
- (void) setDistanceFar;

@end

@interface Scanline : UIView

- (void) startAnimating;
- (void) stopAnimating;

@end
