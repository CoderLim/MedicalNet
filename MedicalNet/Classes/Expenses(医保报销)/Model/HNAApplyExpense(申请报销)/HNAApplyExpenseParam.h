//
//  HNAApplyExpenseModel.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAApplyExpenseParam : NSObject

+ (instancetype)param;

- (NSDictionary *)toDict;

/**
 *   保险公司id
 */
@property (nonatomic, assign) NSInteger insuranceCompanyId;
/**
 *  申请人id
 */
@property (nonatomic, assign) long long id;
/**
 *  申请人姓命
 */
@property (nonatomic, copy) NSString *name;
/**
 *  所属公司id
 */
@property (nonatomic, copy) NSString *companyId;
/**
 *   所属公司名称
 */
@property (nonatomic, copy) NSString *companyName;
/**
 *  联系方式
 */
@property (nonatomic, copy) NSString *phoneNum;
/**
 *  银行卡号
 */
@property (nonatomic, copy) NSString *cardNum;
/**
 *  身份证扫描件
 */
@property (nonatomic, strong) NSMutableArray *IDcards;
/**
 *  医保卡扫描件
 */
@property (nonatomic, strong) NSMutableArray *medicalCards;
/**
 *  就诊证明
 */
@property (nonatomic, strong) NSMutableArray *cases;
/**
 *  收费证明
 */
@property (nonatomic, strong) NSMutableArray *charges;

@end
