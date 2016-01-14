//
//  HNAImagePickerView.h
//  MedicalNet
//
//  Created by gengliming on 15/11/24.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNAImagePickerView;

@protocol HNAImagePickerViewDelegate <NSObject>
@optional
- (void)imagePickerViewWillSelectImage:(HNAImagePickerView *)imagePickerView;
- (void)imagePickerViewDidSelectImage:(HNAImagePickerView *)imagePickerView;
- (BOOL)imagePickerViewWillRemoveImage:(HNAImagePickerView *)imagePickerView;
- (void)imagePickerViewDidRemoveImage:(HNAImagePickerView *)imagePickerView ;
- (void)imagePickerViewDidCancel:(HNAImagePickerView *)imagePickerView;
@end

@interface HNAImagePickerView : UIView
@property(nonatomic,strong) IBOutlet UIView *view;
@property(nonatomic,weak) id<HNAImagePickerViewDelegate> delegate;
/**
 *  选择的图片
 */
@property(nonatomic,strong) UIImage *image;

+ (instancetype)imagePicker;
@end
