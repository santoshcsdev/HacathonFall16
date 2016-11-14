//
//  RegenerateController.m
//  EVSample
//
//  Created by Santosh Kumar on 11/13/16.
//  Copyright © 2016 EyeVerify. All rights reserved.
//

#import "RegenerateController.h"
#import "HomePageController.h"

@implementation RegenerateController

- (IBAction)tappedOnBack:(id)sender {
    HomePageController *home_page_back = [self.storyboard
                                                instantiateViewControllerWithIdentifier:@"HomePageController"];
    [self presentViewController: home_page_back animated:YES completion:NULL];
}

- (IBAction)tappedOnRegenerateUsing1Code:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://10.205.0.57:4567/get1/?qp1=2"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"hiii");

    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                 returningResponse:&urlResponse
                                                             error:&err];
    if(!(responseData == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.regenerateCode.hidden = NO;
        self.regenerateCode.text = responseString;
        
    }
}

- (IBAction)tappedOnRegenerateUsing2Codes:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://10.205.0.57:4567/get2/?qp1=2&qp2=0"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"hiii");
    
    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                 returningResponse:&urlResponse
                                                             error:&err];
    if(!(responseData == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.regenerateCode.hidden = NO;
        self.regenerateCode.text = responseString;
        
    }
}

- (IBAction)tappedOnRegenerateUsing3Codes:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://10.205.0.57:4567/get3/?qp1=2&qp2=0&qp3=1"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"hiii");
    
    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                 returningResponse:&urlResponse
                                                             error:&err];
    if(!(responseData == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.regenerateCode.hidden = NO;
        self.regenerateCode.text = responseString;
        
    }
}

- (void)viewDidLoad {
   self.hello.hidden=YES;
    self.regenerateCode.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
