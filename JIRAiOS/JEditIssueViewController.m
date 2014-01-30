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
}

@end

@implementation JEditIssueViewController
@synthesize issue;
@synthesize authValue;
@synthesize project;

-(void)viewDidLoad
{
    stringFormatUtility = [[JStringFormatUtility alloc]init];
    [self populateFields];
    [super viewDidLoad];
}

-(void)populateFields
{
    _titleEditText.text = issue.issueTitle;
    [_priorityButton setTitle:issue.issuePriority forState:UIControlStateNormal];
    [_issueTypeButton setTitle:issue.issueType forState:UIControlStateNormal];
    _storyPointsEditText.text = [NSString stringWithFormat:@"%@", issue.issueStoryPoints];
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
        descriptionViewController.authValue = authValue;
        descriptionViewController.project = project;
        descriptionViewController.callingController = EDIT_ISSUE;
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        NSString *updateJsonString = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@", issue.issueId];
        NSURL *url = [NSURL URLWithString:updateJsonString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            //Return to main thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UINavigationController *navController = self.navigationController;
                NSArray *navViewControllers = [navController viewControllers];
                UITabBarController *issueTabBarController = navViewControllers[navViewControllers.count-2];
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
