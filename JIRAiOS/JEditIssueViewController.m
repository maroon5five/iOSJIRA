//
//  JEditIssueViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/28/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JEditIssueViewController.h"

@interface JEditIssueViewController (){
    JStringFormatUtility *stringFormatUtility;
    JNetworkUtility *networkUtility;
}

@end

@implementation JEditIssueViewController
@synthesize issue;
@synthesize project;

-(void)viewDidLoad
{
    stringFormatUtility = [[JStringFormatUtility alloc]init];
    networkUtility = [JNetworkUtility getNetworkUtility];
    [self populateFields];
    [super viewDidLoad];
}

-(void)populateFields
{
    _titleEditText.text = issue.issueTitle;
    [_priorityButton setTitle:issue.issuePriority forState:UIControlStateNormal];
    [_issueTypeButton setTitle:issue.issueType forState:UIControlStateNormal];
    if([_storyPointsEditText.text intValue]){
        _storyPointsEditText.text = issue.issueStoryPoints;
    } else {
        _storyPointsEditText.text = @"0";
    }
    if(issue.issueAssignee != nil){
        _assigneeTextView.text = issue.issueAssignee;
    } else {
        _assigneeTextView.text = @"Unassigned";
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectPriority"]){
        JPickerViewController *pickerController = segue.destinationViewController;
        pickerController.pickerToDisplay = PRIORITY_PICKER_VIEW;
        pickerController.callingController = EDIT_ISSUE;
        pickerController.defaultPickerValue = _priorityButton.titleLabel.text;
    } else if([segue.identifier isEqualToString:@"selectIssueType"]){
        JPickerViewController *pickerController = segue.destinationViewController;
        pickerController.pickerToDisplay = ISSUE_TYPE_PICKER;
        pickerController.callingController = EDIT_ISSUE;
        pickerController.defaultPickerValue = _issueTypeButton.titleLabel.text;
    } else if([segue.identifier isEqualToString:@"nextPage"]){
        JIssueDescriptionViewController *descriptionViewController = segue.destinationViewController;
        [self createIssueWithFieldsFromPage];
        descriptionViewController.issue = issue;
        descriptionViewController.project = project;
        descriptionViewController.callingController = EDIT_ISSUE;
    } else if([segue.identifier isEqualToString:@"moveIssue"]){
        JMoveIssueControllerViewController *moveIssueController = segue.destinationViewController;
        moveIssueController.issue = issue;
    }
}

-(void)createIssueWithFieldsFromPage
{
    issue.issueTitle = [stringFormatUtility addEscapeScharactersToString:_titleEditText.text];
    if (![_priorityButton.titleLabel.text isEqualToString:@"Select Priority"]) {
        issue.issuePriority = _priorityButton.titleLabel.text;
    }
    if (![_issueTypeButton.titleLabel.text isEqualToString:@"Select Issue Type"]) {
        issue.issueType = _issueTypeButton.titleLabel.text;
    }
    if([_storyPointsEditText.text intValue]){
        issue.issueStoryPoints = _storyPointsEditText.text;
    } else {
        issue.issueStoryPoints = @"0";
    }
}


- (IBAction)goToDescriptionPage:(UIButton *)sender {
    bool goodToGoToNextPage = true;
    _errorTextView.text = @"";
    if(_titleEditText.text.length == 0){
        goodToGoToNextPage = false;
        _errorTextView.text = [_errorTextView.text stringByAppendingString:@"Don't forget to add a Title\n"];
    }
    if([_priorityButton.titleLabel.text isEqualToString:@"Select Priority"]){
        goodToGoToNextPage = false;
        _errorTextView.text = [_errorTextView.text stringByAppendingString:@"Don't forget to select a Priority\n"];
    }
    if([_issueTypeButton.titleLabel.text isEqualToString:@"Select Issue Type"]){
        goodToGoToNextPage = false;
        _errorTextView.text = [_errorTextView.text stringByAppendingString:@"Don't forget to select an Issue Type\n"];
    }
    if(goodToGoToNextPage){
        [self performSegueWithIdentifier:@"nextPage" sender:self];
    }
}

- (IBAction)deleteIssue:(UIButton *)sender {
    UIActionSheet *deleteConfirmation = [[UIActionSheet alloc] initWithTitle:@"Delete Issue?" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"YES" otherButtonTitles: nil];
    [deleteConfirmation showInView:self.view];
}

- (IBAction)assignIssueToMe:(UIButton *)sender {
    [JActivityIndicatorUtility startActivityIndicatorInView:self.navigationController.view];
    NSString *url = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@/assignee", issue.issueId];
    NSString *httpBody = [NSString stringWithFormat:@"{\"name\": \"%@\"}", networkUtility.currentUser];
    NSMutableURLRequest *request = [networkUtility createRequestWithURL:url HTTPMethod:PUT HTTPBody:httpBody];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self requestIssue];
            UINavigationController *navController = self.navigationController;
            NSArray *navViewControllers = [navController viewControllers];
            UITabBarController *issueTabBarController = navViewControllers[navViewControllers.count-2];
            JIssueListController *issueListController = [issueTabBarController.viewControllers objectAtIndex:0];
            issueListController.reloadData = true;

        });
    }];
}

-(void)requestIssue
{
    NSString *url = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@", issue.issueId];
    NSMutableURLRequest *request = [networkUtility createRequestWithURL:url HTTPMethod:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSString *assignee = [[[json objectForKey:@"fields"]objectForKey:@"assignee"] objectForKey:@"displayName"];
        //Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [JActivityIndicatorUtility stopActivityIndicator];
            _assigneeTextView.text = assignee;
        });
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [JActivityIndicatorUtility startActivityIndicatorInView:self.navigationController.view];
        NSString *url = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@", issue.issueId];
        NSMutableURLRequest *request = [networkUtility createRequestWithURL:url HTTPMethod:DELETE];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            //Return to main thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [JActivityIndicatorUtility stopActivityIndicator];
                UINavigationController *navController = self.navigationController;
                NSArray *navViewControllers = [navController viewControllers];
                UITabBarController *issueTabBarController = navViewControllers[navViewControllers.count-2];
                JIssueListController *issueListController = [issueTabBarController.viewControllers objectAtIndex:0];
                issueListController.reloadData = true;
                [navController popToViewController:issueTabBarController animated:YES];
            });
        }];
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
