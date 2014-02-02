//
//  JIssueDescriptionViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/27/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIssue.h"
#import "JProject.h"
#import "JConstants.h"
#import "JStringFormatUtility.h"
#import "JIssueListController.h"
#import "JNetworkUtility.h"

@interface JIssueDescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *descriptionEditText;

@property(nonatomic) JProject *project;
@property(nonatomic) JIssue *issue;
@property(nonatomic) int callingController;

-(void)setUpDescriptionEditTextStyle;

-(IBAction)submitIssue:(UIButton *)sender;
-(void)persistNewIssue;
-(void)updateIssue;
@end
