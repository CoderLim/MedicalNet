//
//  HNAMedicalExpenseDetailCell.h
//  MedicalNet
//
//  Created by gengliming on 15/12/21.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetExpenseDetailResult.h"
#import "HNAProgressCellBase.h"

@interface HNAExpenseDetailCell : HNAProgressCellBase

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) HNAExpenseDetailStatusRecord *model;
/*
 *    是否显示下方的文字
 */
@property (nonatomic,assign) BOOL showTip;

@end
