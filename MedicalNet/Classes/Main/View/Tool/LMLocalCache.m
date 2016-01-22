//
//  LMLocalCache.m
//  MedicalNet
//
//  Created by gengliming on 16/1/22.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "LMLocalCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface LMLocalCache() {
    NSFileManager *_fileManager;
}
@property (nonatomic, copy) NSString *diskCachePath;
@property (nonatomic, strong) dispatch_queue_t ioQueue;
@end
@implementation LMLocalCache

+ (instancetype)sharedLocalCache {
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    return [self initWithNamespace:@"default"];
}

- (instancetype)initWithNamespace:(NSString *)ns {
    if (self = [super init]) {
        NSString *fullNamespace = [@"com.glm.LMLocalCache." stringByAppendingString:ns];
        self.diskCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fullNamespace];
        
        self.ioQueue = dispatch_queue_create("com.glm.LMLocalCache", DISPATCH_QUEUE_SERIAL);
        
        dispatch_sync(self.ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
    }
    return self;
}

#pragma mark LMLocalCache (private)
- (NSString *)keyForUrl:(NSString *)url andParams:(NSDictionary *)params {
    NSParameterAssert(url);
    NSParameterAssert(params);
    NSMutableString *key = [NSMutableString string];
    [key appendString:url];
    for (id p in params) {
        [key appendFormat:@"%@%@",p, [params objectForKey:p]];
    }
    return key;
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

#pragma mark 
- (void)storeDict:(NSDictionary *)dict forUrl:(NSString *)url andParams:(NSDictionary *)params {
    
    [self storeDict:dict forKey:[self keyForUrl:url andParams:params]];
}

- (void)storeDict:(NSDictionary *)dict forKey:(NSString *)key {
    if (!dict || !key) {
        return;
    }
    dispatch_async(self.ioQueue, ^{
        if (![_fileManager fileExistsAtPath:self.diskCachePath]) {
            [_fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [_fileManager createFileAtPath:[self defaultCachePathForKey:key] contents:[NSData data] attributes:nil];
        
        // 将字典写入到文件
        [dict writeToFile:[self defaultCachePathForKey:key] atomically:YES];
    });
}

- (NSDictionary *)dictFromDiskCacheForUrl:(NSString *)url andParams:(NSDictionary *)params {
    return [self dictFromDiskCacheForKey:[self keyForUrl:url andParams:params]];
}

- (NSDictionary *)dictFromDiskCacheForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [NSDictionary dictionaryWithContentsOfFile:[self defaultCachePathForKey:key]];
}

- (void)clearDisk {
    [self clearDiskWithCompletionBlock:nil];
}

- (void)clearDiskWithCompletionBlock:(void(^)())completion {
    dispatch_async(self.ioQueue, ^{
        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

@end
