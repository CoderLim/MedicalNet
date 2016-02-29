//
//  LMLocalCache.h
//  MedicalNet
//
//  Created by gengliming on 16/1/22.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMLocalCache : NSObject

+ (instancetype)sharedLocalCache;
- (instancetype)initWithNamespace:(NSString *)ns;
/**
 *  获取NSDictionary
 */
- (NSDictionary *)dictFromDiskCacheForUrl:(NSString *)url andParams:(NSDictionary *)params;
- (NSDictionary *)dictFromDiskCacheForKey:(NSString *)key;
/**
 *  保存NSDictionary
 */
- (void)storeDict:(NSDictionary *)dict forUrl:(NSString *)url andParams:(NSDictionary *)params;
- (void)storeDict:(NSDictionary *)dict forKey:(NSString *)key;
/**
 *  清除磁盘缓存
 */
- (void)clearDisk;
- (void)clearDiskWithCompletionBlock:(void (^)())completion;

@end
