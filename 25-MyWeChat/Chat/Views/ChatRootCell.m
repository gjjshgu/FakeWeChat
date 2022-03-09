//
//  ChatRootCell.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import "ChatRootCell.h"
#import "RootMessage.h"
#import "Subscriber.h"
#import "NSDate+TimeString.h"
#import "BadgeLayer.h"


@interface ChatRootCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@end
@implementation ChatRootCell



+ (instancetype)chatRootCellWithTableView:(UITableView *)tableView andMessage:(RootMessage *)message{
    static NSString *reuseID = @"chat_root_cell";
    ChatRootCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatRootCell" owner:nil options:nil] firstObject];
    }
//    添加小圆点
    if (message.newMessage != 0) {
        CGPoint point = CGPointMake(CGRectGetMaxX(cell.userImage.frame), CGRectGetMinY(cell.userImage.frame));
        BadgeLayer *badge = [BadgeLayer badgeWithNumString:[NSString stringWithFormat:@"%d", message.newMessage] andPoint:point];
        [cell.layer addSublayer:badge];
    }
//    设置属性
    cell.userImage.image = message.subscriber.icon;
    cell.userNameLabel.text = message.subscriber.name;
    cell.chatContentLabel.text = message.text;
    cell.lastTimeLabel.text = [message.time chatStringFormat];
    
    return cell;
}

@end
