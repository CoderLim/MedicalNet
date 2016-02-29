//
//  HNAGetHCDetailResult.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetHCDetailResult.h"

@implementation HNAGetHCDetailResult

- (NSDictionary *)objectClassInArray {
    return @{@"statusRecords":[HNAHCStatusRecord class]};
}

@end


@implementation HNAHCAppointment

- (NSString *)phone {
    
    if (_phone == nil) {
        return @"10086";
    }
    return _phone;
}

@end


@implementation HNAHCStatusRecord

@end
