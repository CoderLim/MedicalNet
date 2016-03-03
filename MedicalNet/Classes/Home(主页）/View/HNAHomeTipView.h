//
//  HNAHomeTipView.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TipViewElementClick)();

@interface HNAHomeTipView : UIView

+ (instancetype)tipViewWithChangeCipher:(TipViewElementClick)changeCipher;
/**
 *  父控件
 */
@property (nonatomic, weak) UIView *superViewDuplicate;
/**
 *   点击 修改密码
 */
@property (nonatomic,copy) TipViewElementClick changeCipher;

/**
 *  表示是否可用
 *
 *  如果修改过密码或者点过X号，则不显示tipView
 */
+ (BOOL)avaliable;
/**
 *  显示tipView
 */
- (void)show;

@end
