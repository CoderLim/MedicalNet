//
//  HNACountDownButton.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNACountDownButton.h"

@interface HNACountDownButton() {
    NSTimer *_timer;
    NSInteger _currentCountDownNumber;
    UIColor *_originalBackgroundColor;
}

@end

IB_DESIGNABLE
@implementation HNACountDownButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self addTarget:self action:@selector(SelfClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.countNumber = 60;
    self.disabledBackgroundColor = [UIColor lightGrayColor];
    self.titleAfterCountDown = @"重新获取";
}

#pragma mark 单击事件
- (void)SelfClicked{
    _currentCountDownNumber = self.countNumber;
    _originalBackgroundColor = self.backgroundColor;
    
    self.enabled = NO;
    [self setBackgroundColor:self.disabledBackgroundColor];
    [self setTitle:[NSString stringWithFormat:@"%lds", (long)_currentCountDownNumber]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - timer事件
- (void)timerCountDown{
    _currentCountDownNumber--;
    
    // 设置button的title
    NSString *title;
    if (_currentCountDownNumber >= 0) {
        title = [NSString stringWithFormat:@"%lds",(long)_currentCountDownNumber];
    } else {
        title = self.titleAfterCountDown;
        
        // 恢复状态
        [self setBackgroundColor:_originalBackgroundColor];
        self.enabled = YES;
        
        // 移除timer
        [_timer invalidate];
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(buttonCountDownCompleted:)]) {
            [self.delegate buttonCountDownCompleted:self];
        }
    }
    [self setTitle:title];
}

#pragma mark - 其他
- (void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

@end
