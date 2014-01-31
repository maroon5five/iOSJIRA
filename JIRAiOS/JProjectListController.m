//
//  JProjectListController.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/22/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JProjectListController.h"

@interface JProjectListController ()

@end

@implementation JProjectListController
@synthesize authValue;
@synthesize username;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _projects = [[NSMutableArray alloc] init];
    [self getAllProjects];
}

-(void)getAllProjects
{
    NSURL *url = [NSURL URLWithString:@"https://catalystit.atlassian.net/rest/api/2/project"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        //parse data here
        NSError *jsonError;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(json){
            for (NSDictionary * jsonProject in json) {
                JProject *project = [[JProject alloc] init];
                project.projectID = [jsonProject objectForKey:@"id"];
                project.projectName = [jsonProject objectForKey:@"name"];
                project.projectKey = [jsonProject objectForKey:@"key"];
                [_projects addObject:project];
            }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    JProject *project = _projects[indexPath.row];
    cell.textLabel.text = [project projectName];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedProject = [_projects objectAtIndex:indexPath.row];
    [self  performSegueWithIdentifier:@"projectSelected" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"projectSelected"]){
        JIssueTabBarController *issueTabBarController = segue.destinationViewController;
        JIssueListController *issueListController = [issueTabBarController.viewControllers objectAtIndex:0];
        issueListController.authValue = authValue;
        issueListController.project = _selectedProject;
        issueListController.username = username;
        
        JCreateIssueViewController *createIssueController = [issueTabBarController.viewControllers objectAtIndex:1];
        createIssueController.authValue = authValue;
        createIssueController.project = _selectedProject;
    }
}

@end
