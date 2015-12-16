//
//  HNAGetHCOrganListResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取体检机构列表

#import <Foundation/Foundation.h>

@class HNAHCOrgan;

@interface HNAGetHCOrganListResult : NSObject

@property (nonatomic,copy) NSString *packageId;
@property(nonatomic,strong) NSMutableArray<HNAHCOrgan *> *organs;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)organListWithDict:(NSDictionary *)dict;
@end


@interface HNAHCOrgan : NSObject
/**
 *  体检机构id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  体检机构名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  体检机构地址
 */
@property (nonatomic,copy) NSString *addr;
/**
 *  营业时间
 */
@property (nonatomic,copy) NSString *openHour;
/**
 *  体检机构电话
 */
@property (nonatomic,copy) NSString *phone;
/**
 *  经度
 */
@property (nonatomic,copy) NSString *lng;
/**
 *  纬度
 */
@property (nonatomic,copy) NSString *lat;

@end
