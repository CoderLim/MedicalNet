//
//  HNAGetHCRecordsParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取体检记录

#import <Foundation/Foundation.h>

@interface HNAGetHCRecordsParam : NSObject

/**
 *  申请人ID，调用“登陆接口”时返回该值
 */
@property (nonatomic,assign) long long id;
/**
 *  按年搜索，为空值时搜索全部
 */
@property (nonatomic,copy) NSString *year;
/**
 *  按月搜索，为空值时搜索全部
 */
@property (nonatomic,copy) NSString *month;

+ (instancetype)param;

@end
