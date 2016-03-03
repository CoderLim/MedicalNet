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
@property (weak, nonatomic) IBOutlet UILabel *alertMessageLabel;

- (IBAction)reminderBtnClicked:(UIButton *)sender;

@end

@implementation HNAHCDetailReminderCell

#pragma mark - Public
+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath alertMessage:(NSString *)alertMessage{
    HNAHCDetailReminderCell *cell = [super cellForTableView:tableView withIndexPath:indexPath];
    cell.alertMessage = alertMessage;
    return cell;
}

#pragma mark - SuperClass
- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];
    self.dateLabel.text = model.date;
}

- (void)setAlertMessage:(NSString *)alertMessage {
    _alertMessage = alertMessage;
    self.alertMessageLabel.text = alertMessage;
}

+ (NSString *)getIdentifier {
    static NSString *identifier = @"HNAHCDetailReminderCell";
    return identifier;
}


#pragma mark - IBActions
- (IBAction)reminderBtnClicked:(UIButton *)sender {
    [super descBtnClicked:sender];
}

@end
