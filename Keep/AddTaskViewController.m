//
//  AddTaskViewController.m
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "AddTaskViewController.h"

@implementation AddTaskViewController

- (void)viewDidLoad {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedTask = nil;
    appDelegate.selectedTask = [[Task alloc] init];
    if (appDelegate.selectedTask.dateDue < 0)
        self.dateLabel.text = @"Add Due Date";
    else
        self.dateLabel.text = [appDelegate.selectedTask getDateString];
    if ([appDelegate.selectedTask.notes isEqualToString:@""] || appDelegate.selectedTask.notes != nil)
        self.notesLabel.text = @"Add Notes";
    else
        self.notesLabel.text = appDelegate.selectedTask.notes;
    
}

- (IBAction)keyboardDone {
    [self.taskField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.selectedTask.dateDue < 0)
        self.dateLabel.text = @"Add Due Date";
    else
        self.dateLabel.text = [appDelegate.selectedTask getDateString];
    if ([appDelegate.selectedTask.notes isEqualToString:@""] || appDelegate.selectedTask.notes != nil)
        self.notesLabel.text = @"Add Notes";
    else
        self.notesLabel.text = appDelegate.selectedTask.notes;
}

- (IBAction)saveTask {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedTask.name = self.taskField.text;
    
    appDelegate.selectedTask.key = [TasksModel addNewTask:appDelegate.selectedTask];
    appDelegate.tableNeedsUpdate = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedTask = nil;
    appDelegate.tableNeedsUpdate = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
