//
//  CALayer+HNA.m
//  MedicalNet
//
//  Created by gengliming on 16/1/19.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "CALayer+HNA.h"

@implementation CALayer (HNA)
- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
@end
