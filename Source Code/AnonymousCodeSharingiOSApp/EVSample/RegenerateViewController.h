//
//  RegenerateViewController.h
//  EVSample
//
//  Created by Santosh Kumar on 11/14/16.
//  Copyright © 2016 EyeVerify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegenerateViewController : UIViewController
- (IBAction)tappedBack:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *result;
- (IBAction)tappedOnRegenerateUsing1Code:(id)sender;
- (IBAction)tappedOnRegenerateUsing2Codes:(id)sender;

- (IBAction)tappedOnRegenerateUsing3Codes:(id)sender;

@end
