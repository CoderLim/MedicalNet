//
//  HNAGetExpenseDirectionResult.h
//  MedicalNet
//
//  Created by gengliming on 16/1/13.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNASecurityProgram, HNAExpenseDirectionModel;

@interface HNAGetExpenseDirectionResult : HNAResult
@property (nonatomic, strong) HNAExpenseDirectionModel *expenseDirection;
@end


@interface HNAExpenseDirectionModel : NSObject
/**
 *  公司id
 */
@property (nonatomic,copy) NSString *companyId;
/**
 *  保险公司id
 */
@property (nonatomic,copy) NSString *insuranceCompanyId;
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *packageId;
/**
 *  保障方案
 */
@property(nonatomic,strong) NSMutableArray<HNASecurityProgram *> *securityPrograms;
/**
 *  理赔所需材料
 */
@property(nonatomic,copy) NSString *materials;
/**
 *  可报销医院
 */
@property(nonatomic,strong) NSMutableArray *hospitals;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)directionWithDict:(NSDictionary *)dict;

@end

/**
 *  医保报销说明－保障方案
 */
@interface HNASecurityProgram : NSObject
/**
 *  项目
 */
@property (nonatomic,copy) NSString *project;
/**
 *  金额
 */
@property (nonatomic,copy) NSString *amount;

@end
