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
- (void)imagePickerViewDidClickPickerBtn:(HNAImagePickerView *)imagePickerView;
- (void)imagePickerViewDidClickRemoveBtn:(HNAImagePickerView *)imagePickerView;
@end

@interface HNAImagePickerView : UIView
@property(nonatomic,weak) id<HNAImagePickerViewDelegate> delegate;
@property(nonatomic,strong) IBOutlet UIView *view;
// 保存选择的图片
@property(nonatomic,strong) UIImage *image;
@end
