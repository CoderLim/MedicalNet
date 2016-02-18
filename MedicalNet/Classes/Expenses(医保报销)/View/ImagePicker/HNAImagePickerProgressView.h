//
//  HNAImagePickerProgressView.h
//  MedicalNet
//
//  Created by gengliming on 16/1/18.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelUpload)();

@interface HNAImagePickerProgressView : UIView
+ (instancetype)progressView;
@property (nonatomic, assign) float progress;
@property (nonatomic, copy) cancelUpload cancelUploadBlock;

- (void)show;
- (void)hide;
@end
