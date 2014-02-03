//
//  JActivityIndicatorUtility.m
//  JIRAiOS
//
//  Created by New User on 2/2/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import "JActivityIndicatorUtility.h"

@implementation JActivityIndicatorUtility

static UIView *overlayView;
static UIActivityIndicatorView *activityIndicatorView;

+(void)startActivityIndicatorInView:(UIView *)view
{
    overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = overlayView.center;
    [overlayView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    [view addSubview:overlayView];
}

+(void)stopActivityIndicator
{
    [activityIndicatorView stopAnimating];
    [overlayView removeFromSuperview];
}

@end
