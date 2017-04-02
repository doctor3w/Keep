//
//  TasksModel.h
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import <sqlite3.h>
#import "AppDelegate.h"

@interface TasksModel : NSObject

+ (NSArray *)getTasksFromDB;
+ (NSArray *)getCompleteTasksFromDB;
+ (NSInteger)addNewTask:(Task *)addedTask;
+ (BOOL)removeTask:(Task *)removeTask;
+ (BOOL)updateTask:(Task *)updatedTask;
+ (NSString *)getDBPath;
+ (void)finalizeStatements;

@end
