//
//  MyProfileViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/21.
//

#import "MyProfileViewController.h"
#import "myConfig.h"
#import "Subscriber.h"
#import "TabBarController.h"

@interface MyProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (nonatomic, weak) Subscriber *me;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BASE_BACKGROUND_COLOR;
    TabBarController *controller = (TabBarController *)self.tabBarController;
    self.me = controller.me;
    self.iconView.image = self.me.icon;
    self.nameLabel.text = self.me.name;
    self.accountLabel.text = self.me.account;
    
}
#pragma mark - 发送网络请求
- (void)changeNameWithStr:(NSString *)string {
    self.nameLabel.text = string;
    self.me.name = string;
    NSDictionary *dict = @{
        @"type" : @"change_name",
        @"account" : self.me.account,
        @"name" : string
    };
    SEND_MESSAGE(dict);
}


#pragma mark - 提示框输入修改名字和微信号
- (void)reviseWithTitle:(NSString *)title{
    NSString *mainTitle = @"请输入新名字";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:mainTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //获取第1个输入框；
        UITextField *titleTextField = alertController.textFields.firstObject;
        [self changeNameWithStr:titleTextField.text];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //定义输入框
    [alertController addTextFieldWithConfigurationHandler:nil];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self reviseWithTitle:@"名字"];
    } else if (indexPath.row == 2) {
//        [self reviseWithTitle:@"微信号" andTarget:2];
    } else {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
