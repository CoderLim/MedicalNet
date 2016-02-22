//
//  HNASetMsgNoticeParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNASetMsgNoticeParam : NSObject
/**
 *  用户id
 */
@property (nonatomic,assign) long long id;

/**
 *  体检通知：1=通知，0=不通知
 */
@property (nonatomic,copy) NSString *medicalNotice;

/**
 *  报销通知：1=通知，0=不通知
 */
@property (nonatomic,copy) NSString *expenseNotice;
@end
