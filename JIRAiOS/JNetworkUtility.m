//
//  JNetworkUtility.m
//  JIRAiOS
//
//  Created by New User on 2/1/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JNetworkUtility.h"

@implementation JNetworkUtility
@synthesize authValue;
@synthesize currentUser;

static JNetworkUtility *instance;

+(JNetworkUtility *) getNetworkUtility
{
    if(instance == nil){
        instance = [[JNetworkUtility alloc]init];
    }
    return instance;
}

-(NSMutableURLRequest *)createRequestWithURL:(NSString *)url HTTPMethod:(NSString *)httpMethod HTTPBody:(NSString *)httpBody
{
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:httpMethod];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody: [httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

-(NSMutableURLRequest *)createRequestWithURL:(NSString *)url HTTPMethod:(NSString *)httpMethod
{
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type" ];
    [request setHTTPMethod:httpMethod];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    return request;
}

-(void)setUpAuthenticationValueWithUsername:(NSString *)username Password:(NSString *)password
{
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    authValue = [NSString stringWithFormat:@"Basic %@", [JEncodeStringBase64 encodeStringBase64:basicAuthCredentials]];
}

@end
