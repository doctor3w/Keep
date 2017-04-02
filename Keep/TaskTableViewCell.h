//
//  TaskTableViewCell.h
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

- (void)setTaskLabelText:(NSString *)taskName;
- (void)setDateLabelText:(NSString *)dateString;
- (void)setFinishButtonImage:(NSString *)imageName;

@end
