//
//  HNAForgetPwdParam.m
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAForgetPwdParam.h"

@implementation HNAForgetPwdParam

+ (instancetype)param {
    HNAForgetPwdParam *p = [[HNAForgetPwdParam alloc] init];
    p.id = [HNAUserTool user].id;
    p.theNewPwd = @"";
    return p;
}

@end
