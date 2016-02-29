//
//  HNAHCDetailRemiderCell.h
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAHCDetailCell.h"

#import "HNAHCDetailCellBase.h"

@interface HNAHCDetailReminderCell : HNAHCDetailCellBase

@property (nonatomic, copy) NSString *alertMessage;

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath alertMessage:(NSString *)alertMessage;

@end
