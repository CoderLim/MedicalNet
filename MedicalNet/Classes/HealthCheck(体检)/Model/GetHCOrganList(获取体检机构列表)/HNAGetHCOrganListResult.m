//
//  HNAGetHCOrganListResult.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAGetHCOrganListResult.h"

@implementation HNAGetHCOrganListResult

- (NSDictionary *)objectClassInArray {
    return @{@"organList":[HNAHCOrgan class]};
}

@end

@implementation HNAHCOrgan

@end
