//
//  RegenerateController.h
//  EVSample
//
//  Created by Santosh Kumar on 11/13/16.
//  Copyright © 2016 EyeVerify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegenerateController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *hello;

@property (strong, nonatomic) IBOutlet UILabel *regenerateCode;
- (IBAction)tappedOnBack:(id)sender;

- (IBAction)tappedOnRegenerateUsing1Code:(id)sender;
- (IBAction)tappedOnRegenerateUsing2Codes:(id)sender;
- (IBAction)tappedOnRegenerateUsing3Codes:(id)sender;

@end
