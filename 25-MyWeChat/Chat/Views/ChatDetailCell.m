//
//  ChatDetailCell.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/15.
//

#import "ChatDetailCell.h"
#import "DetailMessageFrame.h"
#import "DetailMessage.h"
#import "NSDate+TimeString.h"

@interface ChatDetailCell ()
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIButton *iconView;
@property (nonatomic, weak) UIButton *textButton;

@end

@implementation ChatDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        创建子控件
//        显示时间的label
        UILabel *timeLabel = [UILabel new];
//        设置文字大小
        timeLabel.font = [UIFont systemFontOfSize:12];
//        设置文字居中
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLabel];
//        设置文字颜色
        timeLabel.textColor = [UIColor grayColor];
        _timeLabel = timeLabel;
//        显示头像的UIimageView
        UIButton *iconView = [UIButton new];
        [self.contentView addSubview:iconView];
        _iconView = iconView;
//        显示正文的按钮
        UIButton *textButton = [UIButton new];
        [self.contentView addSubview:textButton];
        _textButton = textButton;
//        修改正文字体颜色
        [textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        设置正文字体大小
        textButton.titleLabel.font = kTextFont;
//        设置可以换行
        textButton.titleLabel.numberOfLines = 0;
//        按钮内边距
        textButton.contentEdgeInsets = UIEdgeInsetsMake(20, 15, 30, 15);
    }
//    设置单元格透明
    self.backgroundColor = [UIColor clearColor];
    return self;
}
+ (instancetype)detailCellWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"chat_detail_cell";
    ChatDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[ChatDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}
#pragma mark - 重写setter方法
- (void)setMessageFrame:(DetailMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
//    获取数据模型
    DetailMessage *message = messageFrame.message;
//    分别设置每个子控件的数据
//    时间label
    self.timeLabel.text = [message.time chatStringFormat];
    self.timeLabel.frame = messageFrame.timeFrame;
    self.timeLabel.hidden = message.hideTime;
//    头像
//    self.iconView.imageView.image = message.icon;
    [self.iconView setBackgroundImage:message.icon forState:UIControlStateNormal];
    self.iconView.frame = messageFrame.iconFrame;
//    按钮
    [self.textButton setTitle:message.text forState:UIControlStateNormal];
    self.textButton.frame = messageFrame.textFrame;
//    设置正文背景图 （要根据是谁发的来选择背景图，所以放在下面而不是放在上面）
    NSString *backGroundImg = @"SenderTextNodeBkg", *backGroundImgHL = @"SenderTextNodeBkgHL";
    if (message.messageWhose == DetailMessageOther) {
        backGroundImg = @"ReceiverTextNodeBkg";
        backGroundImgHL = @"ReceiverTextNodeBkgHL";
    }
    UIImage *imgNor = [UIImage imageNamed:backGroundImg];
    UIImage *imgHL = [UIImage imageNamed:backGroundImgHL];
//    设置拉伸方式
    imgNor = [imgNor stretchableImageWithLeftCapWidth:imgNor.size.width / 2 topCapHeight:imgNor.size.height / 2];
    imgHL = [imgHL stretchableImageWithLeftCapWidth:imgHL.size.width / 2 topCapHeight:imgHL.size.height / 2];
    [self.textButton setBackgroundImage:imgNor forState:UIControlStateNormal];
    [self.textButton setBackgroundImage:imgHL forState:UIControlStateHighlighted];
}
@end
