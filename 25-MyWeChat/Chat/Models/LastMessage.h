//
//  LastMessage.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LastMessage : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *time;

+ (instancetype)messageWithText:(NSString *)text andTime:(NSDate *)time;
- (instancetype)initWithText:(NSString *)text andTime:(NSDate *)time;

@end

NS_ASSUME_NONNULL_END
