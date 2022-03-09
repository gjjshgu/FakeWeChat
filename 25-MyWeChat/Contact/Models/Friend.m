//
//  Friend.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/25.
//

#import "Friend.h"
#import "Subscriber.h"

@implementation Friend

#pragma mark - 创建方法
+ (instancetype)friendWithSubscriber:(Subscriber *)subscriber {
    return [[self alloc] initWithSubscriber:subscriber];
}
- (instancetype)initWithSubscriber:(Subscriber *)subscriber {
    if (self = [super init]) {
        self.subscriber = subscriber;
    }
    return self;
}
#pragma mark - 重写setter方法设置字母开头
- (void)setSubscriber:(Subscriber *)subscriber {
    _subscriber = subscriber;
    self.indexTitle = @"#";
    NSMutableString *source = [subscriber.name mutableCopy];
//    转换为拼音
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
//    去掉音标
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    unichar firstChar = [source characterAtIndex:0];
    NSString *firstPhonetic = [NSString stringWithFormat:@"%c", firstChar];
    NSString *re = @"[A-Za-z]";
    NSRange range = [firstPhonetic rangeOfString:re options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        self.indexTitle = [firstPhonetic uppercaseString];
    }
}
#pragma mark - 归档解档
+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_subscriber forKey:@"subscriber"];
    [coder encodeObject:_indexTitle forKey:@"index_title"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _subscriber = [coder decodeObjectForKey:@"subscriber"];
        _indexTitle = [coder decodeObjectForKey:@"index_title"];
    }
    return self;
}
@end
