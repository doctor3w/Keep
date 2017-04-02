//
//  ViewController.m
//  Keep
//
//  Created by Drew Dunne on 4/21/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "ViewController.h"
#import "TaskTableViewCell.h"
#import "defines.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tasksArray = [[NSMutableArray alloc] initWithArray:[TasksModel getTasksFromDB]];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearComplete) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //[super viewDidLoad];
    if (appDelegate.tableNeedsUpdate) {
        [tasksArray insertObject:appDelegate.selectedTask atIndex:0];
        [self updatePriority];
        [self.taskTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        appDelegate.tableNeedsUpdate = NO;
    }
    if (appDelegate.cellEdited) {
        [tasksArray replaceObjectAtIndex:appDelegate.selectedIndexPath.row withObject:appDelegate.selectedTask];
        [self updatePriority];
        [self.taskTable reloadRowsAtIndexPaths:@[appDelegate.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        appDelegate.cellEdited = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self clearComplete];
}

- (void)clearComplete {
    for (NSInteger i = 0; i < tasksArray.count; i++) {
        Task *checkComplete = [tasksArray objectAtIndex:i];
        if (checkComplete.isComplete) {
            [tasksArray removeObject:checkComplete];
            [self.taskTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self updatePriority];
}

- (IBAction)taskFinished:(UIButton *)sender {
    TaskTableViewCell *cell = (TaskTableViewCell *)[[sender superview] superview];
    Task *completeTask = [tasksArray objectAtIndex:[self.taskTable indexPathForCell:cell].row];
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
    if (tasksArray == nil || tasksArray.count == 0) {
        self.taskTable.hidden = YES;
        self.allDoneView.hidden = NO;
    } else {
        self.taskTable.hidden = NO;
        self.allDoneView.hidden = YES;
    }
    
    for (NSInteger i = 0; i < tasksArray.count; i++) {
        Task *needsUpdateObj = [tasksArray objectAtIndex:i];
        needsUpdateObj.priority = i+1;
        if (![TasksModel updateTask:needsUpdateObj])
            NSLog(@"Error Updating");
        [tasksArray replaceObjectAtIndex:i withObject:needsUpdateObj];
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
    tasksArray = nil;
}

//create cell for each task
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = (TaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"task_cell" forIndexPath:indexPath];
    Task *thisTask = [tasksArray objectAtIndex:indexPath.row];
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
    Task *temp = [tasksArray objectAtIndex:sourceIndexPath.row];
    [tasksArray removeObject:temp];
    [tasksArray insertObject:temp atIndex:destinationIndexPath.row];
    NSInteger high, low;
    if (sourceIndexPath.row > destinationIndexPath.row) {
        high = sourceIndexPath.row;
        low = destinationIndexPath.row;
    } else {
        low = sourceIndexPath.row;
        high = destinationIndexPath.row;
    }
    for (NSInteger i = low; i < high; i++) {
        Task *needsUpdateObj = [tasksArray objectAtIndex:i];
        needsUpdateObj.priority = i+1;
        if (![TasksModel updateTask:needsUpdateObj])
            NSLog(@"Error Updating");
        [tasksArray replaceObjectAtIndex:i withObject:needsUpdateObj];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        Task *objToRemove = [tasksArray objectAtIndex:indexPath.row];
        [TasksModel removeTask:objToRemove];
        [tasksArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self updatePriority];
        //[tableView reloadData]; // tell table to refresh now
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![(Task *)[tasksArray objectAtIndex:indexPath.row] isComplete]) {
        appDelegate.selectedTask = [tasksArray objectAtIndex:indexPath.row];
        appDelegate.selectedIndexPath = indexPath;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"edit_task" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//return the amount of cells based on the tasks
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tasksArray.count;
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
