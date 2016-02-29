//
//  HNAGetPackageListParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAGetPackageListParam : NSObject

+ (instancetype)param;
/**
 *  公司id，来自“登录接口”
 */
@property (nonatomic,copy) NSString *companyId;

@end
