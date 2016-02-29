//
//  HNADatePickButton.m
//  MedicalNet
//
//  Created by gengliming on 15/12/15.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNADatePickButton.h"
#import "HNADatePicker.h"
#import "NSDate+HNA.h"

#define DatePickerHeight 162
#define ImageWidth 20
#define ImagePaddingRight 10

@interface HNADatePickButton() <HNADatePickerDelegate> {
    UIWindow *_originalKeyWindow;
}

@property (weak, nonatomic) UIView *mask;
@property (weak, nonatomic) HNADatePicker *datePicker;
@property (weak, nonatomic) UIView *pickerContainer;
@property (strong, nonatomic) UIWindow *window;

@end

@implementation HNADatePickButton

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
    // 基本属性
    [self setTitle:@"全部" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateDisabled];
    
    // 设置layer
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    // 设置图片
    [self setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.adjustsImageWhenHighlighted = NO;
    
    // 添加手势
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMySelf:)];
    [self addGestureRecognizer:tapRecognizer];
}

#pragma mark - 懒加载
- (UIWindow *)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] init];
        _window.frame = MainScreen.bounds;
        _window.backgroundColor = [UIColor clearColor];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWindow:)];
        [_window addGestureRecognizer:tap];
    }
    return _window;
}

- (UIView *)mask{
    if (_mask == nil) {
        UIView *mask = [[UIView alloc] initWithFrame:MainScreen.bounds];
        mask.backgroundColor = [UIColor blackColor];
        mask.alpha = 0.4f;
        [self.window addSubview:mask];
        _mask = mask;
    }
    return _mask;
}

- (UIView *)pickerContainer{
    if (_pickerContainer == nil) {
        // 0.创建container
        UIView *container = [[UIView alloc] init];
        container.backgroundColor = [UIColor whiteColor];
        container.layer.cornerRadius = 10;
        
        // 1.设置frame
        CGSize keyWinSize = MainScreen.bounds.size;
        container.frame = CGRectMake(0, keyWinSize.height, keyWinSize.width, DatePickerHeight);
        
        // 2.添加到的window上
        [self.window addSubview:container];
        [self.window bringSubviewToFront:container];
        _pickerContainer = container;
    }
    return _pickerContainer;
}

- (HNADatePicker *)datePicker{
    if (_datePicker == nil) {
        // 0.datePicker属性
        HNADatePicker *datePicker = [[HNADatePicker alloc] init];
        
        // 1.设置frame
        datePicker.frame = self.pickerContainer.bounds;
        
        // 2.添加到的window上
        [self.pickerContainer addSubview:datePicker];
        [self.pickerContainer bringSubviewToFront:datePicker];
        _datePicker = datePicker;
        
        datePicker.dpDelegate = self;
    }
    return _datePicker;
}

#pragma mark - 公开属性
- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

#pragma mark - 重写
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.layer.cornerRadius = 0.5*frame.size.height;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = contentRect.size.width - ImageWidth - ImagePaddingRight;
    CGFloat y = 0;
    return CGRectMake(x, y, ImageWidth, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.width - ImageWidth;
    return CGRectMake(ImagePaddingRight, 0, w, contentRect.size.height);
}

#pragma mark - 手势
- (void)tapMySelf:(UITapGestureRecognizer *)recognizer{
    // 记录原来的keyWindow
    _originalKeyWindow = KeyWindow;
    [self.window makeKeyAndVisible];
    
    // 设置mask
    self.mask.hidden = NO;
    self.pickerContainer.hidden = NO;
    
    // 动画
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:0.25f animations:^{
        // 1.设置pickerContainer的frame
        CGRect frame = weakSelf.pickerContainer.frame;
        frame.origin.y = MainScreen.bounds.size.height - DatePickerHeight;
        weakSelf.pickerContainer.frame = frame;
        
        // 2.重画datePicker
        [weakSelf.datePicker layoutIfNeeded];
        
        // 3.缩放原始window
        _originalKeyWindow.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        // 4.旋转向下箭头
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:nil];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(datePickButton:didBeginSelectDate:)]) {
        [self.delegate datePickButton:self didBeginSelectDate:self.datePicker.date];
    }
}

- (void)tapWindow:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.25f animations:^{
        // 设置pickerContainer的frame
        CGSize keyWinSize = MainScreen.bounds.size;
        CGRect frame = self.pickerContainer.frame;
        frame.origin.y = keyWinSize.height;
        self.pickerContainer.frame = frame;
        
        // 缩放原始window
        _originalKeyWindow.transform = CGAffineTransformIdentity;
        
        // 旋转箭头
        self.imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.mask.hidden = YES;
        [_originalKeyWindow makeKeyAndVisible];
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(datePickButton:didFinishSelectDate:)]) {
            [self.delegate datePickButton:self didFinishSelectDate:self.datePicker.date];
        }
    }];
}

#pragma mrak - HNADatePickerDelegate
- (void)datePicker:(HNADatePicker *)datePicker didValueChanged:(NSDate *)date {
    // 设置title
    NSString *title = @"全部";
    if (date != nil) {
        title = [date stringWithFormat:@"yyyy-MM"];

    }
    [self setTitle:title forState:UIControlStateNormal];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(datePickButton:dateChanged:)]) {
        [self.delegate datePickButton:self dateChanged:date];
    }
}

@end
