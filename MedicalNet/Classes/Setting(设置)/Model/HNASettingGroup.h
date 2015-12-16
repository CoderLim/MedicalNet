//
//  HNASettingGroup.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HNASettingItem;

@interface HNASettingGroup : NSObject

@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *footer;
@property (nonatomic,copy) NSArray *items;

@end
