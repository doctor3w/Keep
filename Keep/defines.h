//
//  defines.h
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

typedef enum : NSUInteger {
    KeepCheckboxTypeDefault,
    KeepCheckboxTypeOver,
    KeepCheckboxTypeDone,
} KeepCheckboxType;

typedef enum : NSUInteger {
    KeepDue,
    KeepOverdue,
    KeepSoon,
    KeepWeeksAway,
    KeepNone,
} KeepTime;