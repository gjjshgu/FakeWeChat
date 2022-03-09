//
//  RootMessage.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/23.
//

#import "RootMessage.h"
#import "LastMessage.h"

@implementation RootMessage

+ (instancetype)messageWithLastMessage:(LastMessage *)message andSubscriber:(Subscriber *)subscriber {
    return [[self alloc] initWithLastMessage:message andSubscriber:subscriber];
}
- (instancetype)initWithLastMessage:(LastMessage *)message andSubscriber:(Subscriber *)subscriber {
    if (self = [super init]) {
        _text = message.text;
        _time = message.time;
        _subscriber = subscriber;
    }
    return self;
}

@end
