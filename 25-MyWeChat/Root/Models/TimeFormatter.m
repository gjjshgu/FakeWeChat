//
//  TimeFormatter.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/27.
//

#import "TimeFormatter.h"
#import "myConfig.h"

static TimeFormatter *_formatter;

@implementation TimeFormatter
+ (instancetype)defaultFormatter {
//    用gcd创建单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[self alloc] init];
        _formatter.dateFormat = DATE_FORMAT_RULE;
    });
    return _formatter;
}
@end
