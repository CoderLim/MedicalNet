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
 *  数据模型
 */
@property (nonatomic, strong) HNAPackageListItem *model;

+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model;
@end
