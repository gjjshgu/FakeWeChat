//
//  RootMessage.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Subscriber, LastMessage;
@interface RootMessage : NSObject

//@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *time;
//@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *text;
//@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) Subscriber *subscriber;
@property (nonatomic, assign) int newMessage;

+ (instancetype)messageWithLastMessage:(LastMessage *)message andSubscriber:(Subscriber *)subscriber;
- (instancetype)initWithLastMessage:(LastMessage *)message andSubscriber:(Subscriber *)subscriber;
@end

NS_ASSUME_NONNULL_END
