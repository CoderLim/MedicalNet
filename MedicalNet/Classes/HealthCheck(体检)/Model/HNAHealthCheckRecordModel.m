//
//  HNACheckupRecordModel.m
//  MedicalNet
//
//  Created by gengliming on 15/11/26.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHealthCheckRecordModel.h"

@implementation HNAHealthCheckRecordModel

- (instancetype)initWithName:(NSString *)aName state:(NSString *)aState date:(NSString *)aDate{
    if (self = [super init]) {
        self.name = aName;
        self.status = aState;
        self.date = aDate;
    }
    return self;
}

+ (instancetype)healthCheckRecordWithName:(NSString *)aName state:(NSString *)aState date:(NSString *)aDate{
    return [[self alloc] initWithName:aName state:aState date:aDate];
}


@end
