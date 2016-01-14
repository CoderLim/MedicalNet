//
//  HNADatePicker.h
//  MedicalNet
//
//  Created by gengliming on 15/12/15.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 只包含年月的datePicker

#import <UIKit/UIKit.h>

@class HNADatePicker;

@protocol HNADatePickerDelegate <NSObject>
@optional
- (void)datePicker:(HNADatePicker *)datePicker didValueChanged:(NSDate *)date;
@end

@interface HNADatePicker : UIPickerView
@property (nonatomic, weak) id<HNADatePickerDelegate> dpDelegate;
@property (nonatomic,strong,readwrite) NSDate *maximumDate;
@property (nonatomic,strong,readwrite) NSDate *minimumDate;
/**
 *  当前日期
 */
@property (nonatomic,strong) NSDate *date;

@end
