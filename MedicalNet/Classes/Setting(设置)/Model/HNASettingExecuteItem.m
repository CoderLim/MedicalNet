//
//  HNASettingExecuteItem.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNASettingExecuteItem.h"

@implementation HNASettingExecuteItem

- (instancetype)initWithTitle:(NSString *)title option:(HNASettingItemClick)option{
    if (self = [super initWithTitle:title]) {
        self.option = option;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title option:(HNASettingItemClick)option{
    return [[self alloc] initWithTitle:title option:option];
}

@end
