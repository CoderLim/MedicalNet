//
//  HNASettingCell.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNASettingItem;

@interface HNASettingCell : UITableViewCell
@property(nonatomic,strong) HNASettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
