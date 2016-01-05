//
//  HNAHCDetailCellBase.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCDetailCellBase.h"

@interface HNAHCDetailCellBase()
@property (nonatomic,strong) NSMutableArray *array;

@end
@implementation HNAHCDetailCellBase
- (void)setModel:(HNAHCStatusRecord *)model {
    _model = model;
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

+ (instancetype)cellForTableView:(UITableView*)tableView withIdentifier:(NSString *)idenfifier{
    return [tableView dequeueReusableCellWithIdentifier:idenfifier];
}

- (void)descButtonClicked:(UIButton *)sender {
    self.model.isSelected = !self.model.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
