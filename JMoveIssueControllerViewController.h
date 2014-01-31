//
//  JMoveIssueControllerViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/29/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIssue.h"
#import "JEditIssueViewController.h"

@interface JMoveIssueControllerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) JIssue *issue;
@property(nonatomic) NSString *authValue;

@property (weak, nonatomic) IBOutlet UITableView *issueStatusTable;

-(void)getAllAvailableTransitions;
-(void)handleResponseWithAllTransitions:(NSArray *)availableTransitions;
-(void)returnToEditPage;

@end
