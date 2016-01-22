//
//  HNAGetExpenseDirectionResult.m
//  MedicalNet
//
//  Created by gengliming on 16/1/13.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAGetExpenseDirectionResult.h"

@implementation HNAGetExpenseDirectionResult

@end

@implementation HNAExpenseDirectionModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)directionWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (NSDictionary *)objectClassInArray {
    return @{ @"securityPrograms": [HNASecurityProgram class]};
}


@end


@implementation HNASecurityProgram
@end
