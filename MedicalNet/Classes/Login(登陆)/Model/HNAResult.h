//
//  HNAResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HNARequestResult){
    HNARequestResultSUCCESS = 1,
    HNARequestResultFaild = 0
};

@interface HNAResult : NSObject
/**
 *  是否成功：1，成功  0，失败
 */
@property (nonatomic,assign) NSInteger success;

/**
 *  错误代码
 */
@property (nonatomic,copy) NSString *errorCode;

/**
 *  错误信息
 */
@property (nonatomic,copy) NSString *errorInfo;
@end
