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

+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model;
/**
 *  数据模型
 */
@property (nonatomic, strong) HNAPackageListItem *model;

@end
