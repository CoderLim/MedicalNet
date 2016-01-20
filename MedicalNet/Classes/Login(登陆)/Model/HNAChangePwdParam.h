//
//  HNAChangePwdParam.h
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAChangePwdParam : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *theOldPwd;
@property (nonatomic,copy) NSString *theNewPwd;

+ (instancetype)param;
@end
