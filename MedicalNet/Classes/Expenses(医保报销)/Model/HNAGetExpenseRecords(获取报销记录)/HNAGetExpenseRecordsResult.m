//
//  HNAGetExpenseRecordsResult.m
//  MedicalNet
//
//  Created by gengliming on 16/1/13.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAGetExpenseRecordsResult.h"

@implementation HNAGetExpenseRecordsResult

- (NSDictionary *)objectClassInArray {
    return @{@"records":[HNAExpenseRecordModel class]};
}

@end

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
