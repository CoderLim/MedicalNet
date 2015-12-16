//
//  HNAPackageButtonScrollView.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAPackageButtonScrollView.h"
#define Padding 10
#define Height 80
#define Width 80

@interface HNAPackageButtonScrollView()

@end
@implementation HNAPackageButtonScrollView
#pragma mark - 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

#pragma mark - 添加数据
- (void)setItems:(NSMutableArray *)items{
    _items = items;
    
    NSInteger count = items.count;
    // 计算conentSize
    CGFloat contentWidth = (Width + Padding) * count;
    CGSize contentSize = CGSizeMake(contentWidth, Height);
    self.contentSize = contentSize;
    
    // 添加items到scrollView
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = items[i];
        [self addItem:button withIndex:i];
    }
    
    [self layoutIfNeeded];
}

- (void)addItem:(UIButton *)button{
    [self.items addObject:button];
    
    // 计算contentSize
    CGSize contentSize = self.contentSize;
    contentSize.width += Width + Padding;
    self.contentSize = contentSize;
    
    // 添加button
    NSInteger index = self.items.count - 1;
    [self addItem:button withIndex:index];
}

- (void)addItem:(UIButton *)button withIndex:(NSInteger)index{
    // 计算frame
    CGFloat x = index * (Width + Padding);
    CGFloat w = Width;
    CGFloat h = Height;
    CGRect frame = CGRectMake(x, 0, w, h);
    
    // 设置标签
    button.tag = index;
    button.frame = frame;
    [self addSubview:button];
    
    // 添加事件
    [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 单击事件
- (void)itemClicked:(UIButton *)sender{
    HNALog(@"%s tag=%ld", __FUNCTION__, sender.tag);
    if ([self.delegate respondsToSelector:@selector(packageButtonScrollView:didClickedAtIndex:)]) {
        [self.delegate packageButtonScrollView:self didClickedAtIndex:sender.tag];
    }
}
@end
