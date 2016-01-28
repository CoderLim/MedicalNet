//
//  HNARightIconButton.m
//  MedicalNet
//
//  Created by gengliming on 16/1/28.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNARightArrowButton.h"
#import "UILabel+HNA.h"

#define ArrowWidth 20

@implementation HNARightArrowButton

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
    self.adjustsImageWhenHighlighted = NO;
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    self.direction = HNARightArrowButtonArrowDirectionUp;
}

#pragma mark - 
- (void)setDirection:(HNARightArrowButtonArrowDirection)direction {
    if (_direction == direction) {
        return;
    }
    _direction = direction;
    
    CGAffineTransform transform;
    if (_direction == HNARightArrowButtonArrowDirectionDown) {
        [self setTitle:@"展开" forState:UIControlStateNormal];
        transform = CGAffineTransformMakeRotation(-M_PI);
    } else {
        [self setTitle:@"收起" forState:UIControlStateNormal];
        transform = CGAffineTransformIdentity;
    }
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.imageView.transform = transform;
    }];
}

#pragma mark - 重写
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat w = ArrowWidth;
    CGFloat h = ArrowWidth;
    CGFloat x = contentRect.size.width - w;
    CGFloat y = (contentRect.size.height - h)*0.5;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.width-ArrowWidth;
    return CGRectMake(0, 0, w, contentRect.size.height);
}

@end
