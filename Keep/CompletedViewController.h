//
//  CompletedViewController.h
//  Keep
//
//  Created by Drew Dunne on 4/24/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TasksModel.h"
#import "AllDoneView.h"
#import "AppDelegate.h"

@interface CompletedViewController : UIViewController {
    NSMutableArray *completedTasksArray;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *taskTable;
@property (weak, nonatomic) IBOutlet AllDoneView *allDoneView;
- (IBAction)taskFinished:(UIButton *)sender;
- (IBAction)cancel;
- (IBAction)clearTasks;
@end
