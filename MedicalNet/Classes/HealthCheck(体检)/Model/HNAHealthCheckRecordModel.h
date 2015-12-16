//
//  HNACheckupRecordModel.h
//  MedicalNet
//
//  Created by gengliming on 15/11/26.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAHealthCheckRecordModel : NSObject
/**
 *  记录id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *packageId;
/**
 *  套餐名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  状态
 */
@property (nonatomic,copy) NSString *status;
/**
 *  预约日期
 */
@property (nonatomic,copy) NSString *date;

- (instancetype)initWithName:(NSString *)aName state:(NSString *)aState date:(NSString *)aDate;
+ (instancetype)healthCheckRecordWithName:(NSString *)aName state:(NSString *)aState date:(NSString *)aDate;
@end
