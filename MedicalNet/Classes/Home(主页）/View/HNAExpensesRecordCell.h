//
//  HNAExpensesRecordCell.h
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetExpenseRecordsResult.h"

#define RecordCellIdentifier @"RecordCell"

@interface HNAExpensesRecordCell : UITableViewCell
@property(nonatomic,strong) HNAExpenseRecordModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
