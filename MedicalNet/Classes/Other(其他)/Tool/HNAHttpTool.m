//
//  HNAHttpTool.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHttpTool.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "LMLocalCache.h"

@implementation HNAHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params toDisk:(BOOL)toDisk success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    // 1、先看是否本地有缓存
//    NSDictionary *diskCache = [[LMLocalCache sharedLocalCache] dictFromDiskCacheForUrl:url andParams:params];
//    if (diskCache && success) {
//        success(diskCache);
//        return;
//    }
    
    // 2、没有本地缓存，请求网络数据
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            if (responseObject && [[responseObject objectForKey:@"success"] isEqualToString:@"1"] && toDisk) {
                // 保存到本地
                [[LMLocalCache sharedLocalCache] storeDict:responseObject
                                                 forUrl:url
                                                 andParams:params];
            } else {
                [[LMLocalCache sharedLocalCache] clearDisk];
            }
            
            // 回调
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (HNAFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation HNAFormData
+ (instancetype)formDataWithImage:(UIImage *)image {
    HNAFormData *formData = [[HNAFormData alloc] init];
    formData.name = @"file";
    
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    if (data) {
        formData.data = data;
        formData.filename = [[[NSDate date] hna_stringWithFormat:@"yyyyMMddHHmmss"] stringByAppendingString:@".jpg"];
        formData.mimeType = @"image/jpeg";
    } else {
        formData.data = UIImagePNGRepresentation(image);
        formData.filename = [[[NSDate date] hna_stringWithFormat:@"yyyyMMddHHmmss"] stringByAppendingString:@".png"];
        formData.mimeType = @"image/png";
    }
    return formData;
}

+ (instancetype)formDataWithFilename:(NSString *)filename image:(UIImage *)image {
    HNAFormData *formData = [[HNAFormData alloc] init];
    formData.name = filename;
    
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    if (data) {
        formData.data = data;
        formData.filename = [[[NSDate date] hna_stringWithFormat:@"yyyyMMddHHmmss"] stringByAppendingString:@".jpg"];
        formData.mimeType = @"image/jpeg";
    } else {
        formData.data = UIImagePNGRepresentation(image);
        formData.filename = [[[NSDate date] hna_stringWithFormat:@"yyyyMMddHHmmss"] stringByAppendingString:@".png"];
        formData.mimeType = @"image/png";
    }
    return formData;
}

@end
