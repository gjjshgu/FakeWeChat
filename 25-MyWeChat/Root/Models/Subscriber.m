//
//  Subscriber.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/25.
//

#import "Subscriber.h"

#pragma mark - 初始化
@implementation Subscriber
+ (instancetype)subscriberWithName:(NSString *)name andAccount:(nullable NSString *)account andIcon:(UIImage *)icon{
    return [[self alloc] initWithName:name andAccount:account andIcon:icon];
}
- (instancetype)initWithName:(NSString *)name andAccount:(nullable NSString *)account andIcon:(UIImage *)icon{
    if (self = [super init]) {
        _name = name;
        _account = account;
        _icon = icon;
    }
    return self;
}

#pragma mark - 归档解档
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_account forKey:@"account"];
    [coder encodeObject:_icon forKey:@"icon"];
    NSLog(@"success");
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _name = [coder decodeObjectForKey:@"name"];
        _account = [coder decodeObjectForKey:@"account"];
        _icon = [coder decodeObjectForKey:@"icon"];
    }
    return self;
}
@end
