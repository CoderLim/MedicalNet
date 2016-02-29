//
//  HNAGetPackageListResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取套餐列表

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNAPackageListItem;

@interface HNAGetPackageListResult : HNAResult

/**
 *  公司id
 */
@property (nonatomic,copy) NSString *companyId;
/**
 *  套餐列表
 */
@property(nonatomic,strong) NSMutableArray<HNAPackageListItem *> *packageList;

@end

@interface HNAPackageListItem : NSObject

/**
 *  套餐id
 */
@property (nonatomic,assign) NSInteger packageId;
/**
 *  套餐名称
 */
@property (nonatomic,copy) NSString *packageName;

@end
