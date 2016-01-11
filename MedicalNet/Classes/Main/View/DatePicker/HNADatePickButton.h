//
//  HNADatePickButton.h
//  MedicalNet
//
//  Created by gengliming on 15/12/15.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNADatePickButton;

@protocol HNADatePickButtonDelegate <NSObject>
@optional
- (void)datePickButton:(HNADatePickButton *)button didBeginSelectDate:(NSDate *)date;
- (void)datePickButton:(HNADatePickButton *)button dateChanged:(NSDate *)date;
- (void)datePickButton:(HNADatePickButton *)button didFinishSelectDate:(NSDate *)date;
@end

IB_DESIGNABLE
@interface HNADatePickButton : UIButton
@property(nonatomic,weak) IBOutlet id<HNADatePickButtonDelegate> delegate;
/**
 *  圆角
 */
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

/**
 *  边框 宽度
 */
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;

/**
 *  边框 颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end
