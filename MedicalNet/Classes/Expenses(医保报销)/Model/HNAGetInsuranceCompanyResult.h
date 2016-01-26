//
//  HNAInsuranceCompanyModel.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 保险公司信息

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNAInsuranceCompanyModel;

@interface HNAGetInsuranceCompanyResult : HNAResult
@property (nonatomic, strong) HNAInsuranceCompanyModel *insuranceCompany;
@end

@interface HNAInsuranceCompanyModel : NSObject
/**
 *  保险公司id
 */
@property (nonatomic,copy) NSString *insuranceCompanyId;
/**
 *  保险公司名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  地址
 */
@property (nonatomic,copy) NSString *addr;
/**
 *  邮编
 */
@property (nonatomic,copy) NSString *code;
/**
 *  电话
 */
@property (nonatomic,copy) NSString *phone;
@end
