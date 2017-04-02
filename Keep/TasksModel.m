//
//  TasksModel.m
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "TasksModel.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *updateStmt = nil;

@implementation TasksModel

+ (NSArray *)getTasksFromDB {
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (sqlite3_open([[TasksModel getDBPath] UTF8String], &database) == SQLITE_OK) {
        
        //Create statement
        const char *sql = [[NSString stringWithFormat:@"select taskID, name, dateDue, isComplete, priority, notes from Tasks order by priority asc"] UTF8String];
        sqlite3_stmt *selectstmt;
        
        //If connection is good, get tasks
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            //go through each row, get task
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                Task *taskObj = [[Task alloc] initWithKey:primaryKey];
                taskObj.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                taskObj.dateDue = (long)sqlite3_column_int(selectstmt, 2);
                taskObj.isComplete = sqlite3_column_int(selectstmt, 3);
                taskObj.priority = sqlite3_column_int(selectstmt, 4);
                taskObj.notes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                if (!taskObj.isComplete)
                    [array addObject:taskObj];
            }
            return array;
        }
        return nil;
    }
    else
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
    return nil;
}

+ (NSArray *)getCompleteTasksFromDB {
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (sqlite3_open([[TasksModel getDBPath] UTF8String], &database) == SQLITE_OK) {
        
        //Create statement
        const char *sql = [[NSString stringWithFormat:@"select taskID, name, dateDue, isComplete, priority, notes from Tasks order by priority asc"] UTF8String];
        sqlite3_stmt *selectstmt;
        
        //If connection is good, get tasks
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            //go through each row, get task
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                Task *taskObj = [[Task alloc] initWithKey:primaryKey];
                taskObj.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                taskObj.dateDue = (long)sqlite3_column_int(selectstmt, 2);
                taskObj.isComplete = sqlite3_column_int(selectstmt, 3);
                taskObj.priority = sqlite3_column_int(selectstmt, 4);
                taskObj.notes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                if (taskObj.isComplete)
                    [array addObject:taskObj];
            }
            return array;
        }
        return nil;
    }
    else
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
    return nil;
}

+ (void) finalizeStatements {
    if(database) sqlite3_close(database);
    if(deleteStmt) sqlite3_finalize(deleteStmt);
    if(addStmt) sqlite3_finalize(addStmt);
    if(updateStmt) sqlite3_finalize(updateStmt);
}

+ (NSInteger)addNewTask:(Task *)addedTask {
    if(addStmt == nil) {
        const char *sql = "insert into Tasks(name, dateDue, isComplete, priority, notes) Values(?, ?, ?, ?, ?)";
        if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(addStmt, 1, [addedTask.name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(addStmt, 2, (int)addedTask.dateDue);
    sqlite3_bind_int(addStmt, 3, addedTask.isComplete);
    sqlite3_bind_int(addStmt, 4, (int)addedTask.priority);
    sqlite3_bind_text(addStmt, 5, [addedTask.notes UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt)) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        //Reset the add statement.
        sqlite3_reset(addStmt);
        return -1;
    } else {
        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
        addedTask.key = (NSInteger)sqlite3_last_insert_rowid(database);
        //Reset the add statement.
        sqlite3_reset(addStmt);
        return addedTask.key;
    }
}

+ (BOOL)removeTask:(Task *)removeTask {
    if(deleteStmt == nil) {
        const char *sql = "delete from Tasks where taskID = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
    }
    
    //When binding parameters, index starts from 1 and not zero.
    sqlite3_bind_int(deleteStmt, 1, (int)removeTask.key);
    
    if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(deleteStmt);
        return NO;
    }
    sqlite3_reset(deleteStmt);
    return YES;
}

+ (BOOL)updateTask:(Task *)updatedTask {
    if(updateStmt == nil) {
        const char *sql = "UPDATE Tasks SET name = (?), dateDue = (?), isComplete = (?), priority = (?), notes = (?) WHERE taskID = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
    }
    
    //When binding parameters, index starts from 1 and not zero.
    sqlite3_bind_text(updateStmt, 1, [updatedTask.name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateStmt, 2, (int)updatedTask.dateDue);
    sqlite3_bind_int(updateStmt, 3, updatedTask.isComplete);
    sqlite3_bind_int(updateStmt, 4, (int)updatedTask.priority);
    sqlite3_bind_text(updateStmt, 5, [updatedTask.notes UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateStmt, 6, (int)updatedTask.key);
    
    if (SQLITE_DONE != sqlite3_step(updateStmt)) {
        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(updateStmt);
        return NO;
    }
    sqlite3_reset(updateStmt);
    return YES;
}

+ (NSString *)getDBPath {
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"UserData.sqlite"];
}

@end
