//
//  DetailMessage.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/16.
//

#import "DetailMessage.h"

@implementation DetailMessage

+ (instancetype)messageWithText:(NSString *)text andTime:(NSDate *)time andType:(DetailMessageType)type andWhose:(DetailMessageWhose)whose andIcon:(nonnull UIImage *)icon {
    return [[self alloc] initWithText:text andTime:time andType:type andWhose:whose andIcon:icon];
}
- (instancetype)initWithText:(NSString *)text andTime:(NSDate *)time andType:(DetailMessageType)type andWhose:(DetailMessageWhose)whose andIcon:(nonnull UIImage *)icon {
    if (self = [super init]) {
        _text = text;
        _time = time;
        _messageType = type;
        _messageWhose = whose;
        _icon = icon;
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_text forKey:@"text"];
    [coder encodeObject:_time forKey:@"time"];
    [coder encodeInt:_messageType forKey:@"message_type"];
    [coder encodeInt:_messageWhose forKey:@"message_whose"];
    [coder encodeObject:_icon forKey:@"icon"];
    [coder encodeBool:_hideTime forKey:@"hide_time"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _text = [coder decodeObjectForKey:@"text"];
        _time = [coder decodeObjectForKey:@"time"];
        _messageType = [coder decodeIntForKey:@"message_type"];
        _messageWhose = [coder decodeIntForKey:@"message_whose"];
        _icon = [coder decodeObjectForKey:@"icon"];
        _hideTime = [coder decodeBoolForKey:@"hide_time"];
    }
    return self;
}

@end
