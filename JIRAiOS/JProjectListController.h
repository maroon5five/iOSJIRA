//
//  JProjectListController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/22/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JProject.h"
#import "JIssueTabBarController.h"
#import "JIssueListController.h"
#import "JCreateIssueViewController.h"

@interface JProjectListController : UITableViewController
@property(nonatomic) NSString *authValue;
@property(nonatomic) NSString *username;
@property(nonatomic) NSMutableArray *projects;
@property(nonatomic) JProject *selectedProject;

-(void)getAllProjects;

@end
