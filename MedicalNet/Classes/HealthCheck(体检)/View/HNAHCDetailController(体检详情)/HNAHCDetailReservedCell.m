//
//  HNAHCDetailReservedCell.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

/**
 *  点击［已预约］后显示的cell，默认显示 HNAHCDetailCell
 */

#import "HNAHCDetailReservedCell.h"
#import "HNAGetHCDetailResult.h"

@interface HNAHCDetailReservedCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *descButton;
@property (weak, nonatomic) IBOutlet UILabel *medicalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *institutionNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openHourButton;
@property (weak, nonatomic) IBOutlet UIButton *addrButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

- (IBAction)dial:(UIButton *)sender;
- (IBAction)descButtonClicked:(UIButton *)sender;

@end

@implementation HNAHCDetailReservedCell

- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];
    self.dateLabel.text = model.date;
    [self.descButton setTitle:model.desc forState:UIControlStateNormal];
}

- (void)setAppointment:(HNAHCAppointment *)appointment {
    _appointment = appointment;
    
    self.medicalTimeLabel.text = appointment.medicalTime;
    self.institutionNameLabel.text = appointment.name;
    [self.openHourButton setTitle:appointment.openHours forState:UIControlStateNormal];
    [self.addrButton setTitle:appointment.addr forState:UIControlStateNormal];
}

+ (NSString *)getIdentifier {
    static NSString *identifier = @"HNAHCDetailReservedCell";
    return identifier;
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath appointment:(HNAHCAppointment *)appointment{
    HNAHCDetailReservedCell *cell = [super cellForTableView:tableView withIndexPath:indexPath];
    cell.appointment = appointment;
    return cell;
}

/**
 *  打电话
 */
- (IBAction)dial:(UIButton *)sender {
    // url
    NSString *urlStr = [NSString stringWithFormat:@"telprompt://%@", self.appointment.phone];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)descButtonClicked:(UIButton *)sender {
    [super descBtnClicked:sender];
}

@end
