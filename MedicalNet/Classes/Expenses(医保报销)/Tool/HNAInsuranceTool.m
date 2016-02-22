//
//  HNAInsuranceTool.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAInsuranceTool.h"
#import "MJExtension.h"
#import "HNAHttpTool.h"
#import "HNAGetExpenseDirectionResult.h"

#import "HNAGetExpenseRecordsParam.h"
#import "HNAGetExpenseRecordsResult.h"

#import "HNAResult.h"
#import "HNAApplyExpenseParam.h"
#import "HNAGetExpenseDetailResult.h"
#import "HNAGetInsuranceCompanyResult.h"

@implementation HNAInsuranceTool

/**
 *  通过companyId获取医保报销说明
 *
 *  @param companyId 公司id,调用登录接口时返回的
 *  @param success   success
 *  @param failure   failure
 */
+ (void)getExpenseDirectionsWithCompanyId:(NSString *)companyId success:(void(^)(HNAGetExpenseDirectionResult *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseDesc", RequestUrlDomain];
    
    [HNAHttpTool getWithURL:urlStr params:@{@"companyId":companyId} success:^(id json) {
        if (success) {
            HNAGetExpenseDirectionResult *result = [HNAGetExpenseDirectionResult objectWithKeyValues:json];
            if (result.success == HNARequestResultSUCCESS) {
                result.expenseDirection = [HNAExpenseDirectionModel objectWithKeyValues:json];
            }
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

/**
 *  获取报销纪录
 */
+ (void)getExpenseRecordsWithParam:(HNAGetExpenseRecordsParam *)param success:(void (^)(HNAGetExpenseRecordsResult *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseRecords", RequestUrlDomain];
    [HNAHttpTool getWithURL:urlStr params:param.keyValues success:^(id json) {
        if (success) {
            HNAGetExpenseRecordsResult *result = [HNAGetExpenseRecordsResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  申请报销
 *
 *  POST
 */
+ (void)applyExpenseWithParam:(HNAApplyExpenseParam *)param success:(void (^)(HNAResult * result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/applyExpense", RequestUrlDomain];
    
    [HNAHttpTool postWithURL:urlStr params:[param toDict] toDisk:NO success:^(id json) {
        if (success) {
            HNAResult *result = [HNAResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  获取报销详情
 *
 *  @param recordId 记录id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getExpenseDetailsWithRecordId:(NSString *)recordId success:(void (^)(HNAGetExpenseDetailResult *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseDetails", RequestUrlDomain];
    
    [HNAHttpTool getWithURL:urlStr params:@{@"id" : recordId} success:^(id json) {
        if (success) {
            HNAGetExpenseDetailResult *result = [HNAGetExpenseDetailResult objectWithKeyValues:json];
            if (result.success == HNARequestResultSUCCESS) {
                result.expenseDetail = [HNAExpenseDetailModel objectWithKeyValues:json];
            }
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取保险公司信息
 *
 *  @param companyId 保险公司id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getInsuranceCompayWithId:(NSInteger)insurancecompanyId success:(void (^)(HNAGetInsuranceCompanyResult *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseInfo", RequestUrlDomain];
    [HNAHttpTool getWithURL:urlStr params:@{@"insuranceCompanyId":@(insurancecompanyId)} success:^(id json) {
        if (success) {
            HNAGetInsuranceCompanyResult *result = [HNAGetInsuranceCompanyResult objectWithKeyValues:json];
            if (result.success == HNARequestResultSUCCESS) {
                result.insuranceCompany = [HNAInsuranceCompanyModel objectWithKeyValues:json];
            }
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
