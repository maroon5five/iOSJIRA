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

-(void) viewDidLoad
{
    
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [self populateArraysForPickers];
    [_pickerView reloadAllComponents];
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentRowSelected = row;
}

- (IBAction)doneWithPicker:(UIButton *)sender {
    UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
    NSArray *stackOfViewControllers = navigationController.viewControllers;
    JIssueTabBarController *issueTabBarController = (JIssueTabBarController *)stackOfViewControllers[stackOfViewControllers.count - 1];
    JCreateIssueViewController *presentingViewController = [issueTabBarController.viewControllers objectAtIndex:1];
    if(pickerToDisplay == PRIORITY_PICKER_VIEW){
        [presentingViewController.priorityButton setTitle:_priorityOptions[currentRowSelected] forState:UIControlStateNormal];
    } else if(pickerToDisplay == ISSUE_TYPE_PICKER){
        [presentingViewController.issueTypeButton setTitle:_issueTypeOptions[currentRowSelected] forState:UIControlStateNormal];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
