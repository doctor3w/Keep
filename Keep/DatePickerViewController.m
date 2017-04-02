//
//  DatePickerViewController.m
//  Keep
//
//  Created by Drew Dunne on 4/23/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "DatePickerViewController.h"
#import "PDTSimpleCalendarViewCell.h"

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveDate)];
    UIBarButtonItem *removeDateButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove Due Date" style:UIBarButtonItemStylePlain target:self action:@selector(removeDate)];
    [removeDateButton setTintColor:[UIColor darkTextColor]];
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],removeDateButton,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setSelectedDate:[NSDate dateWithTimeIntervalSince1970:appDelegate.selectedTask.dateDue]];
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor colorWithRed:86/255.00 green:150/255.00 blue:199/255.00 alpha:1.0]];
}

- (IBAction)saveDate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.selectedDate == nil)
        appDelegate.selectedTask.dateDue = -1;
    else
        appDelegate.selectedTask.dateDue = [self.selectedDate timeIntervalSince1970];
    
    [self cancel];
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeDate {
    [self setSelectedDate:nil];
}

#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    //NSLog(@"Date Selected : %@",date);
    //NSLog(@"Date Selected with Locale %@", [date descriptionWithLocale:[NSLocale systemLocale]]);
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date
{
    return NO;
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date
{
    return [UIColor whiteColor];
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date
{
    return [UIColor orangeColor];
}

@end
