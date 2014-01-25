//
//  JCreateIssueViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/24/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static const int PRIORITY_PICKER_VIEW = 0;
static const int ISSUE_TYPE_PICKER = 1;

@interface JCreateIssueViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic) NSString *authValue;

@property (weak, nonatomic) IBOutlet UITextView *descriptionEditText;
@property (weak, nonatomic) IBOutlet UITextField *titleEditText;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UIButton *issueTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *storyPointsEditText;

@property(nonatomic) UIPickerView *priorityPicker;
@property(nonatomic) UIPickerView *issueTypePicker;
@property(nonatomic) NSArray *priorityOptions;
@property(nonatomic) NSArray *issueStatusOptions;

-(void)setUpPickers;
-(void)setUpDescriptionEditTextStyle;
-(void)populateArraysForPickers;

@end
