//
//  HomePageController.h
//  EVSample
//
//  Created by Santosh Kumar on 11/13/16.
//  Copyright © 2016 EyeVerify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnrollResultViewController.h"

@interface HomePageController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *showCode;
@property (strong, nonatomic) IBOutlet UITextView *resultView;

- (IBAction)tappedOnLogout:(id)sender;

- (IBAction)tappedOnShareCode:(id)sender;

- (IBAction)tappedOnRegenerate:(id)sender;



@end
