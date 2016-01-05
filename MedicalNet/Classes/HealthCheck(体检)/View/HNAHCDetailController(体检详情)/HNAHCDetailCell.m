//
//  HNAHCDetailCell.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCDetailCell.h"

@interface HNAHCDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *descButton;
- (IBAction)descButtonClicked:(UIButton *)sender;

@end
@implementation HNAHCDetailCell

- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];

    self.dateLabel.text = model.date;
    [self.descButton setTitle:model.desc forState:UIControlStateNormal];
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier_default = @"HNAHCDetailCell";
    HNAHCDetailCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier_default];
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    return cell;
}

- (IBAction)descButtonClicked:(UIButton *)sender {
    self.model.isSelected = !self.model.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
