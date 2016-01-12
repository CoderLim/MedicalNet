//
//  HNAReserveHCParam.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAReserveHCParam.h"

@implementation HNAReserveHCParam

+ (instancetype)param {
    HNAReserveHCParam *p = [[HNAReserveHCParam alloc] init];
    
    HNAUser *user = [HNAUserTool user];
    p.id = user.id;
    p.name = user.name;
    p.compnayId = user.companyId;
    p.companyName = user.companyName;
    
    return p;
}

@end
