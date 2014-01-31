//
//  JMoveIssueControllerViewController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/29/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JMoveIssueControllerViewController.h"

@interface JMoveIssueControllerViewController (){
    NSMutableArray *availableMovements;
}

@end

@implementation JMoveIssueControllerViewController
@synthesize issue;
@synthesize authValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    availableMovements = [[NSMutableArray alloc] init];
	_issueStatusTable.delegate = self;
    _issueStatusTable.dataSource = self;
    [self getAllAvailableTransitions];
}

-(void)getAllAvailableTransitions
{
    NSString *urlString = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@/transitions", issue.issueId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //parse data here
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(json){
            NSArray *availableTransitions = [json objectForKey:@"transitions"];
            [self handleResponseWithAllTransitions:availableTransitions];
            //return to main thread and reload data
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.issueStatusTable reloadData];
            });
        }
    }];
}

-(void)handleResponseWithAllTransitions:(NSArray *)availableTransitions
{
    for (NSDictionary *transition in availableTransitions) {
        NSArray *transitionValues = [[NSArray alloc] initWithObjects:[transition objectForKey:@"id"], [transition objectForKey:@"name"], nil];
        [availableMovements addObject:transitionValues];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = [NSString stringWithFormat:@"https://catalystit.atlassian.net/rest/api/2/issue/%@/transitions", issue.issueId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    NSString *jsonBodyString = [NSString stringWithFormat:@"{\"update\": {}, \"fields\": {}, \"transition\": {\"id\": \"%@\" } }", availableMovements[indexPath.row][0]];
    [request setHTTPBody: [jsonBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //parse data here
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(json){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self returnToEditPage];
            });
        }
    }];
}

-(void)returnToEditPage
{
    UINavigationController *navController = self.navigationController;
    NSArray *navViewControllers = [navController viewControllers];
    JEditIssueViewController *issueEditViewController = navViewControllers[navViewControllers.count-2];
    [navController popToViewController:issueEditViewController animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (availableMovements != nil) {
        return availableMovements.count;
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSString *transitionTitle = availableMovements[indexPath.row][1];
    cell.textLabel.text = transitionTitle;
    return cell;
}

@end
