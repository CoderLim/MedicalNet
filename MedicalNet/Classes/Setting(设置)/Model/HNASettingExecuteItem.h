//
//  HNASettingExecuteItem.h
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNASettingItem.h"

typedef void(^HNASettingItemClick)();

@interface HNASettingExecuteItem : HNASettingItem

- (instancetype)initWithTitle:(NSString *)title option:(HNASettingItemClick)option;
+ (instancetype)itemWithTitle:(NSString *)title option:(HNASettingItemClick)option;

@property (nonatomic,copy) HNASettingItemClick option;

@end
