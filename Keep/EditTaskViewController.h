//
//  EditTaskViewController.h
//  Keep
//
//  Created by Drew Dunne on 4/23/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TasksModel.h"
#import "AppDelegate.h"

@interface EditTaskViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)saveTask;
- (IBAction)cancel;
- (IBAction)keyboardDone;

@end
