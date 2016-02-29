//
//  HNAImagePickersScrollView.h
//  MedicalNet
//
//  Created by gengliming on 16/1/14.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNAImagePickersScrollView;

@protocol HNAImagePickersScrollViewDelegate <NSObject>

@optional
- (BOOL)imagePickersScrollViewWillSelectImage:(HNAImagePickersScrollView *)imagePickerScrollView;

@end

@interface HNAImagePickersScrollView : UIScrollView

+ (instancetype)imagePickersScrollView;
/**
 *  代理
 */
@property (nonatomic, weak) IBOutlet id<HNAImagePickersScrollViewDelegate> ipsvDelegate;
/**
 *  父控件
 */
@property (nonatomic, weak) UIView *superContainer;
/**
 *  获取所有选择的图片
 */
@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *images;
@property (nonatomic, strong, readonly) NSMutableArray *imageUrls;

@end
