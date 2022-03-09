//
//  FriendCell.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Friend;
@interface FriendCell : UITableViewCell

+ (instancetype)friendCellWithTableView:(UITableView *)tableView andFriend:(Friend *)myFriend;

@end

NS_ASSUME_NONNULL_END
