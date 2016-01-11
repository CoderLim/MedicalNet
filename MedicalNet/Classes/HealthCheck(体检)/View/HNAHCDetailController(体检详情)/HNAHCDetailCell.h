//
//  HNAHCDetailCell.h
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetHCDetailResult.h"
#import "HNAProgressCellBase.h"
#import "HNAHCDetailCellBase.h"

typedef void(^HNAHCDetailCellBtnClicked)();

@interface HNAHCDetailCell : HNAHCDetailCellBase
@property (nonatomic, copy) HNAHCDetailCellBtnClicked descBlock;

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath descBlock:(HNAHCDetailCellBtnClicked)descBlock;
@end
