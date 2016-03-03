//
//  HNAMedicalInstitutionCell.h
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetHCOrganListResult.h"

/**
 *  当点击checkbox时调用
 */
typedef void(^HNAMedicalInstitutionCellSelectedBlock)();


@interface HNAMedicalInstitutionCell : UITableViewCell
/**
 *  tableView
 */
+ (instancetype)cellForTableView:(UITableView *)tableView;
/**
 *  数据模型
 */
@property (nonatomic, strong) HNAHCOrgan *model;
/**
 *  checkbox选中状态
 */
@property (nonatomic, assign, getter=isChecked) BOOL checked;
/**
 *  当点击checkbox时调用
 */
@property (nonatomic, copy) HNAMedicalInstitutionCellSelectedBlock selectedBlock;

@end
