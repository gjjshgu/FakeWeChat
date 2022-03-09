//
//  Friend.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Subscriber;
@interface Friend : NSObject <NSSecureCoding>

@property (nonatomic, strong) Subscriber *subscriber;
// 字母开头
@property (nonatomic, copy) NSString *indexTitle;

+ (instancetype)friendWithSubscriber:(Subscriber *)subscriber;
- (instancetype)initWithSubscriber:(Subscriber *)subscriber;
@end

NS_ASSUME_NONNULL_END
