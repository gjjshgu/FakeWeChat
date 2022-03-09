//
//  MomentsTopCell.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TopData;

@interface MomentsTopCell : UITableViewCell

//@property (nonatomic, strong) TopData *cellData;

+ (instancetype)topCellWithTableView:(UITableView *)tableView andData:(nullable TopData *)data;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;


@end

NS_ASSUME_NONNULL_END
