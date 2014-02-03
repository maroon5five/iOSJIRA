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
#import "JEditIssueViewController.h"
#import "JConstants.h"
#import "JNetworkUtility.h"
#import "JActivityIndicatorUtility.h"


@interface JIssueListController : UITableViewController
@property(nonatomic) JProject *project;
@property(nonatomic) NSArray *issues;
@property(nonatomic) bool reloadData;

- (void)initializeArrays;
- (void)buildIssueAndStoreItInTheProperArray:(NSDictionary *)jsonIssue;
- (void)handleResponseWithAllIssuesForProject:(NSArray *)jsonIssues;
- (void)getAllIssuesForProject;

@end
