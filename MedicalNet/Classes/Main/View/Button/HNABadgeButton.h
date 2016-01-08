//
//  HNABadgeButton.h
//  MedicalNet
//
//  Created by gengliming on 15/12/18.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNABadgeButton : UIButton

/**
 *  边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

@end
