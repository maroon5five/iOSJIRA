//
//  JCreateIssueViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/24/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JPickerViewController.h"
#import "JIssueDescriptionViewController.h"
#import "JConstants.h"
#import "JStringFormatUtility.h"

@interface JCreateIssueViewController : UIViewController
@property(nonatomic) JProject *project;

@property (weak, nonatomic) IBOutlet UITextField *titleEditText;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UIButton *issueTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *storyPointsEditText;
@property (weak, nonatomic) IBOutlet UITextView *errorTextView;

- (IBAction)goToDescriptionPage:(UIButton *)sender;
-(JIssue *)createIssueWithFieldsFromPage;

@end
