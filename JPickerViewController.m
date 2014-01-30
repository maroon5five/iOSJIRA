//
//  JPickerViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/27/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JPickerViewController.h"

@interface JPickerViewController (){
    int currentRowSelected;
}

@end

@implementation JPickerViewController
@synthesize pickerToDisplay;
@synthesize callingController;
@synthesize defaultPickerValue;

-(void) viewDidLoad
{
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [self populateArraysForPickers];
    [_pickerView reloadAllComponents];
    [self.pickerView selectRow:[self getRowOfDefaultValue] inComponent:0 animated:NO];
}

-(NSInteger)getRowOfDefaultValue
{
    NSInteger returnValue = 0;
    if (pickerToDisplay == PRIORITY_PICKER_VIEW) {
        returnValue = (NSInteger)[_priorityOptions indexOfObject:defaultPickerValue];
    } else if(pickerToDisplay == ISSUE_TYPE_PICKER){
        returnValue = (NSInteger)[_issueTypeOptions indexOfObject:defaultPickerValue];
    }
    if (returnValue < 7) {
        return returnValue;
    } else {
        return 0;
    }
}

-(void)populateArraysForPickers
{
    if (pickerToDisplay ==  PRIORITY_PICKER_VIEW) {
        _priorityOptions = [[NSArray alloc] initWithObjects:@"Unprioritized", @"Blocker", @"Critical", @"Major", @"Minor", @"Trivial", @"Enhancement", nil];
    } else if (pickerToDisplay == ISSUE_TYPE_PICKER){
        _issueTypeOptions = [[NSArray alloc] initWithObjects:@"Story", @"Task", @"Epic", @"Bug", @"Research task", @"Improvement", @"New Feature", nil];
    }
}

/**
 * Number of columns in picker
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**
 * Number of rows in picker
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 7;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerToDisplay == PRIORITY_PICKER_VIEW) {
        return _priorityOptions[row];
    } else if (pickerToDisplay == ISSUE_TYPE_PICKER){
        return _issueTypeOptions[row];
    }else{
        return nil;
    }
}

- (IBAction)doneWithPicker:(UIButton *)sender {
    UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
    NSArray *stackOfViewControllers = navigationController.viewControllers;
    currentRowSelected = [_pickerView selectedRowInComponent:0];
    if (callingController == CREATE_ISSUE) {
        JIssueTabBarController *issueTabBarController = (JIssueTabBarController *)stackOfViewControllers[stackOfViewControllers.count - 1];
        JCreateIssueViewController *presentingViewController = [issueTabBarController.viewControllers objectAtIndex:1];
        if(pickerToDisplay == PRIORITY_PICKER_VIEW){
            [presentingViewController.priorityButton setTitle:_priorityOptions[currentRowSelected] forState:UIControlStateNormal];
        } else if(pickerToDisplay == ISSUE_TYPE_PICKER){
            [presentingViewController.issueTypeButton setTitle:_issueTypeOptions[currentRowSelected] forState:UIControlStateNormal];
        }
    } else if (callingController == EDIT_ISSUE){
        JEditIssueViewController *presentingViewController = (JEditIssueViewController *)stackOfViewControllers[stackOfViewControllers.count - 1];
        if(pickerToDisplay == PRIORITY_PICKER_VIEW){
            [presentingViewController.priorityButton setTitle:_priorityOptions[currentRowSelected] forState:UIControlStateNormal];
        } else if(pickerToDisplay == ISSUE_TYPE_PICKER){
            [presentingViewController.issueTypeButton setTitle:_issueTypeOptions[currentRowSelected] forState:UIControlStateNormal];
        }
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
