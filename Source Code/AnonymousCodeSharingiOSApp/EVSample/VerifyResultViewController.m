//
//  VerifyResultViewController.m
//  EyeprintID
//

#import "VerifyResultViewController.h"

@interface VerifyResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation VerifyResultViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.messageLabel.text = self.message;
}

@end
