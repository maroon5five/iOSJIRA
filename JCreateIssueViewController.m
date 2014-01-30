//
//  JCreateIssueViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/24/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JCreateIssueViewController.h"

@interface JCreateIssueViewController (){
    JStringFormatUtility *stringFormatUtility;
}

@end

@implementation JCreateIssueViewController
@synthesize authValue;
@synthesize project;

-(void)viewDidLoad
{
    stringFormatUtility = [[JStringFormatUtility alloc]init];
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectPriority"]){
        JPickerViewController *pickerController = segue.destinationViewController;
        pickerController.pickerToDisplay = PRIORITY_PICKER_VIEW;
        pickerController.callingController = CREATE_ISSUE;
        pickerController.defaultPickerValue = _priorityButton.titleLabel.text;
    } else if([segue.identifier isEqualToString:@"selectIssueType"]){
        JPickerViewController *pickerController = segue.destinationViewController;
        pickerController.pickerToDisplay = ISSUE_TYPE_PICKER;
        pickerController.callingController = CREATE_ISSUE;
        pickerController.defaultPickerValue = _issueTypeButton.titleLabel.text;
    } else if([segue.identifier isEqualToString:@"nextPage"]){
        JIssueDescriptionViewController *descriptionViewController = segue.destinationViewController;
        JIssue *issue = [self createIssueWithFieldsFromPage];
        descriptionViewController.issue = issue;
        descriptionViewController.authValue = authValue;
        descriptionViewController.project = project;
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

-(JIssue *)createIssueWithFieldsFromPage
{
    JIssue *issue = [[JIssue alloc] init];
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
