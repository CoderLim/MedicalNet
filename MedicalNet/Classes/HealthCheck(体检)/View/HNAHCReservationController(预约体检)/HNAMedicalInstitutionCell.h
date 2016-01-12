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
@property (nonatomic, strong) HNAHCOrgan *model;
@property (nonatomic, assign, getter=isChecked) BOOL checked;
/**
 *  当点击checkbox时调用
 */
@property (nonatomic, copy) HNAMedicalInstitutionCellSelectedBlock selectedBlock;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
