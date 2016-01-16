//
//  HNAGetPackageListParam.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetPackageListParam.h"

@implementation HNAGetPackageListParam

+ (instancetype)param {
    HNAGetPackageListParam *param = [[HNAGetPackageListParam alloc] init];
    param.companyId = [HNAUserTool user].companyId;
    return param;
}

@end
