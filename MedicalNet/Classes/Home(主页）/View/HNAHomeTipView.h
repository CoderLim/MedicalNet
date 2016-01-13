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
/**
 *  父控件
 */
@property (nonatomic, weak) UIView *superViewDuplicate;
/**
 *   点击 修改密码
 */
@property (nonatomic,copy) TipViewElementClick changeCipher;

/**
 *  初始化
 */
+ (instancetype)tipViewWithChangeCipher:(TipViewElementClick)changeCipher;
/**
 *  显示tipView
 */
- (void)show;
@end
