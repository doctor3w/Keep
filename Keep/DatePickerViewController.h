//
//  DatePickerViewController.h
//  Keep
//
//  Created by Drew Dunne on 4/23/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTSimpleCalendarViewController.h"
#import "AppDelegate.h"

@interface DatePickerViewController : PDTSimpleCalendarViewController <PDTSimpleCalendarViewDelegate>

- (IBAction)saveDate;
- (IBAction)cancel;
- (IBAction)removeDate;

@end
