//
//  HNAExpenseRecordsParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAGetExpenseRecordsParam : NSObject
/**
 *  申请人id，调用“ 登陆接口 ”时返回该值
 */
@property (nonatomic,assign) long long id;
/**
 *  按月份搜索，为空时搜索全部
 */
@property (nonatomic,assign) NSInteger year;
/**
 *  按月份搜索，为空时搜索全部
 */
@property (nonatomic,assign) NSInteger month;

+ (instancetype)param;
@end
