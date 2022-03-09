//
//  myTableViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import "myTableViewController.h"
#import "MyProfileViewController.h"
#import "TabBarController.h"
//#import "RootData.h"
#import "myConfig.h"
#import "Subscriber.h"

@interface myTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


@end

@implementation myTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BASE_BACKGROUND_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}
#pragma mark - 获取信息
- (void)getData {
    TabBarController *controller = (TabBarController *)self.tabBarController;
    self.nameLabel.text = controller.me.name;
    self.accountLabel.text = [NSString stringWithFormat:@"微信号：%@", controller.me.account];
}
#pragma mark - 调整组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    取消选中
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"my_profile"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
