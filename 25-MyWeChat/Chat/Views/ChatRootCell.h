//
//  ChatRootCell.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RootMessage;

@interface ChatRootCell : UITableViewCell

+ (instancetype)chatRootCellWithTableView:(UITableView *)tableView andMessage:(RootMessage *)message;

@end

NS_ASSUME_NONNULL_END
