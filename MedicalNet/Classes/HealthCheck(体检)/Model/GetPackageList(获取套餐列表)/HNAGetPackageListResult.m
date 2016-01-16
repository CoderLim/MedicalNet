//
//  HNAGetPackageListResult.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetPackageListResult.h"

@implementation HNAGetPackageListResult

- (NSDictionary *)objectClassInArray {
    return @{ @"packageList": [HNAPackageListItem class]};
}

@end


@implementation HNAPackageListItem

@end