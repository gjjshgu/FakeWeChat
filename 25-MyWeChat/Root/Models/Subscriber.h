//
//  Subscriber.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage;
@interface Subscriber : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, strong) UIImage *icon;

+ (instancetype)subscriberWithName:(NSString *)name andAccount:(nullable NSString *)account andIcon:(UIImage *)icon;
- (instancetype)initWithName:(NSString *)name andAccount:(nullable NSString *)account andIcon:(UIImage *)icon;

@end

NS_ASSUME_NONNULL_END
