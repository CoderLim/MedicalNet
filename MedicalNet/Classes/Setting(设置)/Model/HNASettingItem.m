//
//  HNASettingItem.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNASettingItem.h"

@implementation HNASettingItem

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title{
    return [[self alloc] initWithTitle:title];
}

@end
