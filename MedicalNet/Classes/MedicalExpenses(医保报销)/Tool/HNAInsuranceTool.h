//
//  HNAInsuranceTool.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 医保报销 相关网络请求接口

#import <Foundation/Foundation.h>

@class HNAGetExpenseDirectionResult;
@class HNAGetExpenseRecordsParam,HNAGetExpenseRecordsResult,HNAResult;
@class HNAApplyExpenseParam;
@class HNAExpenseDetailModel;
@class HNAInsuranceCompanyModel;

@interface HNAInsuranceTool : NSObject

/**
 *  通过companyId获取医保报销说明
 *
 *  @param companyId 公司id
 *  @param success   success
 *  @param failure   failure
 */
+ (void)getExpenseDirectionsWithCompanyId:(NSString *)companyId success:(void(^)(HNAGetExpenseDirectionResult *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取报销纪录
 */
+ (void)getExpenseRecordsWithParam:(HNAGetExpenseRecordsParam *)param success:(void (^)(HNAGetExpenseRecordsResult *result))success failure:(void (^)(NSError *))failure;

/**
 *  申请报销
 *
 *  POST
 */
+ (void)applyExpenseWithParam:(HNAApplyExpenseParam *)param success:(void (^)(HNAResult * result))success failure:(void (^)(NSError *))failure;

/**
 *  获取报销详情
 *
 *  @param recordId 记录id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getExpenseDetailsWithRecordId:(NSString *)recordId success:(void (^)(HNAExpenseDetailModel *expenseDetail))success failure:(void (^)(NSError *))failure;

/**
 *  获取保险公司信息
 *
 *  @param companyId 保险公司id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getInsuranceCompayWithId:(NSInteger)insurancecompanyId success:(void (^)(HNAInsuranceCompanyModel *insuranceCompany))success failure:(void (^)(NSError *error))failure;
@end
