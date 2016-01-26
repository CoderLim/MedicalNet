//
//  HNAGetPackageDetailResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取套餐详情

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNAPackageDetailItem;

@interface HNAGetPackageDetailResult : HNAResult
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *packageId;
/**
 *  套餐名称
 */
@property (nonatomic,copy) NSString *packageName;
/**
 *  体检项目
 */
@property(nonatomic,strong) NSMutableArray<HNAPackageDetailItem *> *records;
@end

//体检套餐项目
@interface HNAPackageDetailItem : NSObject
/**
 *  体检项目名称
 */
@property (nonatomic,copy) NSString *item;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *desc;
@end
