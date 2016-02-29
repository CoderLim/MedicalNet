//
//  HNAGetHCRecordsParam.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetHCRecordsParam.h"

@implementation HNAGetHCRecordsParam

+ (instancetype)param {
    HNAGetHCRecordsParam *p = [[HNAGetHCRecordsParam alloc] init];
    p.id = [HNAUserTool user].id;
    p.year = @"";
    p.month = @"";
    return p;
}

@end
