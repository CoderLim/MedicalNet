//
//  HNAHCReservationPackageItem.h
//  MedicalNet
//
//  Created by gengliming on 16/1/11.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetPackageListResult.h"

@interface HNAHCReservePackageButton : UIButton

/**
 *  根据model添加button
 *
 *  @param model 数据model
 *
 *  @return 当前实例
 */
+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model;
/**
 *  数据模型
 */
@property (nonatomic, strong) HNAPackageListItem *model;

@end
