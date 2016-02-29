//
//  HNACountDownButton.h
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 可以倒计时的Button

#import <UIKit/UIKit.h>

@class HNACountDownButton;

@protocol HNACountDownButtonDelegate <NSObject>

@optional
- (void)buttonCountDownCompleted:(HNACountDownButton *)button;

@end

@interface HNACountDownButton : UIButton

@property(nonatomic,weak) id<HNACountDownButtonDelegate> delegate;
/**
 *  倒计时数
 */
@property (nonatomic,assign) IBInspectable NSInteger countNumber;

/**
 *  倒计时后的title
 */
@property (nonatomic,copy) IBInspectable NSString *titleAfterCountDown;

/**
 *  禁用时的背景色
 */
@property(nonatomic,strong) IBInspectable UIColor *disabledBackgroundColor;

@end
