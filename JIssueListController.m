//
//  JIssueListController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/23/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JIssueListController.h"

@interface JIssueListController (){
    NSMutableArray *productBacklogIssues;
    NSMutableArray *sprintBacklogIssues;
    NSMutableArray *workInProgressIssues;
    NSMutableArray *qaReadyIssues;
    NSMutableArray *qualityAssuranceIssues;
    NSMutableArray *demoReadyIssues;
    NSMutableArray *doneDoneIssues;
}

@end

@implementation JIssueListController
@synthesize authValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeArrays];
    [self getAllIssuesForProject];
}

- (void)initializeArrays
{
    productBacklogIssues = [[NSMutableArray alloc] init];
    sprintBacklogIssues = [[NSMutableArray alloc] init];
    workInProgressIssues = [[NSMutableArray alloc] init];
    qaReadyIssues = [[NSMutableArray alloc] init];
    qualityAssuranceIssues = [[NSMutableArray alloc] init];
    demoReadyIssues = [[NSMutableArray alloc] init];
    doneDoneIssues = [[NSMutableArray alloc] init];
}

- (void)buildIssueAndStoreItInTheProperArray:(NSDictionary *)jsonIssue
{
    JIssue *issue = [[JIssue alloc] init];
    issue.issueId = [jsonIssue objectForKey:@"id"];
    issue.issueKey = [jsonIssue objectForKey:@"key"];
    NSDictionary *jsonIssueFields = [jsonIssue objectForKey:@"fields"];
    issue.issueTitle = [jsonIssueFields objectForKey:@"summary"];
    issue.issueDescription = [jsonIssueFields objectForKey:@"description"];
    issue.issuePriority = [[jsonIssueFields objectForKey:@"priority"] objectForKey:@"name"];
    issue.issueCreator = [[jsonIssueFields objectForKey:@"creator"] objectForKey:@"displayName"];
    if([jsonIssueFields objectForKey:@"assignee"] != [NSNull null]){
        issue.issueAssignee = [[jsonIssueFields objectForKey:@"assignee"] objectForKey:@"displayName"];
    }
    if([jsonIssueFields objectForKey:@"customfield_10004"] != [NSNull null]){
        issue.issueStoryPoints = [jsonIssueFields objectForKey:@"customfield_10004"];
    }
    issue.issueType = [[jsonIssueFields objectForKey:@"issuetype"] objectForKey:@"name"];
    NSString *issueStatusString = [[jsonIssueFields objectForKey:@"status"] objectForKey:@"name"];
    issue.issueStatus = issueStatusString;
    if ([issueStatusString isEqualToString:@"Product Backlog"]) {
        [productBacklogIssues addObject:issue];
    } else if ([issueStatusString isEqualToString:@"Sprint Backlog"]) {
        [sprintBacklogIssues addObject:issue];
    } else if ([issueStatusString isEqualToString:@"WIP"]) {
        [workInProgressIssues addObject:issue];
    } else if ([issueStatusString isEqualToString:@"QA Ready"]) {
        [qaReadyIssues addObject:issue];
    } else if ([issueStatusString isEqualToString:@"Quality Assurance"]) {
        [qualityAssuranceIssues addObject:issue];
    } else if ([issueStatusString isEqualToString:@"Demo Ready"]) {
        [demoReadyIssues addObject:issue];
    } else if ([issueStatusString isEqualToString:@"Done Done"]) {
        [doneDoneIssues addObject:issue];
    }
}

- (void)handleResponseWithAllIssuesForProject:(NSArray *)jsonIssues
{
    for (NSDictionary * jsonIssue in jsonIssues) {
        [self buildIssueAndStoreItInTheProperArray:jsonIssue];
    }
    _issues = [[NSArray alloc] initWithObjects:productBacklogIssues, sprintBacklogIssues, workInProgressIssues, qaReadyIssues, qualityAssuranceIssues, demoReadyIssues, doneDoneIssues, nil];
}

- (void)getAllIssuesForProject
{
    NSString *urlString = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/search?jql=project=%@", _project.projectKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //parse data here
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSArray *jsonIssues = [json objectForKey:@"issues"];
        if(json){
            [self handleResponseWithAllIssuesForProject:jsonIssues];
            //return to main thread and reload data
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableView] reloadData];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionIssues = [_issues objectAtIndex:section];
    return sectionIssues.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case PRODUCT_BACKLOG:
            return @"Project Backlog";
        case SPRINT_BACKLOG:
            return @"Sprint Backlog";
        case WORK_IN_PROGRESS:
            return @"Work In Progress";
        case TEAM_REVIEW:
            return @"Team Review";
        case QA_REVIEW:
            return @"QA Review";
        case DEMO_READY:
            return @"Demo Ready";
        case DONE_DONE:
            return @"Done Done";
        default:
            return @"Other";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    JIssue *issue = _issues[indexPath.section][indexPath.row];
    cell.textLabel.text = issue.issueTitle;
    return cell;
}

@end
