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

@interface HNADatePickButton : UIButton
@property(nonatomic,weak) id<HNADatePickButtonDelegate> delegate;
@end
