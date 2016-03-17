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

+ (void)getExpenseDirectionsWithCompanyId:(NSString *)companyId success:(void(^)(HNAGetExpenseDirectionResult *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseDesc", kRequestUrlDomain];
    
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

+ (void)getExpenseRecordsWithParam:(HNAGetExpenseRecordsParam *)param success:(void (^)(HNAGetExpenseRecordsResult *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseRecords", kRequestUrlDomain];
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

+ (void)applyExpenseWithParam:(HNAApplyExpenseParam *)param success:(void (^)(HNAResult * result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/applyExpense", kRequestUrlDomain];
    
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

+ (void)getExpenseDetailsWithRecordId:(NSString *)recordId success:(void (^)(HNAGetExpenseDetailResult *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseDetails", kRequestUrlDomain];
    
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

+ (void)getInsuranceCompayWithId:(NSInteger)insurancecompanyId success:(void (^)(HNAGetInsuranceCompanyResult *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseInfo", kRequestUrlDomain];
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
