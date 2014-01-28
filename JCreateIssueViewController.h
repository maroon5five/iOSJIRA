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

static const int PRIORITY_PICKER_VIEW = 0;
static const int ISSUE_TYPE_PICKER = 1;

@interface JCreateIssueViewController : UIViewController
@property(nonatomic) NSString *authValue;
@property(nonatomic) JProject *project;

@property (weak, nonatomic) IBOutlet UITextField *titleEditText;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UIButton *issueTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *storyPointsEditText;

-(JIssue *)createIssueWithFieldsFromPage;

@end
