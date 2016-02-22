//
//  HNAResult.m
//  MedicalNet
//
//  Created by gengliming on 15/12/10.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAResult.h"

@implementation HNAResult
- (NSString *)description {
    return [NSString stringWithFormat:@"success=%ld,errorCode=%@,errorInfo=%@", (long)self.success, self.errorCode, self.errorInfo];
}
@end
