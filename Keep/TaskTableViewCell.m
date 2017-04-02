//
//  TaskTableViewCell.m
//  Keep
//
//  Created by Drew Dunne on 4/22/15.
//  Copyright (c) 2015 Drew Dunne. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

@synthesize taskLabel, dateLabel, finishButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTaskLabelText:(NSString *)taskName {
    self.taskLabel.text = taskName;
}

- (void)setDateLabelText:(NSString *)dateString {
    self.dateLabel.text = dateString;
}

- (void)setFinishButtonImage:(NSString *)imageName {
    [self.finishButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (IBAction)taskFinished:(id)sender {
    
}

@end
