//
//  ChatDetailCell.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DetailMessageFrame;

@interface ChatDetailCell : UITableViewCell
@property (nonatomic, strong) DetailMessageFrame *messageFrame;
+ (instancetype)detailCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
