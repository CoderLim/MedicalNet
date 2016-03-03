//
//  NSDate+HNA.h
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HNA)

/**
 *  用年月日时分秒初始化date
 */
+ (instancetype)hna_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
/**
 *  默认最小日期
 */
+ (instancetype)hna_minimumDate;
/**
 *  返回年月日时分秒
 */
- (NSDateComponents *)hna_components;
/**
 *  返回指定格式的日期字符串
 */
- (NSString *)hna_stringWithFormat:(NSString *)format;
/**
 *  字符串转日期
 *
 *  @param dateString 日期字符串
 *  @param format     格式
 *
 */
+ (instancetype)hna_fromString:(NSString *)dateString withFormat:(NSString *)format;
/**
 *  返回这个月份的天数
 */
+ (NSInteger)hna_daysOfMonth:(NSInteger)month inYear:(NSInteger)year;
/**
 *  年月日是否相同
 */
- (BOOL)hna_isEqualYMDTo:(NSDate *)date;

@end
