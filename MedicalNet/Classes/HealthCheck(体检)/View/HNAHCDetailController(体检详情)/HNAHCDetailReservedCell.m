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

@interface HNAHCDetailReservedCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *descButton;
- (IBAction)descButtonClicked:(UIButton *)sender;

@end
@implementation HNAHCDetailReservedCell

- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];
    self.dateLabel.text = model.date;
    [self.descButton setTitle:model.desc forState:UIControlStateNormal];
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HNAHCDetailReservedCell";
    HNAHCDetailReservedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    return cell;
}


- (IBAction)descButtonClicked:(UIButton *)sender {
    [super descBtnClicked:sender];
}
@end
