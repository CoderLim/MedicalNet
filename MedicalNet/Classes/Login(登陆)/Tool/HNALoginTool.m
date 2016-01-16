//
//  HNALoginTool.m
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNALoginTool.h"
#import "MJExtension.h"
#import "HNAHttpTool.h"
#import "HNALoginInfoParam.h"
#import "HNALoginInfoResult.h"
#import "HNAUserTool.h"
#import "HNAUser.h"

@implementation HNALoginTool

+ (void)loginWithParam:(HNALoginInfoParam *)param success:(void (^)(HNALoginInfoResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/login", RequestUrlDomain];
    
    [HNAHttpTool postWithURL:urlStr params:param.keyValues success:^(id json) {
        if (success) {
            HNALoginInfoResult *result = [HNALoginInfoResult objectWithKeyValues:json];
            // glm:测试数据
//            result.name = param.username;
//            result.companyId = @"1234";
//            result.companyName = @"1234";
//            result.id = @"111111";
//            result.insuranceCompanyId = @"21321";
            
            HNAUser *user = [HNAUser userWithLoginInfoResult:result];
            [HNAUserTool saveUser:user];
            
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
//            HNALoginInfoResult *result = [[HNALoginInfoResult alloc] init];
//            // glm:测试数据
//            result.success = HNARequestResultSUCCESS;
//            result.name = param.username;
//            result.companyId = @"1234";
//            result.companyName = @"1234";
//            result.id = @"111111";
//            result.phoneNum = @"15201590388";
//            result.insuranceCompanyId = @"21321";
//            
//            HNAUser *user = [HNAUser userWithLoginInfoResult:result];
//            [HNAUserTool saveUser:user];
//            
//            success(result);
        }
    }];
}

@end
