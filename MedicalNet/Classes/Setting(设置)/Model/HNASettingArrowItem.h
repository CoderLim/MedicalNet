//
//  HNASettingArrowItem.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNASettingItem.h"

@interface HNASettingArrowItem : HNASettingItem

// 待跳转的控制器
@property (nonatomic,assign) Class targetController;
// segue标志符
@property (nonatomic, copy) NSString *segueIdentifier;

@end
