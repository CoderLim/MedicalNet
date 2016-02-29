//
//  HNAChangePwdParam.m
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangePwdParam.h"

@implementation HNAChangePwdParam

+ (instancetype)param {
    HNAChangePwdParam *param = [[HNAChangePwdParam alloc] init];
    param.id = [HNAUserTool user].id;
    return param;
}

@end
