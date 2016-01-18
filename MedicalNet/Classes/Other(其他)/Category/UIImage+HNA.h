//
//  UIImage+HNA.h
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HNA)

- (instancetype)circleImageWithDiameter:(CGFloat)diameter;

/**
 *  根据机型适配
 */
+ (instancetype)imageWithName:(NSString *)name;
@end
