//
//  HNAExpensesDirectionModel.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 医保报销说明

#import "HNAExpenseDirectionModel.h"

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

@end


@implementation HNASecurityProgram
@end

