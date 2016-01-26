//
//  HNAForgetPwdParam.h
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAForgetPwdParam : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *theNewPwd;

+ (instancetype)param;
@end
