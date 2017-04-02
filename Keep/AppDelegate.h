//
//  AppDelegate.h
//  Keep
//
//  Created by Drew Dunne on 4/21/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TasksModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Task *selectedTask;
@property (nonatomic) BOOL tableNeedsUpdate;
@property (nonatomic) BOOL cellEdited;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

