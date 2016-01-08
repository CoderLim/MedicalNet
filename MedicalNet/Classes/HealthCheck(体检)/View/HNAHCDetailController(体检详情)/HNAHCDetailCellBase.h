//
//  HNAHCDetailCellBase.h
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetHCDetailResult.h"
#import "HNAProgressCellBase.h"

@interface HNAHCDetailCellBase : HNAProgressCellBase
/**
 *  模型数据
 */
@property (nonatomic, strong) HNAHCStatusRecord *model;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

+(instancetype) alloc __attribute__((unavailable("不可用，请使用cellFor开头的方法")));
+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;
- (void)descBtnClicked:(UIButton *)sender;
@end
