//
//  HNAExpenseRecordModel.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpenseRecordModel.h"

@implementation HNAExpenseRecordModel

- (instancetype)initWithAmount:(NSString *)amount date:(NSString *)date state:(NSString *)state{
    if (self = [super init]) {
        self.amount = amount;
        self.date = date;
        self.status = state;
    }
    return self;
}

+ (instancetype)recordeWithAmount:(NSString *)amount date:(NSString *)date state:(NSString *)state{
    return [[self alloc] initWithAmount:amount date:date state:state];
}

@end
