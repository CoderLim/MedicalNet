//
//  HNAUserTool.m
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAUserTool.h"
#import "HNAHttpTool.h"
#import "HNAResult.h"
#import "HNAChangePhoneParam.h"
#import "HNAChangePortraitParam.h"
#import "HNAChangePwdParam.h"
#import "HNAForgetPwdParam.h"
#import "HNASetMsgNoticeParam.h"
#import "MJExtension.h"

// 账号信息保存路径
#define HNAUserFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]
//账号过期时间：10天
#define AccountExpiresIn 60*60*24*10

@implementation HNAUserTool

/**
 *  归档
 */

+ (HNAUser *)user{
    HNAUser *u = [NSKeyedUnarchiver unarchiveObjectWithFile:HNAUserFile];
    if (u.expiresTime == nil || [u.expiresTime compare:[NSDate date]] == NSOrderedAscending) {
        return nil;
    }
    return u;
}

+ (void)saveUser:(HNAUser *)user{
    if (user != nil) {
        user.expiresTime = [[NSDate date] dateByAddingTimeInterval:AccountExpiresIn];
        [NSKeyedArchiver archiveRootObject:user toFile:HNAUserFile];
    }
}

/**
 *  网络请求
 */

// 修改手机号
+ (void)changePhoneWithParam:(HNAChangePhoneParam *)param success:(void (^)(HNAResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/changePhoneNum", RequestUrlDomain];
    
    //将参数转化成字典
    NSDictionary *paramDict = @{@"id" : param.id,
                                @"newPhoneNum" : param.theNewPhoneNum};
    
    [HNAHttpTool postWithURL:urlStr params:paramDict toDisk:NO success:^(id json) {
        if (success) {
            HNAResult *result = [HNAResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 修改头像
+ (void)changePortraitWithParam:(HNAChangePortraitParam *)param success:(void (^)(HNAResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/changeIcon", RequestUrlDomain];
    // 将参数转化成字典
    NSDictionary *paramDict = @{@"id" : param.id};
    // 图片
    HNAFormData *data = [HNAFormData formDataWithImage:param.theNewIcon];
    
    NSArray *formDataArray = @[data];
    // post
    [HNAHttpTool postWithURL:urlStr params:paramDict formDataArray:formDataArray  success:^(id json) {
        if (success) {
            HNAResult *result = [HNAResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

// 修改密码
+ (void)changePwdWithParam:(HNAChangePwdParam *)param success:(void (^)(HNAResult *result))success failure:(void (^)(NSError *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/changePwd", RequestUrlDomain];
    
    //将参数转化成字典
    NSDictionary *paramDict = @{@"id" : param.id,
                                @"newPwd" : param.theNewPwd,
                                @"oldPwd" : param.theOldPwd};
    
    [HNAHttpTool postWithURL:urlStr params:paramDict toDisk:NO success:^(id json) {
        if (success) {
            HNAResult *result = [HNAResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)forgetPwdWithParam:(HNAForgetPwdParam *)param success:(void (^)(HNAResult *))success failure:(void (^)(NSError *))failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/forgetPwd", RequestUrlDomain];
    
    //将参数转化成字典
    NSDictionary *paramDict = @{@"id" : param.id,
                                @"newPwd" : param.theNewPwd};
    
    [HNAHttpTool postWithURL:urlStr params:paramDict toDisk:NO success:^(id json) {
        if (success) {
            HNAResult *result = [HNAResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 设置消息提醒
+ (void)setMsgNoticeWithParam:(HNASetMsgNoticeParam *)param success:(void (^)(HNAResult *))success failure:(void (^)(NSError *))failure{
    // 地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/MsgNotice", RequestUrlDomain];
    // 请求
    NSLog(@"%@",param.keyValues);
    [HNAHttpTool postWithURL:urlStr params:param.keyValues toDisk:NO success:^(id json) {
        if (success) {
            HNAResult *result = [HNAResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
@end
