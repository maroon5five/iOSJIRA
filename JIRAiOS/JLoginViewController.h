//
//  JLoginViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/22/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JEncodeStringBase64.h"
#import "JProjectListController.h"
#import "JNetworkUtility.h"
#import "JConstants.h"

@interface JLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
@property (weak, nonatomic) IBOutlet UILabel *errorTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
-(IBAction)login:(id)sender;
-(void)handleLoginResponse:(NSDictionary *)loginResponseData;

@end
