//
//  HNAChangePortrait.m
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangePortraitParam.h"

@implementation HNAChangePortraitParam

+ (instancetype)param {
    HNAChangePortraitParam *param = [[HNAChangePortraitParam alloc] init];
    param.id = [HNAUserTool user].id;
    return param;
}
@end
