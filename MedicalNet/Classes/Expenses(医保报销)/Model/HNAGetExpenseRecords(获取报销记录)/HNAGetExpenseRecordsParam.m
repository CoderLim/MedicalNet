//
//  HNAExpenseRecordsParam.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetExpenseRecordsParam.h"

@implementation HNAGetExpenseRecordsParam

+ (instancetype)param {
    HNAGetExpenseRecordsParam *param = [[HNAGetExpenseRecordsParam alloc] init];
    param.id = [HNAUserTool user].id;
    return param;
}

@end
