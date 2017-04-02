//
//  NotesViewController.h
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "AppDelegate.h"

@interface NotesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *notesField;
-(IBAction)cancel;
- (IBAction)saveNotes;
@end
