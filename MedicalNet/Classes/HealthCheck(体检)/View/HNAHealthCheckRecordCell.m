//
//  HNAHealthCheckCell.m
//  MedicalNet
//
//  Created by gengliming on 15/11/26.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHealthCheckRecordCell.h"

@interface HNAHealthCheckRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
@implementation HNAHealthCheckRecordCell

- (void)setModel:(HNAHealthCheckRecordModel *)model{
    _model = model;
    
    self.packageNameLabel.text = model.name;
    self.dateLabel.text = model.date;
    self.stateLabel.text = model.status;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"HealthCheckRecordCell";
    HNAHealthCheckRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (void)awakeFromNib {
}

@end
