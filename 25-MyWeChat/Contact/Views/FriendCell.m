//
//  FriendCell.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/25.
//

#import "FriendCell.h"
#import "Friend.h"
#import "Subscriber.h"

@interface FriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FriendCell

+ (instancetype)friendCellWithTableView:(UITableView *)tableView andFriend:(Friend *)myFriend {
    static NSString *reuseID = @"friend_cell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:nil options:nil] firstObject];
        cell.nameLabel.text = myFriend.subscriber.name;
        cell.iconView.image = myFriend.subscriber.icon;
    }
    return cell;
}


@end
