//
//  HNAHCDetailRemiderCell.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

/**
 *  点击［提醒］后显示的cell，默认显示 HNAHCDetailCell
 */
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

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HNAHCDetailReminderCell";
    HNAHCDetailReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    return cell;
}

- (IBAction)reminderBtnClicked:(UIButton *)sender {
    [super descBtnClicked:sender];
}
@end
