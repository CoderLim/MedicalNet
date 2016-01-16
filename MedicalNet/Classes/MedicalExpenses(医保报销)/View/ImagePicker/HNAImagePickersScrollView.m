//
//  HNAImagePickersScrollView.m
//  MedicalNet
//
//  Created by gengliming on 16/1/14.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAImagePickersScrollView.h"
#import "HNAImagePickerView.h"

#define Margin 10
#define ImagePickerWidth (self.frame.size.height-2*Margin)

@interface HNAImagePickersScrollView() <HNAImagePickerViewDelegate>
@property (nonatomic, strong) NSMutableArray<HNAImagePickerView *> *imagePickers;
@end
@implementation HNAImagePickersScrollView

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
    // 设置ScrollView
    self.showsVerticalScrollIndicator = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    
    // 添加第一个imagePicker
    [self addImagePicker];
}

+ (instancetype)imagePickersScrollView {
    return [[HNAImagePickersScrollView alloc] init];
}

#pragma mark - life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentSize = CGSizeMake(self.imagePickers.count*(ImagePickerWidth+Margin), self.frame.size.height);
    for (NSInteger i=0; i<self.imagePickers.count; i++) {
        CGRect frame = CGRectMake(i*(ImagePickerWidth+Margin)+Margin, Margin, ImagePickerWidth, ImagePickerWidth);
        self.imagePickers[i].frame = frame;
    }
}

#pragma mark - 属性
- (NSMutableArray<HNAImagePickerView *> *)imagePickers {
    if (_imagePickers == nil) {
        _imagePickers = [NSMutableArray array];
    }
    return _imagePickers;
}

- (void)setSuperContainer:(UIView *)superContainer {
    _superContainer = superContainer;
    [_superContainer addSubview:self];
}

- (NSMutableArray<UIImage *> *)images {
    NSMutableArray<UIImage *> *array = [NSMutableArray array];
    for (HNAImagePickerView *ipv in self.imagePickers) {
        if (ipv.image != nil) {
            [array addObject:ipv.image];
        }
    }
    return array;
}

#pragma mark -
/**
 *  是否需要添加新的imagePicker
 */
- (BOOL)needAddNewImagePicker {
    for (HNAImagePickerView *imagePicker in self.imagePickers) {
        if (imagePicker.image == nil) {
            return NO;
        }
    }
    return YES;
}
/**
 *  添加新的imagePicker
 */
- (void)addImagePicker {
    HNAImagePickerView *imagePicker = [HNAImagePickerView imagePicker];
    imagePicker.delegate = self;
    [self.imagePickers addObject: imagePicker];
    [self addSubview: imagePicker];
    [self layoutIfNeeded];
}
/**
 *  移除imagePicker
 */
- (void)removeImagePicker:(HNAImagePickerView *)imagePicker {
    // 直有一个imagePicker时不操作
    if (self.imagePickers.count <= 1) {
        return;
    }
    [self.imagePickers removeObject:imagePicker];
    [imagePicker removeFromSuperview];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - HNAImagePickerViewDelegate
- (void)imagePickerViewDidSelectImage:(HNAImagePickerView *)imagePickerView {
    if ([self needAddNewImagePicker]) {
        [self addImagePicker];
    }
}

- (void)imagePickerViewDidRemoveImage:(HNAImagePickerView *)imagePickerView {
    [self removeImagePicker: imagePickerView];
}
@end
