//
//  JIssueDescriptionViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/27/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JIssueDescriptionViewController.h"

@interface JIssueDescriptionViewController ()

@end

@implementation JIssueDescriptionViewController
@synthesize issue;
@synthesize authValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpDescriptionEditTextStyle];
}

- (void)setUpDescriptionEditTextStyle
{
    [_descriptionEditText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_descriptionEditText.layer setBorderWidth:1.0];
    _descriptionEditText.layer.cornerRadius = 5;
    _descriptionEditText.clipsToBounds = YES;
}

- (IBAction)submitIssue:(UIButton *)sender {
    issue.issueDescription = _descriptionEditText.text;
    
    //HTTP request to JIRA for login
    NSURL *url = [NSURL URLWithString:@"https://catalystit.atlassian.net/rest/api/2/issue/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:@"POST"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    NSString *jsonString = [NSString stringWithFormat:@"{\"fields\" : {\"project\":{\"key\":\"%@\"}, \"summary\": \"%@\", \"description\":\"%@\", \"issuetype\":{\"name\":\"%@\"}, \"priority\":{\"name\":\"%@\"}}}", _project.projectKey, issue.issueTitle, issue.issueDescription, issue.issueType, issue.issuePriority];
    [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //Handle the response
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSLog(@"%@", json);
        NSLog(@"%@", error);
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
        });
    }];

}

/*
 * Hides the keyboard when the user touches somewhere outside of the keyboard
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:TRUE];
}

@end
