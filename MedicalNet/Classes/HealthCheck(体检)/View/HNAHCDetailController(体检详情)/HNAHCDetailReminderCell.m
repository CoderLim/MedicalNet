//
//  HNAHCDetailRemiderCell.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCDetailReminderCell.h"

@interface HNAHCDetailReminderCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)reminderBtnClicked:(UIButton *)sender;

@end
@implementation HNAHCDetailReminderCell

- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];
    
    self.dateLabel.text = model.date;
}

- (IBAction)reminderBtnClicked:(UIButton *)sender {
    self.model.isSelected = !self.model.isSelected;
    [self.tableView reloadData];
}
@end
