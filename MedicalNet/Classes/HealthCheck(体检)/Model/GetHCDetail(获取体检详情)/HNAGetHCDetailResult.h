//
//  HNAGetHCDetailResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取体检详情

#import <Foundation/Foundation.h>

@class HNAHCStatusRecord,HNAHCAppointment;

@interface HNAGetHCDetailResult : NSObject

/**
 *  所选套餐id
 */
@property (nonatomic,copy) NSString *packageId;
/**
 *  套餐名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  该体检状态记录
 */
@property (nonatomic,strong) NSMutableArray<HNAHCStatusRecord *> *statusRecords;
/**
 *  预约
 */
@property(nonatomic,strong) HNAHCAppointment *appointment;
/**
 *  提醒信息
 */
@property (nonatomic,copy) NSString *alertMessage;

@end


@interface HNAHCStatusRecord : NSObject
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

/**
 *  用于控制显示样式
 */
@property (nonatomic, assign) BOOL isSelected;
@end

/**
 *  预约
 */
@interface HNAHCAppointment : NSObject
/**
 *  预约时间
 */
@property (nonatomic,copy) NSString *medicalTime;
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
@property (nonatomic,copy) NSString *openHours;
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
