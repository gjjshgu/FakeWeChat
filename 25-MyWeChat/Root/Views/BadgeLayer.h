//
//  BadgeLayer.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/27.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BadgeLayer : CATextLayer




+ (instancetype)badgeWithNumString:(NSString *)string andPoint:(CGPoint)point;
- (instancetype)initWithNumString:(NSString *)string andPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
