//
//  HNALoginInfoResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@interface HNALoginInfoResult : HNAResult

/**
 *  员工id
 */
@property (nonatomic,assign) long long id;

/**
 *  员工姓名
 */
@property (nonatomic,copy) NSString *name;

/**
 *  手机号
 */
@property (nonatomic,copy) NSString *phoneNum;

/**
 *  头像
 */
@property (nonatomic,copy) NSString *icon;

/**
 *  公司id
 */
@property (nonatomic,copy) NSString *companyId;

/**
 *  公司名称
 */
@property (nonatomic,copy) NSString *companyName;

/**
 *  保险公司id
 */
@property (nonatomic,assign) NSInteger insuranceCompanyId;

/**
 *  体检机构
 */
@property (nonatomic,copy) NSString *medicalId;

/**
 *  是否是首次登陆，1=是，0=否
 */
@property (nonatomic,copy) NSString *isPreLanding;

@end
