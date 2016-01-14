//
//  HNAImagePickersScrollView.h
//  MedicalNet
//
//  Created by gengliming on 16/1/14.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNAImagePickersScrollView : UIScrollView
/**
 *  父控件
 */
@property (nonatomic, weak) UIView *superContainer;
/**
 *  获取所有选择的图片
 */
@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *images;

+ (instancetype)imagePickersScrollView;
@end
