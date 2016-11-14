//
//  EnrollViewController.m
//  EyeprintID
//

#import "EnrollViewController.h"
#import "ScanningOverlayView.h"
#import "EyeVerifyLoader.h"
#import "EnrollResultViewController.h"

@interface EnrollViewController () <EVAuthSessionDelegate>

@property (weak, nonatomic) IBOutlet UIButton* scanAgainButton;
@property (weak, nonatomic) IBOutlet UIView* captureView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet ScanningOverlayView *scanningOverlay;
@property (weak, nonatomic) IBOutlet UILabel *counterText;
@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarWidthConstraint;

@property (assign, nonatomic) BOOL enrollmentComplete;
@property (assign, nonatomic) BOOL shouldDismiss;
@property (strong, nonatomic) NSString *demoUserKey;

@end

@implementation EnrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.demoUserKey = @"iOS User Key Test 1!2@3#4$5%6^7&8*9/0";

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];

    if (ev) {
        NSString *username = [NSUserDefaults.standardUserDefaults objectForKey:@"username"];

        if (username) {
            ev.userName = username;
            [ev setCaptureView: self.captureView];
        } else {
            self.shouldDismiss = YES;
        }
    } else {
        self.shouldDismiss = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.counterText.hidden = YES;
    self.scanAgainButton.enabled = NO;

    self.progressBarWidthConstraint.constant = 0;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.shouldDismiss) {
        [self performSegueWithIdentifier:@"unwindToUserViewController" sender: self];
        return;
    }

    if (!self.enrollmentComplete) {
        [self enroll];
    }
}

- (void) enroll {

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];

    if (ev) {
        [ev setEVAuthSessionDelegate:self];
        [ev enrollUser:ev.userName userKey:[self.demoUserKey dataUsingEncoding:NSUTF8StringEncoding] localCompletionBlock:^(BOOL enrolled, NSData *userKey, NSError *error) {
            NSLog(@"Enrollment localCompletionBlock: enrolled=\(enrolled); userKey=\(userKey != nil ? NSString(data: userKey!, encoding: NSUTF8StringEncoding) : nil) error=\(error)");
            self.enrollmentComplete = true;

            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (enrolled) {
                    [strongSelf performSegueWithIdentifier:@"success" sender:self];
                } else {
                    [strongSelf performSegueWithIdentifier:@"failure" sender:self];
                }
            });
        }];
    }
}

- (IBAction) cancel:(id)sender {
    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    if (ev) {
        [ev cancel];
    }
}

- (IBAction) scanAgain:(id)sender {
    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    if (ev) {
        [ev continueAuth];
    }
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void) eyeStatusChanged:(EVEyeStatus)newEyeStatus
{
    self.scanningOverlay.targetHighlighted = NO;
    switch (newEyeStatus) {
        case EVEyeStatusNoEye:
            self.notificationLabel.text = NSLocalizedString(@"Position your eyes in the window", comment: "");
            self.notificationLabel.hidden = NO;
        case EVEyeStatusTooFar:
            self.notificationLabel.text = NSLocalizedString(@"Move device closer", comment: "");
            self.notificationLabel.hidden = NO;
        case EVEyeStatusOkay:
            self.scanningOverlay.targetHighlighted = YES;
            self.notificationLabel.hidden = YES;
    }
}

- (void) enrollmentProgressUpdated:(float)completionRatio counter:(int)counterValue
{
    self.counterText.text =  [NSString stringWithFormat:@"%d", counterValue];
    self.counterText.hidden = (counterValue == 0);

    self.progressBarWidthConstraint.constant = self.progressBarView.bounds.size.width * completionRatio;
    [self.progressBarView layoutSubviews];
}

- (void) enrollmentSessionStarted:(int)totalSteps
{
    self.counterText.text =  [NSString stringWithFormat:@"%d", totalSteps];
    self.counterText.hidden = NO;
    self.scanAgainButton.enabled = NO;
    self.scanningOverlay.hidden = NO;
}

- (void)enrollmentSessionCompleted:(BOOL)isFinished
{
    self.counterText.hidden = YES;
    if (isFinished) {
        self.scanAgainButton.enabled = NO;
    } else {
        self.scanAgainButton.enabled = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    EnrollResultViewController *vc = (EnrollResultViewController *) segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"success"]) {
        vc.messageColor = [UIColor blackColor];
        vc.message = NSLocalizedString(@"Enrolled Successfully!", comment: @"");
    } else if ([segue.identifier isEqualToString:@"failure"]) {
        vc.messageColor = [UIColor redColor];
        vc.message = NSLocalizedString(@"Enrollment Unsuccessful", comment: @"");
    }
}

@end
