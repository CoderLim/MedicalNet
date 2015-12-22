//
//  HNAMedicalExpenseDetailCell.h
//  MedicalNet
//
//  Created by gengliming on 15/12/21.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAExpenseDetailModel.h"

@interface HNAExpenseDetailCell : UITableViewCell

@property(nonatomic,strong) HNAExpenseDetailStatusRecord *model;

@property (nonatomic,assign) BOOL showTip;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
