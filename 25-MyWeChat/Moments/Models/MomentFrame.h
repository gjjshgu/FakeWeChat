//
//  MomentFrame.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#define kTextFont [UIFont systemFontOfSize:16.5]

NS_ASSUME_NONNULL_BEGIN
@class Moment;
@interface MomentFrame : NSObject

@property (nonatomic, strong) Moment* model;
// 头像按钮
@property (nonatomic, assign) CGRect iconButtonFrame;
// 用户名标签
@property (nonatomic, assign) CGRect nameLabelFrame;
// 正文标签
@property (nonatomic, assign) CGRect textLabelFrame;
// 时间标签
@property (nonatomic, assign) CGRect timeLabelFrame;
// 点赞按钮
@property (nonatomic, assign) CGRect likeButtonFrame;
// 分割线
@property (nonatomic, assign) CGRect lineFrame;
// 行高
@property (nonatomic, assign) CGFloat rowHeight;

+ (instancetype)frameWithMoment:(Moment *)moment;
- (instancetype)initWithMoment:(Moment *)moment;
@end

NS_ASSUME_NONNULL_END
