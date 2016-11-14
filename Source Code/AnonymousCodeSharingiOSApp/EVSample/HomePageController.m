//
//  HomePageController.m
//  EVSample
//
//  Created by Santosh Kumar on 11/13/16.
//  Copyright © 2016 EyeVerify. All rights reserved.
//

#import "HomePageController.h"
#import "UserViewController.h"
#import "RegenerateViewController.h"

@interface HomePageController()

@end

@implementation HomePageController



- (IBAction)tappedOnLogout:(id)sender {
    UserViewController *user_view_controller = [self.storyboard
                                                instantiateViewControllerWithIdentifier:@"UserViewController"];
    [self presentViewController: user_view_controller animated:YES completion:NULL];
}

- (IBAction)tappedOnShareCode:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.213:4567/ret_result"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //Set headers for the data, in this case TEXT
    
    //Valor del post
    //NSString *UUID = [[NSUUID UUID] UUIDString];
    
    //NSString *postData = [NSString stringWithFormat:@"&qp1=%d&qp2=%d&qp3=%d",2,0,1];
    
    NSLog(@"hiii");
    
    
    //  [req setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]]; //Send the content to the URL
    
    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                 returningResponse:&urlResponse
                                                             error:&err];
    if(!(responseData == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.resultView.hidden = NO;
        self.resultView.text = responseString;
        //self.showCode.text = responseString;
        
    }
    
}

- (IBAction)tappedOnRegenerate:(id)sender {
    RegenerateViewController *regenerate_view = [self.storyboard
                                                instantiateViewControllerWithIdentifier:@"RegenerateViewController"];
    [self presentViewController: regenerate_view animated:YES completion:NULL];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if([_showCode isHidden]){
        [_showCode setHidden:NO];
    }
    else{
        [_showCode setHidden:YES];
    }
    self.resultView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
