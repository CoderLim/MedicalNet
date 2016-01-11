//
//  HNAHCDetailReservedCell.h
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAHCDetailCell.h"

#import "HNAHCDetailCellBase.h"

@class HNAHCAppointment;

@interface HNAHCDetailReservedCell : HNAHCDetailCellBase

/**
 *  预约
 */
@property (nonatomic, strong) HNAHCAppointment *appointment;

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath appointment:(HNAHCAppointment *)appointment;
@end
