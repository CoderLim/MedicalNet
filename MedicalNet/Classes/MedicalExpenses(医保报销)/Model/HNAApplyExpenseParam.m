//
//  HNAApplyExpenseModel.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplyExpenseParam.h"

@implementation HNAApplyExpenseParam
+ (instancetype)param {
    HNAUser *currentUser = [HNAUserTool user];
    
    HNAApplyExpenseParam *param = [[HNAApplyExpenseParam alloc] init];
    param.insuranceCompanyId = currentUser.insuranceCompanyId;
    param.id = currentUser.id;
    param.name = currentUser.name;
    param.companyId = currentUser.companyId;
    param.companyName = currentUser.companyName;
    param.phoneNum = currentUser.phoneNum;
    return param;
}
@end
