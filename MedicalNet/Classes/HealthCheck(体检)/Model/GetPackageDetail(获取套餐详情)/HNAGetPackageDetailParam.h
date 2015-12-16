//
//  HNAGetPackageDetailParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 获取套餐详情

#import <Foundation/Foundation.h>

@interface HNAGetPackageDetailParam : NSObject
/**
 *  套餐id，通过“体检记录详情”接口获取
 */
@property (nonatomic,copy) NSString *id;
@end
