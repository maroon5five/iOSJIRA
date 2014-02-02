//
//  JNetworkUtility.h
//  JIRAiOS
//
//  Created by New User on 2/1/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JEncodeStringBase64.h"

@interface JNetworkUtility : NSObject

@property(nonatomic) NSString *authValue;
@property(nonatomic) NSString *currentUser;

+(JNetworkUtility *) getNetworkUtility;

-(void)setUpAuthenticationValueWithUsername:(NSString *)username Password:(NSString *)password;
-(NSMutableURLRequest *) createRequestWithURL:(NSString *)url HTTPMethod:(NSString *)httpMethod HTTPBody:(NSString *)httpBody;
-(NSMutableURLRequest *) createRequestWithURL:(NSString *)url HTTPMethod:(NSString *)httpMethod;

@end
