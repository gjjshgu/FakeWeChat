//
//  MomentsTopCell.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import "MomentsTopCell.h"
#import "TopData.h"
#import "Subscriber.h"

@interface MomentsTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MomentsTopCell


+ (instancetype)topCellWithTableView:(UITableView *)tableView andData:(nullable TopData *)data {
    static NSString *reuseID = @"top_cell";
    MomentsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentsTopCell" owner:nil options:nil] firstObject];
    }
//    设置参数
    cell.coverImgView.image = data.coverImg;
    [cell.coverImgView setContentMode:UIViewContentModeScaleAspectFill];
    cell.iconImgView.image = data.subscriber.icon;
    cell.nameLabel.text = data.subscriber.name;
    cell.nameLabel.textColor = [UIColor whiteColor];
    cell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    return cell;
}

@end
