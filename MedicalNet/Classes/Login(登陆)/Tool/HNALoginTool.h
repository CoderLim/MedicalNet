//
//  HNALoginTool.h
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNALoginInfoParam,HNALoginInfoResult;


@interface HNALoginTool : NSObject

/**
 *  登录验证
 *
 *  @param param   登录参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loginWithParam:(HNALoginInfoParam *)param success:(void(^)(HNALoginInfoResult *result))success failure:(void(^)(NSError *error))failure;

@end
