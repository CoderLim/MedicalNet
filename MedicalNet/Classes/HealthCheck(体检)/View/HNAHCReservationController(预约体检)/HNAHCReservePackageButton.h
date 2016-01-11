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
@property (nonatomic, strong) HNAPackageListItem *model;

+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model;
@end
