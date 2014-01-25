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

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setUpDescriptionEditTextStyle];
    [self setUpPickers];
    [self populateArraysForPickers];
}

-(void)populateArraysForPickers
{
    //_priorityOptions = [NSArray alloc] initWithObjects:<#(id), ...#>, nil
}

-(void)setUpPickers
{
    _issueTypePicker = [[UIPickerView alloc] init];
    CGSize pickerSize = [_issueTypePicker sizeThatFits:CGSizeZero];
    _issueTypePicker.frame = CGRectMake(0.0, 250, pickerSize.width, 460);
    _issueTypePicker.backgroundColor = [UIColor whiteColor];
    _issueTypePicker.tag = ISSUE_TYPE_PICKER;
    [_issueTypePicker setDelegate:self];
    
    _priorityPicker = [[UIPickerView alloc] init];
    _priorityPicker.frame = CGRectMake(0.0, 250, pickerSize.width, 460);
    _priorityPicker.backgroundColor = [UIColor whiteColor];
    _priorityPicker.tag = PRIORITY_PICKER_VIEW;
    [_priorityPicker setDelegate:self];
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
    int numberOfOptions = 0;
    if (pickerView.tag == PRIORITY_PICKER_VIEW) {
        numberOfOptions = 6;
    } else if (pickerView.tag == ISSUE_TYPE_PICKER){
        numberOfOptions = 4;
    }
    return numberOfOptions;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int numberOfOptions = 0;
    if (pickerView.tag == PRIORITY_PICKER_VIEW) {
        numberOfOptions = 6;
    } else if (pickerView.tag == ISSUE_TYPE_PICKER){
        numberOfOptions = 4;
    }
    return nil;
}

- (void)setUpDescriptionEditTextStyle
{
    [_descriptionEditText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_descriptionEditText.layer setBorderWidth:1.0];
    _descriptionEditText.layer.cornerRadius = 5;
    _descriptionEditText.clipsToBounds = YES;
}

/*
 * Hides the keyboard when the user touches somewhere outside of the keyboard
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:TRUE];
}


@end
