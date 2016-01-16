//
//  HNAHealthCheckCell.h
//  MedicalNet
//
//  Created by gengliming on 15/11/26.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAHealthCheckRecordModel.h"

@interface HNAHealthCheckRecordCell : UITableViewCell

@property(nonatomic,strong) HNAHealthCheckRecordModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
