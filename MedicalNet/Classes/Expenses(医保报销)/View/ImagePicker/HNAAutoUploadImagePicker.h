//
//  HNAAutoUploadImagePicker.h
//  MedicalNet
//
//  Created by gengliming on 16/1/15.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

@class HNAAutoUploadImagePicker;

/**
 *  图片上传状态
 */
typedef NS_ENUM(NSInteger,HNAAutoUploadImagePickerUploadState) {
    // 默认
    HNAAutoUploadImagePickerUploadStateDefault,
    // 完成
    HNAAutoUploadImagePickerUploadStateCompleted,
    // 报错
    HNAAutoUploadImagePickerUploadStateFailed
};

@protocol HNAAutoUploadImagePickerDelegate <NSObject>
@optional
- (BOOL)autoUploadImagePickerWillSelectImage:(HNAAutoUploadImagePicker *)autoUploadImagePicker;
- (void)autoUploadImagePickerDidSelectImage:(HNAAutoUploadImagePicker *)autoUploadImagePicker;
- (void)autoUploadImagePickerDidRemoveImage:(HNAAutoUploadImagePicker *)autoUploadImagePicker;
@end

@interface HNAAutoUploadImagePicker : UIView
@property (nonatomic, weak) id<HNAAutoUploadImagePickerDelegate> delegate;
@property (nonatomic, assign) HNAAutoUploadImagePickerUploadState uploadState;

- (UIImage *)image;
+ (instancetype)autoUploadImagePicker;
@end
