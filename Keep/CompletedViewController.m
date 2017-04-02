//
//  CompletedViewController.m
//  Keep
//
//  Created by Drew Dunne on 4/24/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "CompletedViewController.h"
#import "TaskTableViewCell.h"
#import "defines.h"

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    completedTasksArray = [[NSMutableArray alloc] initWithArray:[TasksModel getCompleteTasksFromDB]];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearTasks {
    for (NSInteger i = 0; i < completedTasksArray.count; i++) {
        Task *checkComplete = [completedTasksArray objectAtIndex:i];
        if (checkComplete.isComplete) {
            [completedTasksArray removeObject:checkComplete];
            [self.taskTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self updatePriority];
}

- (IBAction)taskFinished:(UIButton *)sender {
    TaskTableViewCell *cell = (TaskTableViewCell *)[[sender superview] superview];
    Task *completeTask = [completedTasksArray objectAtIndex:[self.taskTable indexPathForCell:cell].row];
    if (completeTask.isComplete == YES) {
        completeTask.isComplete = NO;
        [TasksModel updateTask:completeTask];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [self.taskTable reloadData];
    } else {
        completeTask.isComplete = YES;
        [TasksModel updateTask:completeTask];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDateLabelText:@""];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setFinishButtonImage:@"completed_task.png"];
        cell.taskLabel.textColor = [UIColor colorWithRed:131/255.00 green:131/255.00 blue:131/255.00 alpha:1.0];
    }
}

- (void)updatePriority {
    if (completedTasksArray == nil || completedTasksArray.count == 0) {
        self.taskTable.hidden = YES;
        self.allDoneView.hidden = NO;
    } else {
        self.taskTable.hidden = NO;
        self.allDoneView.hidden = YES;
    }
    
    for (NSInteger i = 0; i < completedTasksArray.count; i++) {
        Task *needsUpdateObj = [completedTasksArray objectAtIndex:i];
        needsUpdateObj.priority = i+1;
        if (![TasksModel updateTask:needsUpdateObj])
            NSLog(@"Error Updating");
        [completedTasksArray replaceObjectAtIndex:i withObject:needsUpdateObj];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.taskTable setEditing:editing animated:animated];
    if (editing == YES){
        // Change views to edit mode.
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        [self updatePriority];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    completedTasksArray = nil;
}

//create cell for each task
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = (TaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"task_cell" forIndexPath:indexPath];
    Task *thisTask = [completedTasksArray objectAtIndex:indexPath.row];
    [cell setTaskLabelText:thisTask.name];
    [cell setDateLabelText:[thisTask getDateString]];
    //set the correct button image
    KeepCheckboxType cellType = [thisTask getCheckboxType];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.taskLabel.textColor = [UIColor darkTextColor];
    if (cellType == KeepCheckboxTypeDefault) {
        [cell setFinishButtonImage:@"unfinished_task.png"];
        cell.dateLabel.textColor = [UIColor colorWithRed:56/255.00 green:98/255.00 blue:131/255.00 alpha:1.0];
    } else if (cellType == KeepCheckboxTypeOver) {
        [cell setFinishButtonImage:@"overdue_task.png"];
        cell.dateLabel.textColor = [UIColor colorWithRed:241/255.00 green:36/255.00 blue:1/255.00 alpha:0.75];
    } else {
        [cell setDateLabelText:@""];
        [cell setFinishButtonImage:@"completed_task.png"];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.taskLabel.textColor = [UIColor colorWithRed:131/255.00 green:131/255.00 blue:131/255.00 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Task *temp = [completedTasksArray objectAtIndex:sourceIndexPath.row];
    [completedTasksArray removeObject:temp];
    [completedTasksArray insertObject:temp atIndex:destinationIndexPath.row];
    NSInteger high, low;
    if (sourceIndexPath.row > destinationIndexPath.row) {
        high = sourceIndexPath.row;
        low = destinationIndexPath.row;
    } else {
        low = sourceIndexPath.row;
        high = destinationIndexPath.row;
    }
    for (NSInteger i = low; i < high; i++) {
        Task *needsUpdateObj = [completedTasksArray objectAtIndex:i];
        needsUpdateObj.priority = i+1;
        if (![TasksModel updateTask:needsUpdateObj])
            NSLog(@"Error Updating");
        [completedTasksArray replaceObjectAtIndex:i withObject:needsUpdateObj];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        Task *objToRemove = [completedTasksArray objectAtIndex:indexPath.row];
        [TasksModel removeTask:objToRemove];
        [completedTasksArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self updatePriority];
        //[tableView reloadData]; // tell table to refresh now
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![(Task *)[completedTasksArray objectAtIndex:indexPath.row] isComplete]) {
        appDelegate.selectedTask = [completedTasksArray objectAtIndex:indexPath.row];
        appDelegate.selectedIndexPath = indexPath;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"edit_task" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//return the amount of cells based on the tasks
- (long)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return completedTasksArray.count;
}

//Set the table cell insets to 0
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

@end
