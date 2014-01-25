//
//  JEncodeStringBase64.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/22/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JEncodeStringBase64.h"

@implementation JEncodeStringBase64
+(NSString *)encodeStringBase64:(NSString *)stringToEncode
{
    NSData *plainData = [stringToEncode dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}
@end
