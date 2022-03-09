//
//  DetailMessageFrame.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/16.
//

#import "DetailMessageFrame.h"
#import "DetailMessage.h"
#import <UIkit/UIkit.h>
#import "NSString+CountHeight.h"

@implementation DetailMessageFrame

- (void)setMessage:(DetailMessage *)message {
    _message = message;
//    获取屏幕宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    统一的间距
    CGFloat margin = 9;
//    计算时间label的frame
    CGFloat timeX = 0, timeY = 0;
    CGFloat timeW = screenWidth, timeH = 10;
    if (message.hideTime == NO) {
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
//    计算头像frame
    CGFloat iconW = 40, iconH = iconW;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + margin;
    CGFloat iconX = margin;
    if (message.messageWhose == DetailMessageMe) {
        iconX = screenWidth - iconW - margin;
    }
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
//    计算文本frame
//    1.先计算正文大小
    CGFloat maxW = screenWidth - 2 * iconW - 6 * margin;
    CGSize textSize = [message.text sizeOfTextWithMaxSize:CGSizeMake(maxW, MAXFLOAT) andFont:kTextFont];
//    2.再计算xy
    CGFloat textW = textSize.width + 35, textH = textSize.height + 35;
    CGFloat textY = iconY;
    CGFloat textX = CGRectGetMaxX(_iconFrame) + margin;
    if (message.messageWhose == DetailMessageMe) {
        textX = screenWidth - 2 * margin - iconW - textW;
    }
    _textFrame = CGRectMake(textX, textY, textW, textH);
//    计算行高
    CGFloat maxY = MAX(CGRectGetMaxY(_textFrame), CGRectGetMaxY(_iconFrame));
    _rowHeight = maxY + margin;
}
+ (instancetype)frameWithMessage:(DetailMessage *)message {
    return [[self alloc] initWithMessage:message];
}
- (instancetype)initWithMessage:(DetailMessage *)message {
    if (self = [super init]) {
        self.message = message;
    }
    return self;
}
#pragma mark - 归档解档
+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_message forKey:@"message"];
    [coder encodeCGRect:_timeFrame forKey:@"time_frame"];
    [coder encodeCGRect:_iconFrame forKey:@"icon_frame"];
    [coder encodeCGRect:_textFrame forKey:@"text_frame"];
    [coder encodeDouble:_rowHeight forKey:@"row_height"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _message = [coder decodeObjectForKey:@"message"];
        _timeFrame = [coder decodeCGRectForKey:@"time_frame"];
        _iconFrame = [coder decodeCGRectForKey:@"icon_frame"];
        _textFrame = [coder decodeCGRectForKey:@"text_frame"];
        _rowHeight = [coder decodeDoubleForKey:@"row_height"];
    }
    return self;
}
@end
