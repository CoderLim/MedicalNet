//
//  NSDate+HNA.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "NSDate+HNA.h"

@implementation NSDate (HNA)

+ (instancetype)hna_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.calendar = calendar;
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    
    return components.date;
}

+ (instancetype)hna_minimumDate{
    return [self hna_dateWithYear:1990 month:1 day:1 hour:0 minute:1 second:1];
}

- (NSDateComponents *)hna_components{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
    NSInteger unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |
                         NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    return [calendar components:unitFlag fromDate:self];
}

- (NSString *)hna_stringWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (BOOL)hna_isEqualYMDTo:(NSDate *)date {
    NSDateComponents *c1 = [self hna_components];
    NSDateComponents *c2 = [date hna_components];
    return c1.era == c2.era &&
           c1.year == c2.year &&
           c1.month == c2.month &&
           c1.day == c2.day;
}

+ (instancetype)hna_fromString:(NSString *)dateString withFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSInteger)hna_daysOfMonth:(NSInteger)month inYear:(NSInteger)year{
    if (month < 1 || month > 12 || year < 1990) {
        return 0;
    }
    switch (month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
            return 31;
            break;
        case 4:case 6:case 9:case 11:
            return 30;
            break;
        default:
            if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0){
                return 29;
            } else {
                return 28;
            }
            break;
    }
}

@end
