//
//  JIssueListController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/23/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JProject.h"
#import "JIssue.h"

static const int PRODUCT_BACKLOG = 0;
static const int SPRINT_BACKLOG = 1;
static const int WORK_IN_PROGRESS = 2;
static const int TEAM_REVIEW = 3;
static const int QA_REVIEW = 4;
static const int DEMO_READY = 5;
static const int DONE_DONE = 6;

@interface JIssueListController : UITableViewController
@property(nonatomic) NSString *authValue;
@property(nonatomic) JProject *project;
@property(nonatomic) NSArray *issues;

- (void)initializeArrays;
- (void)buildIssueAndStoreItInTheProperArray:(NSDictionary *)jsonIssue;
- (void)handleResponseWithAllIssuesForProject:(NSArray *)jsonIssues;
- (void)getAllIssuesForProject;

@end
