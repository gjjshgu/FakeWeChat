//
//  LastMessage.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/26.
//

#import "LastMessage.h"

@implementation LastMessage
#pragma mark - 创建对象
+ (instancetype)messageWithText:(NSString *)text andTime:(NSDate *)time {
    return [[self alloc] initWithText:text andTime:time];
}
- (instancetype)initWithText:(NSString *)text andTime:(NSDate *)time {
    if (self = [super init]) {
        self.text = text;
        self.time = time;
    }
    return self;
}
#pragma mark - 归档解档
+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_text forKey:@"text"];
    [coder encodeObject:_time forKey:@"time"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _text = [coder decodeObjectForKey:@"text"];
        _time = [coder decodeObjectForKey:@"time"];
    }
    return self;
}

@end
