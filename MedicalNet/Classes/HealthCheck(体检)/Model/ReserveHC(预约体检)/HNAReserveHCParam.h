//
//  HNAReserveHCParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 预约体检

#import <Foundation/Foundation.h>

@interface HNAReserveHCParam : NSObject
/**
 *  申请人id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  申报人姓名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  所属公司id
 */
@property (nonatomic,copy) NSString *compnayId;
/**
 *  所属公司名称
 */
@property (nonatomic,copy) NSString *companyName;
/**
 *  所选套餐id
 */
@property (nonatomic,copy) NSString *packageId;
/**
 *  体检机构id
 */
@property (nonatomic,copy) NSString *organId;
/**
 *  预约时间，yyyy－MM－dd格式
 */
@property (nonatomic,copy) NSString *reserveDate;

@end
