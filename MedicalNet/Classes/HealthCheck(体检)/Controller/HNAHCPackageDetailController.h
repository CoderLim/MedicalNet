//
//  HNAHCPackageDetailController.h
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 套餐详情

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HNAHCPackageDetailControllerType) {
    /**
     *  仅显示套餐详情
     */
    HNAHCPackageDetailControllerDisplay,
    /**
     *  除了显示还有“选择此套餐”功能
     */
    HNAHCPackageDetailControllerChoose
};

@interface HNAHCPackageDetailController : UIViewController

@property (nonatomic, assign) HNAHCPackageDetailControllerType type;
@property (nonatomic, copy) NSString *packageId;

@end
