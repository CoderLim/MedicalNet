//
//  HNAGetPackageDetailResult.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetPackageDetailResult.h"

@implementation HNAGetPackageDetailResult

- (NSDictionary *)objectClassInArray {
    return @{@"records":[HNAPackageDetailItem class]};
}

@end


@implementation HNAPackageDetailItem

@end
