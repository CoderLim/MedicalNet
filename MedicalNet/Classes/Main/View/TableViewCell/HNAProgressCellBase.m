//
//  HNAProgressCellBase.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAProgressCellBase.h"
#define ProgressMarginToLeft 10
#define ProgressNormalColor [UIColor lightGrayColor]
#define ProgressSelectedColor [UIColor orangeColor]


#define ProgressCircleRadius 6
#define ProgressCircleLineWidth 1

#define ProgressLineWidth 1

@implementation HNAProgressCellBase

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
    self.positionType = HNAProgressCellPositionTypeDefault;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setPositionType:(HNAProgressCellPositionType)positionType {
    _positionType = positionType;
    // 强制刷新一次
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    // 画圆
    CGFloat cx = ProgressMarginToLeft-ProgressCircleRadius;
    CGFloat cy = rect.size.height*0.5-ProgressCircleRadius;
    CGFloat cw = 2*ProgressCircleRadius;
    CGFloat ch = 2*ProgressCircleRadius;
    CGRect cRect = CGRectMake(cx, cy, cw, ch);
    CGPathAddEllipseInRect(circlePath, nil, cRect);
    CGContextAddPath(context, circlePath);
    
    [ProgressNormalColor set];
    CGContextFillPath(context);
    
    // 如果是选中状态
    if (self.isSelected) {
        [ProgressSelectedColor set];
        CGContextSetLineWidth(context, ProgressCircleLineWidth);
        CGContextAddPath(context, circlePath);
        CGContextStrokePath(context);
    }
    
    // 裁剪
    CGPathAddRect(circlePath, nil, rect);
    CGContextAddPath(context, circlePath);
    CGContextEOClip(context);
    
    [ProgressNormalColor set];
    // 画线
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGFloat lx = ProgressMarginToLeft-0.5*ProgressLineWidth;
    CGFloat lbeginY = 0;
    CGFloat lendY = rect.size.height;
    
    if (self.positionType == HNAProgressCellPositionTypeBegin) {
        lbeginY = rect.size.height * 0.5;
    }
    
    if (self.positionType == HNAProgressCellPositionTypeEnd) {
        lendY = rect.size.height * 0.5;
    }
    
    CGPathMoveToPoint(linePath, nil, lx, lbeginY);
    CGPathAddLineToPoint(linePath, nil, lx, lendY);
    CGContextSetLineWidth(context, ProgressLineWidth);
    CGContextAddPath(context, linePath);
    CGContextStrokePath(context);
    
    CGPathRelease(circlePath);
    CGPathRelease(linePath);
}


@end
