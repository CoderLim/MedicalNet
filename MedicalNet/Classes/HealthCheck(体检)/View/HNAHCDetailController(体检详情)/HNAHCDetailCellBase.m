//
//  HNAHCDetailCellBase.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

// 基类

#import "HNAHCDetailCellBase.h"

@interface HNAHCDetailCellBase()
@end
@implementation HNAHCDetailCellBase

- (void)setModel:(HNAHCStatusRecord *)model {
    _model = model;
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)descBtnClicked:(UIButton *)sender {
    self.model.isSelected = !self.model.isSelected;
    if (self.indexPath != nil) {
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView reloadData];
    }
}

@end
