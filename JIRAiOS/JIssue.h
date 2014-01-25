//
//  JIssue.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/23/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JIssue : NSObject

@property(nonatomic) NSString *issueId;
@property(nonatomic) NSString *issueKey;
@property(nonatomic) NSString *issueTitle;
@property(nonatomic) NSString *issueDescription;
@property(nonatomic) NSString *issueStatus;
@property(nonatomic) NSString *issuePriority;
@property(nonatomic) NSString *issueCreator;
@property(nonatomic) NSString *issueAssignee;
@property(nonatomic) NSString *issueType;
@property(nonatomic) NSString *issueStoryPoints;

@end
