//
//  HNAChangePhoneParam.m
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangePhoneParam.h"

@implementation HNAChangePhoneParam

+ (instancetype)param {
    HNAChangePhoneParam *param = [[HNAChangePhoneParam alloc] init];
    param.id = [HNAUserTool user].id;
    return param;
}

@end
