//
//  HNAHCReservationPackageItem.m
//  MedicalNet
//
//  Created by gengliming on 16/1/11.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCReservePackageButton.h"

@implementation HNAHCReservePackageButton

+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model {
    HNAHCReservePackageButton *button  = [HNAHCReservePackageButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:model.packageName forState:UIControlStateNormal];
    return button;
}

@end
