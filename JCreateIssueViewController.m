//
//  JCreateIssueViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/24/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JCreateIssueViewController.h"

@interface JCreateIssueViewController ()

@end

@implementation JCreateIssueViewController
@synthesize authValue;
@synthesize project;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectPriority"]){
        JPickerViewController *pickerController = segue.destinationViewController;
        pickerController.pickerToDisplay = PRIORITY_PICKER_VIEW;
    } else if([segue.identifier isEqualToString:@"selectIssueType"]){
        JPickerViewController *pickerController = segue.destinationViewController;
        pickerController.pickerToDisplay = ISSUE_TYPE_PICKER;
    } else if([segue.identifier isEqualToString:@"nextPage"]){
        JIssueDescriptionViewController *descriptionViewController = segue.destinationViewController;
        JIssue *issue = [self createIssueWithFieldsFromPage];
        descriptionViewController.issue = issue;
        descriptionViewController.authValue = authValue;
        descriptionViewController.project = project;
    }
}

-(JIssue *)createIssueWithFieldsFromPage
{
    JIssue *issue = [[JIssue alloc] init];
    issue.issueTitle = _titleEditText.text;
    if (![_priorityButton.titleLabel.text isEqualToString:@"Select Priority"]) {
        issue.issuePriority = _priorityButton.titleLabel.text;
    }
    if (![_issueTypeButton.titleLabel.text isEqualToString:@"Select Issue Type"]) {
        issue.issueType = _issueTypeButton.titleLabel.text;
    }
    if([_storyPointsEditText.text intValue]){
        issue.issueStoryPoints = _storyPointsEditText.text;
    }
    return issue;
}

/*
 * Hides the keyboard when the user touches somewhere outside of the keyboard
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:TRUE];
}


@end
