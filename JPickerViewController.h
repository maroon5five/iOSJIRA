//
//  JPickerViewController.h
//  JIRAiOS
//
//  Created by Randy Miller on 1/27/14.
//  Copyright (c) 2014 Randy Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCreateIssueViewController.h"
#import "JIssueTabBarController.h"

@interface JPickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(nonatomic) int pickerToDisplay;

@property(nonatomic) NSArray *priorityOptions;
@property(nonatomic) NSArray *issueTypeOptions;

- (IBAction)doneWithPicker:(UIButton *)sender;

-(void)populateArraysForPickers;

@end
