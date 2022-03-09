//
//  MomentsDetailCell.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class MomentFrame;

@interface MomentsDetailCell : UITableViewCell
+ (instancetype)momentDetailCellWithTableView:(UITableView *)tableView andFrame:(MomentFrame *)frame;

@end

NS_ASSUME_NONNULL_END
