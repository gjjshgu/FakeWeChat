//
//  MomentFrame.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import "MomentFrame.h"
#import <UIkit/UIkit.h>
#import "Moment.h"
#import "NSString+CountHeight.h"


@implementation MomentFrame
# pragma mark - 重写setter方法
- (void)setModel:(Moment *)model {
    
//    model = _model;
    _model = model;
//    设置默认值
    CGFloat margin = 10, screenW = [UIScreen mainScreen].bounds.size.width;
//    头像frame
    CGFloat iconW = 40, iconH = iconW;
    CGFloat iconX = 1.4*margin, iconY = margin;
    self.iconButtonFrame = CGRectMake(iconX, iconY, iconW, iconH);
//    昵称label
    CGFloat nameW = screenW / 2 - CGRectGetMaxX(self.iconButtonFrame), nameH = 18;
    CGFloat nameX = CGRectGetMaxX(self.iconButtonFrame)+ margin, nameY = iconY;
    self.nameLabelFrame = CGRectMake(nameX, nameY, nameW, nameH);
//    正文label
//    先计算正文大小
    CGFloat maxW = screenW - CGRectGetMinX(self.nameLabelFrame) - 1.5*margin;
    CGSize textSize = [model.text sizeOfTextWithMaxSize:CGSizeMake(maxW, MAXFLOAT) andFont:kTextFont];
//    再计算xywh
    CGFloat textX = nameX, textY = CGRectGetMaxY(self.nameLabelFrame) + 0.8*margin;
    CGFloat textW = textSize.width, textH = textSize.height;
    self.textLabelFrame = CGRectMake(textX, textY, textW, textH);
//    时间label
    CGFloat timeW = 0.5 * screenW, timeH = 20;
    CGFloat timeX = textX, timeY = CGRectGetMaxY(self.textLabelFrame) + margin;
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeW, timeH);
//    点赞按钮
    CGFloat likeW = 33, likeH = timeH;
    CGFloat likeX = screenW - 1.5 * margin - likeW, likeY = timeY;
    self.likeButtonFrame = CGRectMake(likeX, likeY, likeW, likeH);
//    分割线
    CGFloat lineW = screenW, lineH = 0.5;
    CGFloat lineX = 0, lineY = CGRectGetMaxY(self.timeLabelFrame) + margin;
    self.lineFrame = CGRectMake(lineX, lineY, lineW, lineH);
//    行高
    self.rowHeight = CGRectGetMaxY(self.lineFrame);
}
# pragma mark - 创建对象方法
- (instancetype)initWithMoment:(Moment *)moment {
    if (self = [super init]) {
        self.model = moment;
    }
    return self;
}
+ (instancetype)frameWithMoment:(Moment *)moment {
    return [[self alloc] initWithMoment:moment];
}

@end
