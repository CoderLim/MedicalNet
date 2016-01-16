//
//  HNABadgeButton.m
//  MedicalNet
//
//  Created by gengliming on 15/12/18.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNABadgeButton.h"

@implementation HNABadgeButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.cornerRadius = 10;
    self.borderColor = [UIColor whiteColor];
    self.borderWidth = 1;
}

#pragma mark - 属性
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self layoutIfNeeded];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self layoutIfNeeded];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self layoutIfNeeded];
}

#pragma mark - life cycle
- (void)drawRect:(CGRect)rect{
    CGFloat radius = 5;
    CGFloat x = rect.size.width - 2 * radius;
    CGRect badgeRect = CGRectMake(x, 0, 2 * radius, 2 * radius);
    
    // 画圆点
    CGMutablePathRef badgePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(badgePath, nil, badgeRect);
    
    CAShapeLayer *badgeLayer = [CAShapeLayer layer];
    badgeLayer.path = badgePath;
    badgeLayer.fillColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:badgeLayer];
    CGPathRelease(badgePath);
    
    // 画边框
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef borderPath = CGPathCreateMutable();
    CGRect borderRect = CGRectInset(rect, 1, 1);
    CGPathAddRoundedRect(borderPath, nil, borderRect, self.cornerRadius, self.cornerRadius);
    CGContextAddPath(context, borderPath);
    [self.borderColor set];
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextStrokePath(context);
    CGPathRelease(borderPath);
}


@end
