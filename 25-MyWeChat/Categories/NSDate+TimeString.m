//
//  NSDate+TimeString.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/26.
//

#import "NSDate+TimeString.h"

@implementation NSDate (TimeString)

- (NSString *)chatStringFormat{
//    日历对象
    NSCalendar *calender = [NSCalendar currentCalendar];
//    现在时间的年月日
    NSDateComponents *components = [calender components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
//    当前对象的年月日
    components = [calender components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:self];
    NSInteger msgYear = components.year;
    NSInteger msgMonth = components.month;
    NSInteger msgDay = components.day;
    NSInteger msgHour = components.hour;
//    判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        if (msgHour < 12) {
            dateFmt.dateFormat = @"上午 hh:mm";
        }else{
            dateFmt.dateFormat = @"下午 hh:mm";
        }
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{
        //昨天以前
        dateFmt.dateFormat = @"MM-dd HH:mm";
    }
//    返回处理后的结果
    return [dateFmt stringFromDate:self];
}
- (BOOL)isOneMinuteLaterWithLastTime:(NSDate *)time{
    return [[time chatStringFormat] isEqualToString:[self chatStringFormat]];
}
//- (NSString *)momentStringFormat {
//    NSCalendar *calender = [NSCalendar currentCalendar];
////    现在时间的年月日
//    NSDateComponents *components = [calender components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:[NSDate date]];
//    NSInteger currentYear = components.year;
//    NSInteger currentMonth = components.month;
//    NSInteger currentDay = components.day;
////    当前对象的年月日
//    components = [calender components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:self];
//    NSInteger msgYear = components.year;
//    NSInteger msgMonth = components.month;
//    NSInteger msgDay = components.day;
//    NSInteger msgHour = components.hour;
//    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
//
//    }
//}
@end
