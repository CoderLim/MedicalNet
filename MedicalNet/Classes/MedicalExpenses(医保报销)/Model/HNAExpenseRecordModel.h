//
//  HNAExpenseRecordModel.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAExpenseRecordModel : NSObject

/**
 *  记录id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  花费金额
 */
@property (nonatomic,copy) NSString *amount;
/**
 *  申请日期
 */
@property (nonatomic,copy) NSString *date;
/**
 *  状态
 */
@property (nonatomic,copy) NSString *status;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)recordeWithDict:(NSDictionary *)dict;

- (instancetype)initWithAmount:(NSString *)amount date:(NSString *)date state:(NSString*)state;
+ (instancetype)recordeWithAmount:(NSString *)amount date:(NSString *)date state:(NSString*)state;

@end
