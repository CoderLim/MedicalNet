//
//  HNAGetExpenseRecordsResult.h
//  MedicalNet
//
//  Created by gengliming on 16/1/13.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

// 获取报销记录

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNAExpenseRecordModel;

@interface HNAGetExpenseRecordsResult : HNAResult

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, strong) NSMutableArray<HNAExpenseRecordModel *> *records;

@end


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

@end
