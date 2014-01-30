//
//  JStringFormatUtility.m
//  JIRAiOS
//
//  Created by Randy Miller on 1/29/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JStringFormatUtility.h"

@implementation JStringFormatUtility
-(NSString *)addEscapeScharactersToString:(NSString *)string
{
    NSString *stringWithQuoteEscape = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *stringWithNewLineEscape = [stringWithQuoteEscape stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    NSString *stringWithBackSpaceEscape = [stringWithNewLineEscape stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
    NSString *stringWithTabEscape = [stringWithBackSpaceEscape stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    return stringWithTabEscape;
}
@end
