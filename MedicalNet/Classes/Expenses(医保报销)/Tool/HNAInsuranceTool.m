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
#import "HNAExpenseDetailModel.h"
#import "HNAInsuranceCompanyModel.h"

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
            HNAGetExpenseDirectionResult *result = [[HNAGetExpenseDirectionResult alloc] init];
            result.expenseDirection = [HNAExpenseDirectionModel objectWithKeyValues:json];
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
    
    NSDictionary *paramDict = @{@"insuranceCompanyId":@(param.insuranceCompanyId),
                                @"name":param.name,
                                @"companyId":param.companyId,
                                @"companyName":param.companyName,
                                @"phoneNum":param.phoneNum,
                                @"cardNum":param.cardNum
                                };
    
    NSMutableArray *formDataArray = [NSMutableArray array];
    if (param.IDcard_1 != nil) {
        // 身份证
        HNAFormData *idCard_1 = [[HNAFormData alloc] init];
        idCard_1.name = @"IDcard_1";
        idCard_1.filename = idCard_1.name;
        idCard_1.mimeType = @"image/png";
        idCard_1.data = UIImagePNGRepresentation(param.IDcard_1);
    }
    
    if (param.IDcard_2 != nil) {
        HNAFormData *idCard_2 = [[HNAFormData alloc] init];
        idCard_2.name = @"IDcard_2";
        idCard_2.filename = idCard_2.name;
        idCard_2.mimeType = @"image/png";
        idCard_2.data = UIImagePNGRepresentation(param.IDcard_2);
    }
    
    if (param.medicalCard_1 != nil) {
        // 医保卡
        HNAFormData *medicalCard_1 = [[HNAFormData alloc] init];
        medicalCard_1.name = @"medicalCard_1";
        medicalCard_1.filename = medicalCard_1.name;
        medicalCard_1.mimeType = @"image/png";
        medicalCard_1.data = UIImagePNGRepresentation(param.medicalCard_1);
    }
    
    if (param.medicalCard_2 != nil) {
        HNAFormData *medicalCard_2 = [[HNAFormData alloc] init];
        medicalCard_2.name = @"medicalCard_2";
        medicalCard_2.filename = medicalCard_2.name;
        medicalCard_2.mimeType = @"image/png";
        medicalCard_2.data = UIImagePNGRepresentation(param.medicalCard_2);
    }
    
    if (param.cases_1 != nil) {
        // 就医证明
        HNAFormData *cases_1 = [[HNAFormData alloc] init];
        cases_1.name = @"cases_1";
        cases_1.filename = cases_1.name;
        cases_1.mimeType = @"image/png";
        cases_1.data = UIImagePNGRepresentation(param.cases_1);
    }
    
    if (param.cases_2 != nil) {
        HNAFormData *cases_2 = [[HNAFormData alloc] init];
        cases_2.name = @"cases_2";
        cases_2.filename = cases_2.name;
        cases_2.mimeType = @"image/png";
        cases_2.data = UIImagePNGRepresentation(param.cases_2);
    }
    
    if (param.charges_1 != nil) {
        // 收费证明
        HNAFormData *charges_1 = [[HNAFormData alloc] init];
        charges_1.name = @"charges_1";
        charges_1.filename = charges_1.name;
        charges_1.mimeType = @"image/png";
        charges_1.data = UIImagePNGRepresentation(param.charges_1);
    }
    
    if (param.charges_2 != nil) {
        HNAFormData *charges_2 = [[HNAFormData alloc] init];
        charges_2.name = @"charges_2";
        charges_2.filename = charges_2.name;
        charges_2.mimeType = @"image/png";
        charges_2.data = UIImagePNGRepresentation(param.charges_2);
    }
    
    [HNAHttpTool postWithURL:urlStr params:paramDict formDataArray:formDataArray success:^(id json) {
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
+ (void)getExpenseDetailsWithRecordId:(NSString *)recordId success:(void (^)(HNAExpenseDetailModel *expenseDetail))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseDetails", RequestUrlDomain];
    
    [HNAHttpTool getWithURL:urlStr params:@{@"id" : recordId} success:^(id json) {
        if (success) {
            HNAExpenseDetailModel *expenseDetail = [HNAExpenseDetailModel objectWithKeyValues:json];
            success(expenseDetail);
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
+ (void)getInsuranceCompayWithId:(NSInteger)insurancecompanyId success:(void (^)(HNAInsuranceCompanyModel *insuranceCompany))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/expenseInfo", RequestUrlDomain];
    [HNAHttpTool getWithURL:urlStr params:@{@"insuranceCompanyId":@(insurancecompanyId)} success:^(id json) {
        if (success) {
            HNAInsuranceCompanyModel *insuranceComp = [HNAInsuranceCompanyModel objectWithKeyValues:json];
            success(insuranceComp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
