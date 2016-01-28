//
//  HNAExpenseDetailModel.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetExpenseDetailResult.h"

@implementation HNAGetExpenseDetailResult

@end

@implementation HNAExpenseDetailModel
- (NSDictionary *)objectClassInArray {
    return @{@"statusRecords":[HNAExpenseDetailStatusRecord class]};
}
@end

@implementation HNAExpenseDetailStatusRecord

@end
