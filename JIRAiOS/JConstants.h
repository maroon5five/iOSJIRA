//
//  JConstants.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/28/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int PRODUCT_BACKLOG = 0;
static const int SPRINT_BACKLOG = 1;
static const int WORK_IN_PROGRESS = 2;
static const int TEAM_REVIEW = 3;
static const int QA_REVIEW = 4;
static const int DEMO_READY = 5;
static const int DONE_DONE = 6;

static const int CREATE_ISSUE = 0;
static const int EDIT_ISSUE = 1;

static const int PRIORITY_PICKER_VIEW = 0;
static const int ISSUE_TYPE_PICKER = 1;

@interface JConstants : NSObject

@end
