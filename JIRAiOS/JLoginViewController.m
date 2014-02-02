//
//  JLoginViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/22/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JLoginViewController.h"

@interface JLoginViewController (){
    JNetworkUtility *networkUtility;
}

@end

@implementation JLoginViewController

/**
 * Called when the user presses the login button
 */
- (IBAction)login:(id)sender {
    _errorTextView.text = @"";
    networkUtility = [JNetworkUtility getNetworkUtility];
    NSString *username = _usernameTextView.text;
    NSString *password = _passwordTextView.text;
    [self.activityIndicatorView startAnimating];
    [networkUtility setUpAuthenticationValueWithUsername:username Password:password];
    //HTTP request to JIRA for login
    NSString *httpBody = [NSString stringWithFormat:@"{\"username\" : \"%@\", \"password\" : \"%@\"}", username, password];
    NSMutableURLRequest *request = [networkUtility createRequestWithURL: @"https://catalystit.atlassian.net/rest/auth/latest/session/" HTTPMethod:POST HTTPBody:httpBody];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
       //Handle the response
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.activityIndicatorView stopAnimating];
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
        networkUtility.currentUser = _usernameTextView.text;
        _usernameTextView.text = @"";
        _passwordTextView.text = @"";
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
