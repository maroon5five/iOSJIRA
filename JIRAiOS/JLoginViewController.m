//
//  JLoginViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/22/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JLoginViewController.h"

@interface JLoginViewController ()

@end

@implementation JLoginViewController

/**
 * Called when the user presses the login button
 */
- (IBAction)login:(id)sender {
    NSString *username = _usernameTextView.text;
    NSString *password = _passwordTextView.text;
    
    //HTTP request to JIRA for login
    NSURL *url = [NSURL URLWithString:@"https://catalystit.atlassian.net/rest/auth/latest/session/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:@"POST"];
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    _authValue = [NSString stringWithFormat:@"Basic %@", [JEncodeStringBase64 encodeStringBase64:basicAuthCredentials]];
    [request setValue:_authValue forHTTPHeaderField:@"Authorization"];
    NSString *jsonString = [NSString stringWithFormat:@"{\"username\" : \"%@\", \"password\" : \"%@\"}", username, password];
    [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
       //Handle the response
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self handleLoginResponse:json];
        });
    }];
}

/**
 * Handles the response from the attempted login
 */
-(void)handleLoginResponse:(NSDictionary *)loginResponseData
{
    if([[loginResponseData objectForKey:@"loginInfo"] objectForKey:@"previousLoginTime"]){
        [self  performSegueWithIdentifier:@"loginSuccess" sender:self];
    } else {
        [_errorTextView setHidden:false];
        _errorTextView.text = @"Login Failed, Try Again";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loginSuccess"]){
        JProjectListController *projectListController = segue.destinationViewController;
        projectListController.authValue = _authValue;
    }
}

/*
 * Hides the keyboard when the user touches somewhere outside of the keyboard
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:TRUE];
}


@end
