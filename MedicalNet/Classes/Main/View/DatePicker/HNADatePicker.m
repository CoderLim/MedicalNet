//
//  HNADatePicker.m
//  MedicalNet
//
//  Created by gengliming on 15/12/15.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNADatePicker.h"
#import "NSDate+HNA.h"

#define All @"全部"

@interface HNADatePicker() <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic) NSMutableArray *years;
@property (strong,nonatomic) NSMutableArray *months;
@end

@implementation HNADatePicker
@synthesize maximumDate = _maximumDate;
@synthesize minimumDate = _minimumDate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.delegate = self;
}


// 私有属性
- (NSMutableArray *)years{
    if (_years == nil) {
        _years = [NSMutableArray array];
        [self loadYears];
    }
    return _years;
}

- (NSMutableArray *)months{
    if (_months == nil) {
        _months = [NSMutableArray array];
        
        // 加载最小日期月份
        [self loadMonthsWithYear:self.years[0]];
    }
    return _months;
}

- (void)loadYears{
    [_years removeAllObjects];
    for (NSInteger i = self.minimumDate.hna_components.year; i <= self.maximumDate.hna_components.year; i++) {
        [_years addObject: [NSString stringWithFormat:@"%ld", i]];
    }
    [_years insertObject:All atIndex:0];
}

- (void)loadMonthsWithYear:(NSString *)yearStr{
    if ([yearStr isEqualToString:All]) {
        [_months removeAllObjects];
        return;
    }
    NSInteger year = [yearStr integerValue];
    NSInteger start = 1;
    NSInteger end = 12;
    if (year == self.minimumDate.hna_components.year) {
        start = self.minimumDate.hna_components.month;
    } else if (year == self.maximumDate.hna_components.year){
        end = self.maximumDate.hna_components.month;
    }
    
    [_months removeAllObjects];
    for (NSInteger i = start; i <= end; i++) {
        [_months addObject:@(i)];
    }
}

// 公开属性
- (NSDate *)maximumDate{
    if (_maximumDate == nil) {
        _maximumDate = [NSDate date];
    }
    return _maximumDate;
}
- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    
    [self loadYears];
}

- (NSDate *)minimumDate{
    if (_minimumDate == nil) {
        _minimumDate = [NSDate hna_minimumDate];
    }
    return _minimumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    [self loadYears];
}

- (NSDate *)date{
    if ([self.years[[self selectedRowInComponent:0]] isEqualToString:All]) {
        return nil;
    }
    NSInteger currentYear = [self.years[[self selectedRowInComponent:0]] integerValue];
    NSInteger currentMonth = [self.months[[self selectedRowInComponent:1]] integerValue];
    return [NSDate hna_dateWithYear:currentYear month:currentMonth day:1 hour:0 minute:1 second:1];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.years.count;
    } else if (component == 1){
        return self.months.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        if (row == 0) {
            return [NSString stringWithFormat:@"%@", self.years[row]];
        }
        return [NSString stringWithFormat:@"%@年", self.years[row]];
    } else if (component == 1){
        return [NSString stringWithFormat:@"%@月", self.months[row]];
    }
    return @"";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [self loadMonthsWithYear:self.years[[pickerView selectedRowInComponent:0]]];
        [pickerView reloadComponent:1];
    }
    // 通知代理
    if ([self.dpDelegate respondsToSelector:@selector(datePicker:didValueChanged:)]) {
        [self.dpDelegate datePicker:self didValueChanged:self.date];
    }
}

@end
