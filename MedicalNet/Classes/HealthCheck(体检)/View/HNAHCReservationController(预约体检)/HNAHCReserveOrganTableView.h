//
//  HNAHCReserveHospitalTableView.h
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAMedicalInstitutionCell.h"

@class HNAHCOrgan;

@interface HNAHCReserveOrganTableView : UITableView

/**
 *  是否已展开
 */
@property (nonatomic, assign) BOOL expanded;
/**
 *  当前选中的cell
 */
@property (nonatomic, weak) HNAMedicalInstitutionCell *selectedCell;

/**
 *  注册单元格
 */
- (void)registerCell;

@end

