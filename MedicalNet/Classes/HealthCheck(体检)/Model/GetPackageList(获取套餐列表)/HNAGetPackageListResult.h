//
//  HNAGetPackageListResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取套餐列表

@class HNAPackageListItem;

#import <Foundation/Foundation.h>

@interface HNAGetPackageListResult : NSObject
/**
 *  公司id
 */
@property (nonatomic,copy) NSString *companyId;
/**
 *  套餐列表
 */
@property(nonatomic,strong) NSMutableArray<HNAPackageListItem *> *packageList;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)packageListWithDict:(NSDictionary *)dict;
@end


@interface HNAPackageListItem : NSObject
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *packageId;
/**
 *  套餐名称
 */
@property (nonatomic,copy) NSString *packageName;

@end
