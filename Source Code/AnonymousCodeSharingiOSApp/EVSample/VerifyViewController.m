//
//  EnrollViewController.m
//  EyeprintID
//

#import "VerifyViewController.h"
#import "ScanningOverlayView.h"
#import "EyeVerifyLoader.h"
#import "VerifyResultViewController.h"
#import "HomePageController.h"
#import <AVFoundation/AVFoundation.h>

@interface VerifyViewController () <EVAuthSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView* captureView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet ScanningOverlayView *scanningOverlay;

@property (strong, nonatomic) NSData *userKey;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) AVAudioPlayer *verifiedPrompt;

@property (assign, nonatomic) BOOL shouldDismiss;
@property (assign, nonatomic) BOOL verificationComplete;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    NSString *audioPath = [NSBundle.mainBundle pathForResource:@"verified_prompt" ofType: @"mp3"];
    self.verifiedPrompt = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioPath] error:nil];

    if (self.verifiedPrompt) {
        [self.verifiedPrompt prepareToPlay];
    }

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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.shouldDismiss) {
        [self performSegueWithIdentifier:@"unwindToUserViewController" sender: self];
        return;
    }

    if (!self.verificationComplete) {
        [self verify];
    }
}

- (void) verify {

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];

    if (ev) {
        [ev setEVAuthSessionDelegate:self];
        [ev verifyUser:ev.userName localCompletionBlock:^(BOOL verified, NSData *userKey, NSError *error) {
            //NSLog(@"Enrollment localCompletionBlock: enrolled=\(enrolled); userKey=\(userKey != nil ? NSString(data: userKey!, encoding: NSUTF8StringEncoding) : nil) error=\(error)");
            self.verificationComplete = true;
            self.userKey = userKey;
            if (error) {
                self.errorMessage = error.localizedFailureReason;
            }

            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{

                __strong typeof(self) strongSelf = weakSelf;
                if (verified) {
                    [strongSelf.verifiedPrompt play];
                    //[strongSelf performSegueWithIdentifier:@"success" sender:self];
                    
                    HomePageController *controller_home = [self.storyboard
                                                   instantiateViewControllerWithIdentifier:@"HomePageController"];
                    [self presentViewController: controller_home animated:YES completion:NULL];
                    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    VerifyResultViewController *vc = (VerifyResultViewController *) segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"success"]) {
        vc.messageColor = [UIColor blackColor];
        vc.message = NSLocalizedString(@"Eyeprint verified!", comment: @"");
    } else if ([segue.identifier isEqualToString:@"failure"]) {
        vc.messageColor = [UIColor redColor];
        vc.message = NSLocalizedString(@"Not Verified", comment: @"");
    }
}

@end
