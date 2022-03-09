//
//  MomentsDetailCell.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import "MomentsDetailCell.h"
#import "Moment.h"
#import "MomentFrame.h"
#import "myConfig.h"
#import "Subscriber.h"

@interface MomentsDetailCell ()
@property (nonatomic, strong) MomentFrame *momentFrame;
@property (nonatomic, weak) UIButton *iconButton;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *mainTextLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIButton *likeButton;
@end
@implementation MomentsDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        头像按钮
        UIButton *iconButton = [UIButton new];
        self.iconButton = iconButton;
        [self.contentView addSubview:iconButton];
//        昵称label
        UILabel *nameLabel = [UILabel new];
        self.nameLabel = nameLabel;
        nameLabel.textColor = USERNAME_BLUE_COLOR;
//        字体大小
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.5];
        [self.contentView addSubview:nameLabel];
//        正文label
        UILabel *mainTextLabel = [UILabel new];
        self.mainTextLabel = mainTextLabel;
//        颜色
        mainTextLabel.tintColor = [UIColor blueColor];
        mainTextLabel.font = kTextFont;
//        可以换行
        mainTextLabel.numberOfLines = 0;
        [self.contentView addSubview:mainTextLabel];
//        行间距
//        [mainTextLabel setValue:@20 forKey:@"lineSpacing"];
//        时间label
        UILabel *timeLabel = [UILabel new];
        self.timeLabel = timeLabel;
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:12.5];
        [self.contentView addSubview:timeLabel];
//        点赞按钮
        UIButton *likeButton = [UIButton new];
        likeButton.backgroundColor = [UIColor yellowColor];
        self.likeButton = likeButton;
        [likeButton setBackgroundImage:[UIImage imageNamed:@"like_comment"] forState:UIControlStateNormal];
        [self.contentView addSubview:likeButton];
//        分割线
        UIView *line = [UIView new];
        self.line = line;
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.4;
        [self.contentView addSubview:line];
//        ui控件属性设置
    }
    return self;
}

#pragma mark - 重写setter方法
- (void)setMomentFrame:(MomentFrame *)momentFrame {
    _momentFrame = momentFrame;
    Moment *model = momentFrame.model;
//    头像
    [self.iconButton setBackgroundImage:model.subscriber.icon forState:UIControlStateNormal];
    self.iconButton.frame = momentFrame.iconButtonFrame;
//    id
    self.nameLabel.text = model.subscriber.name;
    self.nameLabel.frame = momentFrame.nameLabelFrame;
//    正文
    self.mainTextLabel.text = model.text;
    self.mainTextLabel.frame = momentFrame.textLabelFrame;
//    时间
    self.timeLabel.text = model.time;
    self.timeLabel.frame = momentFrame.timeLabelFrame;
//    点赞按钮
    self.likeButton.frame = momentFrame.likeButtonFrame;
//    分割线
    self.line.frame = momentFrame.lineFrame;
    
}
#pragma mark - 类方法创建cell
+ (instancetype)momentDetailCellWithTableView:(UITableView *)tableView andFrame:(MomentFrame *)frame {
    static NSString *reuseID = @"moments_detail_cell";
    MomentsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[MomentsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.momentFrame = frame;
    return cell;
}
@end
