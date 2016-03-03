//
//  UIImage+HNA.h
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HNA)

/**
 *  剪切成圆形图片
 *
 *  @param diameter 直径
 *
 *  @return 裁剪后的圆形图片
 */
- (instancetype)hna_circleImageWithDiameter:(CGFloat)diameter;
/**
 *  根据机型适配
 */
+ (instancetype)hna_imageWithName:(NSString *)name;
/**
 *  生成纯色图片
 */
+ (instancetype)hna_imageWithColor:(UIColor *)color andSize:(CGSize)size;

@end
