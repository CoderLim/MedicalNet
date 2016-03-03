//
//  UIView+HNA.h
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HNA)

/**
 *  view的左右震动动画
 *
 *  @param amplitudu 震动幅度
 */
- (void)hna_shakeWithAmplitude:(CGFloat)amplitudu;
/**
 *  获取view所属控制器
 */
- (UIViewController *)hna_viewController;

@end
