//
//  HNAExpenseDetailModel.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNAExpenseDetailStatusRecord,HNAExpenseDetailModel;

@interface HNAGetExpenseDetailResult : HNAResult
@property (nonatomic, strong) HNAExpenseDetailModel *expenseDetail;
@end


@interface HNAExpenseDetailModel : NSObject
/**
 *  花费总金额
 */
@property (nonatomic,copy) NSString *amount;
/**
 *   保险公司id
 */
@property (nonatomic,copy) NSString *insuranceCompanyId;
/**
 *  保险公司名称
 */
@property (nonatomic,copy) NSString *insuranceCompanyName;
/**
 *  申请人id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  申请人姓命
 */
@property (nonatomic,copy) NSString *name;
/**
 *  所属公司id
 */
@property (nonatomic,copy) NSString *companyId;
/**
 *   所属公司名称
 */
@property (nonatomic,copy) NSString *companyName;
/**
 *  联系方式
 */
@property (nonatomic,copy) NSString *phoneNum;
/**
 *  银行卡号
 */
@property (nonatomic,copy) NSString *cardNum;
/**
 *  身份证扫描件
 */
@property (nonatomic,strong) NSMutableArray *IDcard;
/**
 *  医保卡扫描件
 */
@property (nonatomic,strong) NSMutableArray *medicalCard;
/**
 *  就诊证明
 */
@property (nonatomic,strong) NSMutableArray *cases;
/**
 *  收费证明
 */
@property (nonatomic,strong) NSMutableArray *charges;
/**
 *  状态记录
 */
@property(nonatomic,strong) NSMutableArray<HNAExpenseDetailStatusRecord *> *statusRecords;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)expenseDetailWithDict:(NSDictionary *)dict;
@end

#pragma mark - 对应节点－statusRecords
@interface HNAExpenseDetailStatusRecord : NSObject
/**
 *  状态记录id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  状态更新日期
 */
@property (nonatomic,copy) NSString *date;
/**
 *  状态描述
 */
@property (nonatomic,copy) NSString *desc;
@end
