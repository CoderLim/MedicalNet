//
//  HNABadgeButton.m
//  MedicalNet
//
//  Created by gengliming on 15/12/18.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNABadgeButton.h"

@implementation HNABadgeButton

- (void)drawRect:(CGRect)rect{
    CGFloat radius = 5;
    CGFloat x = rect.size.width - 2 * radius;
    CGRect badgeRect = CGRectMake(x, 0, 2 * radius, 2 * radius);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor redColor] set];
    CGContextFillEllipseInRect(context, badgeRect);
}


@end
