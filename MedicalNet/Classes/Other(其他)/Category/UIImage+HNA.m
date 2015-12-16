//
//  UIImage+HNA.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "UIImage+HNA.h"

@implementation UIImage (HNA)

- (instancetype)circleImageWithDiameter:(CGFloat)diameter{
    // 1.图形上下文
    UIGraphicsBeginImageContext(CGSizeMake(diameter, diameter));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.剪切圆形画布
    CGRect rect = CGRectMake(0, 0, diameter, diameter);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    // 3.画图片
    [self drawInRect:rect];
    
    // 4.得到最终图片
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
