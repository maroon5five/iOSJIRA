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

@interface JIssueDescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *descriptionEditText;

@property(nonatomic) JProject *project;
@property(nonatomic) JIssue *issue;
@property(nonatomic) NSString *authValue;

-(void)setUpDescriptionEditTextStyle;

- (IBAction)submitIssue:(UIButton *)sender;
@end
