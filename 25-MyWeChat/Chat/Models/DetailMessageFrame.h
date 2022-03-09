//
//  DetailMessageFrame.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/16.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#define kTextFont [UIFont systemFontOfSize:17]

NS_ASSUME_NONNULL_BEGIN
@class DetailMessage;

@interface DetailMessageFrame : NSObject <NSSecureCoding>

@property (nonatomic, strong) DetailMessage *message;
@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat rowHeight;

+ (instancetype)frameWithMessage:(DetailMessage *)message;
- (instancetype)initWithMessage:(DetailMessage *)message;

@end

NS_ASSUME_NONNULL_END
