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

@interface JProjectListController : UITableViewController
@property(nonatomic) NSString *authValue;
@property(nonatomic) NSMutableArray *projects;
@property(nonatomic) JProject *selectedProject;

@end
