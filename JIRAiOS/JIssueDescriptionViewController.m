//
//  JIssueDescriptionViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/27/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JIssueDescriptionViewController.h"

@interface JIssueDescriptionViewController (){
    JStringFormatUtility *stringFormatUtility;
    JNetworkUtility *networkUtility;
}

@end

@implementation JIssueDescriptionViewController
@synthesize issue;
@synthesize callingController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    networkUtility = [JNetworkUtility getNetworkUtility];
    stringFormatUtility = [[JStringFormatUtility alloc] init];
    [self setUpDescriptionEditTextStyle];
    if(callingController == EDIT_ISSUE){
        _descriptionEditText.text = issue.issueDescription;
    }
}

- (void)setUpDescriptionEditTextStyle
{
    [_descriptionEditText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_descriptionEditText.layer setBorderWidth:1.0];
    _descriptionEditText.layer.cornerRadius = 5;
    _descriptionEditText.contentInset = UIEdgeInsetsMake(-60.0, 0.0, 0.0, 0.0);
}

- (IBAction)submitIssue:(UIButton *)sender {
    NSString *descriptionText = _descriptionEditText.text;
    issue.issueDescription = [stringFormatUtility addEscapeScharactersToString:descriptionText];
    
    if(callingController == EDIT_ISSUE){
        [self updateIssue];
    } else {
        [self persistNewIssue];
    }
}

-(void)persistNewIssue
{
    [JActivityIndicatorUtility startActivityIndicatorInView:self.navigationController.view];
    NSString *httpBody = [NSString stringWithFormat:@"{\"fields\" : {\"project\":{\"key\":\"%@\"}, \"summary\": \"%@\", \"description\":\"%@\", \"issuetype\":{\"name\":\"%@\"}, \"priority\":{\"name\":\"%@\"}}}", _project.projectKey, issue.issueTitle, issue.issueDescription, issue.issueType, issue.issuePriority];
    NSMutableURLRequest *request = [networkUtility createRequestWithURL:@"https://catalystit.atlassian.net/rest/api/2/issue/" HTTPMethod:POST HTTPBody:httpBody];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [JActivityIndicatorUtility stopActivityIndicator];
            UINavigationController *navController = self.navigationController;
            NSArray *navViewControllers = [navController viewControllers];
            UITabBarController *issueTabBarController = navViewControllers[navViewControllers.count-2];
            JCreateIssueViewController *createIssueController = [issueTabBarController.viewControllers objectAtIndex:1];
            createIssueController.titleEditText.text = @"";
            createIssueController.storyPointsEditText.text = @"";
            [createIssueController.priorityButton setTitle:@"Select Priority" forState:UIControlStateNormal];
            [createIssueController.issueTypeButton setTitle:@"Select Issue Type" forState:UIControlStateNormal];
            JIssueListController *issueListController = [issueTabBarController.viewControllers objectAtIndex:0];
            issueListController.reloadData = true;
            [navController popToViewController:issueTabBarController animated:YES];
        });
    }];
}

-(void)updateIssue
{
    [JActivityIndicatorUtility startActivityIndicatorInView:self.navigationController.view];
    NSString *url = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@", issue.issueId];
    NSString *httpBody = [NSString stringWithFormat:@"{\"fields\" : {\"project\":{\"key\":\"%@\"}, \"summary\": \"%@\", \"description\":\"%@\", \"issuetype\":{\"name\":\"%@\"}, \"priority\":{\"name\":\"%@\"}, \"customfield_10004\":%@}}", _project.projectKey, issue.issueTitle, issue.issueDescription, issue.issueType, issue.issuePriority, issue.issueStoryPoints];
    NSMutableURLRequest *request = [networkUtility createRequestWithURL:url HTTPMethod:PUT HTTPBody:httpBody];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [JActivityIndicatorUtility stopActivityIndicator];
            UINavigationController *navController = self.navigationController;
            NSArray *navViewControllers = [navController viewControllers];
            UITabBarController *issueTabBarController = navViewControllers[navViewControllers.count-3];
            JIssueListController *issueListController = [issueTabBarController.viewControllers objectAtIndex:0];
            issueListController.reloadData = true;
            [navController popToViewController:issueTabBarController animated:YES];
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
