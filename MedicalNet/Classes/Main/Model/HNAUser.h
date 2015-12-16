//
//  HNAUser.h
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNALoginInfoResult;

@interface HNAUser : NSObject <NSCoding>

/**
 *  用户id
 */
@property (nonatomic,copy) NSString *id;

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
@property (nonatomic,copy) NSString *insuranceCompanyId;

/**
 *  体检机构
 */
@property (nonatomic,copy) NSString *medicalId;

+ (instancetype)user;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;
+ (instancetype)userWithLoginInfoResult:(HNALoginInfoResult *)result;

@end
