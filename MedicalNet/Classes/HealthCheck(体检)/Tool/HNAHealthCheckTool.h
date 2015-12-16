//
//  HNAHealthCheckTool.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HNAGetHCRecordsParam,HNAGetHCRecordsResult;
@class HNAGetHCDetailParam,HNAGetHCDetailResult;
@class HNAGetPackageDetailParam,HNAGetPackageDetailResult;
@class HNAGetPackageListParam,HNAGetPackageListResult;
@class HNAGetHCOrganListParam,HNAGetHCOrganListResult;
@class HNAReserveHCParam,HNAReserveHCResult;

@interface HNAHealthCheckTool : NSObject

/**
 *  获取体检纪录
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getHCRecordsWithParam:(HNAGetHCRecordsParam *)param success:(void(^)(HNAGetHCRecordsResult *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取体检详情
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getHCDetailWithParam:(HNAGetHCDetailParam *)param success:(void (^)(HNAGetHCDetailResult *))success failure:(void (^)(NSError *))failure;

/**
 *  获取体检套餐详情
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getPackgetDetailWithParam:(HNAGetPackageDetailParam *)param success:(void (^)(HNAGetPackageDetailResult *))success failure:(void (^)(NSError *))failure;


/**
 *  获取体检套餐列表
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getPackageListWithParam:(HNAGetPackageListParam *)param success:(void (^)(HNAGetPackageListResult *))success failure:(void (^)(NSError *))failure;

/**
 *  获取体检机构列表
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getHCOrganListWithParam:(HNAGetHCOrganListParam *)param success:(void (^)(HNAGetHCOrganListResult *))success failure:(void (^)(NSError *))failure;

/**
 *  预约体检
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)reserveHCWithParam:(HNAReserveHCParam *)param success:(void (^)(HNAReserveHCResult *))success failure:(void (^)(NSError *))failure;
@end
