//
//  HNAGetHCRecordsResult.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetHCRecordsResult.h"
#import "HNAHealthCheckRecordModel.h"

@implementation HNAGetHCRecordsResult

- (NSDictionary *)objectClassInArray {
    return @{ @"records" : [HNAHealthCheckRecordModel class]};
}

+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues {
    HNAGetHCRecordsResult *result = nil;
    if ((result = [super objectWithKeyValues:keyValues])) {
        result.hasNewProject = [[keyValues objectForKey:@"newProject"] integerValue];
    }
    return result;
}

@end
