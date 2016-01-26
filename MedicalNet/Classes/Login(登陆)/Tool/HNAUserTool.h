//
//  HNAUserTool.h
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNAChangePwdParam,HNAResult,HNAChangePhoneParam,HNAChangePortraitParam,HNASetMsgNoticeParam;
@class HNAForgetPwdParam;

@interface HNAUserTool : NSObject

/**
 *    归档
 */
+ (HNAUser *)user;
+ (void)saveUser:(HNAUser *)user;

/**
 *  通过id获取用户信息
 *
 *  @param id      用户id
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 */
+ (void)getUserById:(NSString *)id success:(void(^)(HNAUser *user))success failure:(void(^)(NSError *error))failure;

/**
 *  修改密码
 *
 *  @param param   修改密码需要提供的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)changePwdWithParam:(HNAChangePwdParam *)param success:(void(^)(HNAResult *))success failure:(void(^)(NSError *error))failure;

/**
 *  修改密码
 *
 *  @param param   修改密码需要提供的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)forgetPwdWithParam:(HNAForgetPwdParam *)param success:(void(^)(HNAResult *))success failure:(void(^)(NSError *error))failure;

/**
 *  修改手机号
 *
 *  @param param   修改手机号需要提供的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)changePhoneWithParam:(HNAChangePhoneParam *)param success:(void(^)(HNAResult *))success failure:(void(^)(NSError *error))failure;

/**
 *  修改头像
 *
 *  @param param   需要的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)changePortraitWithParam:(HNAChangePortraitParam *)param success:(void(^)(HNAResult *))success failure:(void(^)(NSError *error))failure;

/**
 *  设置消息提醒
 *
 *  @param param   需要提供的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)setMsgNoticeWithParam:(HNASetMsgNoticeParam *)param success:(void(^)(HNAResult *))success failure:(void(^)(NSError *error))failure;
@end
