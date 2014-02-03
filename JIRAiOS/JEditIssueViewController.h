//
//  JEditIssueViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/28/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIssue.h"
#import "JPickerViewController.h"
#import "JProject.h"
#import "JConstants.h"
#import "JStringFormatUtility.h"
#import "JMoveIssueControllerViewController.h"
#import "JNetworkUtility.h"
#import "JActivityIndicatorUtility.h"

@interface JEditIssueViewController : UIViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleEditText;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UIButton *issueTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *storyPointsEditText;
@property (weak, nonatomic) IBOutlet UITextView *errorTextView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *assigneeTextView;

@property(nonatomic) JIssue *issue;
@property(nonatomic) JProject *project;
- (IBAction)goToDescriptionPage:(UIButton *)sender;
- (IBAction)deleteIssue:(UIButton *)sender;
- (IBAction)assignIssueToMe:(UIButton *)sender;
-(void)populateFields;
-(void)requestIssue;

@end
