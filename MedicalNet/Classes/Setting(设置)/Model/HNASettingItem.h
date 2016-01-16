//
//  HNASettingItem.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNASettingItem : NSObject

// 标题
@property (nonatomic,copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;

@end
