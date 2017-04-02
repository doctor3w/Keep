//
//  Task.m
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize name, dateDue, isComplete, notes, key, priority;

- (id)init {
    self = [super init];
    if (self != nil) {
        key = -1;
        name = @"";
        dateDue = -1;
        isComplete = NO;
        priority = 0;
        notes = @"";
    }
    return self;
}

- (id)initWithKey:(NSInteger)primaryKey {
    self = [super init];
    if (self != nil) {
        key = primaryKey;
        name = @"";
        dateDue = -1;
        isComplete = NO;
        priority = 0;
        notes = @"";
    }
    return self;
}

- (NSString *)getDateString {
    if (self.dateDue < 0)
        return @"";
    KeepTime time = [self statusOfDueDate:self.dateDue comparedToDay:[NSDate date]];
    if (time == KeepNone)
        return @"";
    if (time == KeepDue)
        return @"Due";
    else if (time == KeepOverdue)
        return @"Overdue";
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    if (time == KeepWeeksAway) {
        [dayFormat setDateFormat:@"MMM dd"];
    } else if (time == KeepSoon)
        [dayFormat setDateFormat:@"EEE"];
    return [dayFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.dateDue]];
}

- (KeepTime)statusOfDueDate:(NSInteger)timeInterval comparedToDay:(NSDate *)date {
    NSDate *dueDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateComponents *dueDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:dueDate];
    NSDateComponents *dateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:date];
    if ([dueDateComp year] == [dateComp year] && [dueDateComp month] == [dateComp month] && [dueDateComp day] == [dateComp day])
        return KeepDue; // if day is equal
    if ([dueDateComp year] > [dateComp year]) {
        if ([dueDateComp month] == 1 && [dateComp month] == 12) {
            if (([dueDateComp day]+31)-[dateComp day] > 7)
                return KeepWeeksAway;
            else
                return KeepSoon;
        } else if ([dateComp month] == [dueDateComp month])
            return KeepWeeksAway;
        else if ([dueDateComp month] > [dateComp month])
            return KeepWeeksAway;
        else if ([dueDateComp month] < [dateComp month])
            return KeepOverdue;
    } else if ([dueDateComp year] == [dateComp year]) {
        if ([dateComp month]+1 == [dueDateComp month]) {
            if (([dueDateComp day]+31)-[dateComp day] > 7)
                return KeepWeeksAway;
            else
                return KeepSoon;
        } else if ([dateComp month] == [dueDateComp month]) {
            if ([dueDateComp day]-[dateComp day] > 7)
                return KeepWeeksAway;
            else if ([dueDateComp day]-[dateComp day] > 0)
                return KeepSoon;
            else
                return KeepOverdue;
        } else if ([dueDateComp month] > [dateComp month])
            return KeepWeeksAway;
        else if ([dueDateComp month] < [dateComp month])
            return KeepOverdue;
    } else if ([dueDateComp year] < [dateComp year])
        return KeepOverdue;
            
    return KeepNone;
}

- (NSUInteger)daysInMonth:(NSUInteger)month {
    //NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

- (KeepCheckboxType)getCheckboxType {
    if (self.isComplete)
        return KeepCheckboxTypeDone;
    if (self.dateDue < 0)
        return KeepCheckboxTypeDefault;
    KeepTime time = [self statusOfDueDate:self.dateDue comparedToDay:[NSDate date]];
    if (time == KeepOverdue)
        return KeepCheckboxTypeOver;
    else if (time == KeepDue)
        return KeepCheckboxTypeOver;
    else
        return KeepCheckboxTypeDefault;
}

@end
