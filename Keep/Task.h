//
//  Task.h
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

@interface Task : NSObject {
    NSInteger key;
    NSString *name;
    NSInteger dateDue;
    BOOL isComplete;
    NSInteger priority;
    NSString *notes;
}

@property (nonatomic) NSInteger key;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger dateDue;
@property (nonatomic) BOOL isComplete;
@property (nonatomic) NSInteger priority;
@property (strong, nonatomic) NSString *notes;

- (NSString *)getDateString;
- (id)initWithKey:(NSInteger)primaryKey;
- (KeepCheckboxType)getCheckboxType;

@end
