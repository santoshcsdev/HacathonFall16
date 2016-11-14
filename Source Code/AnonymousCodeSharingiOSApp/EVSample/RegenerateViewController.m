//
//  RegenerateViewController.m
//  EVSample
//
//  Created by Santosh Kumar on 11/14/16.
//  Copyright © 2016 EyeVerify. All rights reserved.
//

#import "RegenerateViewController.h"
#import "HomePageController.h"

@interface RegenerateViewController ()

@end

@implementation RegenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.result.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tappedBack:(id)sender {
    HomePageController *back_view = [self.storyboard
                                                 instantiateViewControllerWithIdentifier:@"HomePageController"];
    [self presentViewController: back_view animated:YES completion:NULL];
}
- (IBAction)tappedOnRegenerateUsing1Code:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.213:4567/get1/?qp1=2"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"1");
    
    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData1 = [NSURLConnection sendSynchronousRequest:req
                                                  returningResponse:&urlResponse
                                                              error:&err];
    if(!(responseData1 == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData1 encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.result.hidden = NO;
        self.result.text = responseString;
        
    }
    
}

- (IBAction)tappedOnRegenerateUsing2Codes:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.213:4567/get2/?qp1=2&qp2=0"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"2");
    
    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData2 = [NSURLConnection sendSynchronousRequest:req
                                                  returningResponse:&urlResponse
                                                              error:&err];
    if(!(responseData2 == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData2 encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.result.hidden = NO;
        self.result.text = responseString;
        
    }
    
}

- (IBAction)tappedOnRegenerateUsing3Codes:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.213:4567/get3/?qp1=2&qp2=0&qp3=1"];
    //The URL where you send the POST
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"GET"];    //Set method to POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"3");
    
    NSHTTPURLResponse* urlResponse = nil; //Response
    NSError *err = nil;  //Allocate error
    
    NSData *responseData3 = [NSURLConnection sendSynchronousRequest:req
                                                  returningResponse:&urlResponse
                                                              error:&err];
    if(!(responseData3 == NULL)){
        NSString *responseString = [[NSString alloc] initWithData:responseData3 encoding:NSASCIIStringEncoding]; //Save the response as string
        NSLog(@"Response: %@", responseString);
        //self.showCode.hidden = NO;
        self.result.hidden = NO;
        self.result.text = responseString;
        
    }
    
}
@end
