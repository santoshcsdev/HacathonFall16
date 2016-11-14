//
//  UserViewController.m
//  EyeprintID
//

#import "UserViewController.h"
#import "EyeVerifyLoader.h"

#define hintCellHeight 40
#define hintMaxHeight 120
#define cellIdentifier @"HintCell"

@interface UserViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *allUsers;
@property (strong, nonatomic) NSArray *matchingUsers;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UserHintsTableHeight;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *enrollButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UITableView *userHintsTable;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    self.userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    self.navigationController.navigationBar.tintColor = nil;
    self.enrollButton.tintColor = nil;
    self.verifyButton.tintColor = nil;
    self.settingsButton.tintColor = nil;

    [self.userHintsTable reloadData];

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];

    self.allUsers = [ev getEnrolledUsers];

    [self checkUser];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self checkUser];
}

-(IBAction) verify:(id)sender
{
    NSString *currSysVer = UIDevice.currentDevice.systemVersion;

    if (currSysVer.floatValue < 8.0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"iOS Version Too Old", comment: @"")
                                   message:NSLocalizedString(@"EyeVerify can only be used on iOS 8 or later", comment: @"")
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"OK", comment: @"")
                         otherButtonTitles:nil];

        [message show];
        return;
    }
    if (!self.validateInput) {
        return;
    }

    [NSUserDefaults.standardUserDefaults setObject:self.userTextField.text forKey:@"username"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self performSegueWithIdentifier:@"verify" sender:self];
}

-(IBAction) enroll:(id)sender
{
    NSString *currSysVer = UIDevice.currentDevice.systemVersion;

    if (currSysVer.floatValue < 8.0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"iOS Version Too Old", comment: @"")
                                                          message:NSLocalizedString(@"EyeVerify can only be used on iOS 8 or later", comment: @"")
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", comment: @"")
                                                otherButtonTitles:nil];

        [message show];
        return;
    }

    if (!self.validateInput) {
        return;
    }

    [NSUserDefaults.standardUserDefaults setObject:self.userTextField.text forKey:@"username"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self performSegueWithIdentifier:@"enroll" sender:self];
}

-(IBAction) unwindToUserViewController:(UIStoryboardSegue *)unwindSegue {

}

// MARK: - User Hints Table Methods
- (BOOL) validateInput {
    NSString *userName = self.userTextField.text;
    if (![userName length]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Username", comment: @"")
                                                          message:NSLocalizedString(@"Username should consist of at least one alphanumeric character", comment: @"")
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", comment: @"")
                                                otherButtonTitles:nil];
        [message show];
        return NO;
    }
    [NSUserDefaults.standardUserDefaults setObject:userName forKey:@"user"];
    [NSUserDefaults.standardUserDefaults synchronize];

    [self.userTextField resignFirstResponder];

    return YES;
}

-(void)checkUser {
    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];

    if (ev) {
        BOOL isEnrolled = NO;

        NSString *userName = self.userTextField.text;

        if ([userName length]) {
            isEnrolled = [ev isUserEnrolled:userName];
        }

        if (isEnrolled) {
            [self.enrollButton setTitle:NSLocalizedString(@"Recreate Eyeprint", comment: @"") forState:UIControlStateNormal];
        } else {
            [self.enrollButton setTitle:NSLocalizedString(@"Create an Eyeprint", comment: @"") forState:UIControlStateNormal];
        }

        self.verifyButton.enabled = isEnrolled;
        self.verifyButton.alpha = isEnrolled ? 1.0 : 0.5;
    } else {
        NSLog(@"Couldn't find instance of EyeVerify");
    }
}

// MARK: - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{ // return NO to not change text
//    NSString *userName = self.userTextField.text;
//
//    NSUInteger userNameLength = [userName length];
//
//    if (userNameLength) {
//        if (![string length]) {
//            return YES;
//        } else if ([string length] > 1) {
//            NSLog(@"Trying to replace more than 1 character");
//            return NO;
//        } else if (userNameLength >= 40) {
//            NSLog(@"Max userName length is 40 characters");
//            return NO;
//        }
//
//        if ([string rangeOfString:@"[A-Za-z0-9]" options:NSRegularExpressionSearch].length) {
//            return YES;
//        } else {
//            return NO;
//        }
//    }
//    return NO;
//}

// MARK: - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"License", comment: @"")]) {
        if (buttonIndex == 0) {
            // TODO: Not sure what this is doing. Should probably be removed.
            exit(0);
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"AcceptedEULA"];
        }
    } else if ([alertView.title isEqualToString: NSLocalizedString(@"Recreate Eyeprint", comment: @"")]) {
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"enroll" sender:self];
        }
    }
}

@end
