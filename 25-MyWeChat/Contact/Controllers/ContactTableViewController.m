//
//  ContactTableViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import "ContactTableViewController.h"
#import "Subscriber.h"
#import "myConfig.h"
#import "TabBarController.h"
#import "NSDictionary+ToJson.h"
#import "ChatDetailViewController.h"
#import "SVProgressHUD.h"
#import "Friend.h"
#import "FriendCell.h"



@interface ContactTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSArray<Friend *> *defaultFriend;

@property (nonatomic, strong) NSMutableArray<Friend *> *realFriend;

@property (nonatomic, strong) NSMutableArray<NSMutableArray<Friend *> *> *groupedFriend;

@property (nonatomic, strong) NSMutableArray<NSString *> *indexTitles;

@property (nonatomic, strong) NSMutableDictionary<NSString *, Subscriber *> *contactDict;

@property (nonatomic, strong) Subscriber *me;

@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 55;
    [self addSearchBar];
    [self makeGrouped];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:141/255 green:141/255 blue:146/255 alpha:0.6];
    self.tableView.backgroundColor = BASE_BACKGROUND_COLOR;

//    监听添加好友信息
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addFriendWithDict:) name:@"add_friend" object:nil];
}
- (void)dealloc {
//    一定要在dealloc中移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 联系人归档保存
- (void)saveContact {
    NSData *contactData = [NSKeyedArchiver archivedDataWithRootObject:self.contactDict requiringSecureCoding:YES error:nil];
    [[NSFileManager defaultManager] createFileAtPath:CONTACT_PATH contents:contactData attributes:nil];
}
#pragma mark - 添加好友
- (IBAction)addClicked:(id)sender {
    NSString *mainTitle = [NSString stringWithFormat:@"请输入对方微信号"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:mainTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //获取第1个输入框；
        UITextField *titleTextField = alertController.textFields.firstObject;
        [self addFriendWithAccount:titleTextField.text];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //定义第一个输入框
    [alertController addTextFieldWithConfigurationHandler:nil];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)addFriendWithAccount:(NSString *)account {
    if (account.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"不能为空"];
        return;
    }
    if ([account isEqualToString:self.me.account]) {
        [SVProgressHUD showErrorWithStatus:@"不能加自己为好友"];
        return;
    }
    if ([self.contactDict objectForKey:account] != nil) {
        [SVProgressHUD showErrorWithStatus:@"你已添加该好友"];
        return;
    }
    NSDictionary *dict = @{
        @"type" : @"add_friend",
        @"account" : account
    };
    SEND_MESSAGE(dict);
}
- (void)addFriendWithDict:(NSNotification *)noteInfo {
    NSDictionary *dict = noteInfo.userInfo;

    if ([dict[@"is_success"] isEqualToString:@"yes"]) {
        UIImage *defaultImg = [UIImage imageNamed:@"default_avater"];
        Subscriber *newSubscriber = [Subscriber subscriberWithName:dict[@"username"] andAccount:dict[@"account"] andIcon:defaultImg];
        Friend *newFriend = [Friend friendWithSubscriber:newSubscriber];
//        添加
        [self.contactDict setValue:newSubscriber forKey:dict[@"account"]];
        
        [self.realFriend addObject:newFriend];
//        更新组
        [self makeGrouped];
//        保存联系人
        [self saveContact];
//        刷新列表
        [self.tableView reloadData];
    }else {
        [SVProgressHUD showErrorWithStatus:@"找不到该联系人"];
    }
}
#pragma mark - 列表懒加载
- (NSArray<Friend *> *)defaultFriend {
    if (_defaultFriend == nil) {
        NSArray *titles = @[@"新的朋友",
                            @"群聊",
                            @"标签",
                            @"公众号"];
        NSArray *images = @[@"plugins_FriendNotify",
                            @"add_friend_icon_addgroup",
                            @"Contact_icon_ContactTag",
                            @"add_friend_icon_offical"];
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0; i < titles.count; i++) {
            UIImage *modelImg = [UIImage imageNamed:images[i]];
            Subscriber *defaultSubscriber = [Subscriber subscriberWithName:titles[i] andAccount:nil andIcon:modelImg];
            Friend *model = [Friend friendWithSubscriber:defaultSubscriber];
            [tmp addObject:model];
        }
        _defaultFriend = [NSArray arrayWithArray:tmp];
    }
    return _defaultFriend;
}

- (NSMutableArray<Friend *> *)realFriend {
    if (_realFriend == nil) {
        TabBarController *con = (TabBarController *)self.tabBarController;
        _me = con.me;
        _contactDict = con.contactDict;
        NSMutableArray *realFriend = [NSMutableArray array];
        for (Subscriber *model in [_contactDict allValues]) {
            [realFriend addObject:[Friend friendWithSubscriber:model]];
        }
        _realFriend = realFriend;
    }
    return _realFriend;
}
#pragma mark - 分组
- (void)makeGrouped {
    _groupedFriend = [NSMutableArray arrayWithObject:self.defaultFriend];
//        添加搜索logo
    _indexTitles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    
    NSMutableArray *others = [NSMutableArray arrayWithArray:self.realFriend];
    for (char ch = 'A'; ch <= 'Z'; ch++) {
        NSString *indexTitle = [NSString stringWithFormat:@"%c", ch];
        NSMutableArray *indexes = [NSMutableArray array];
        for (Friend *model in self.realFriend) {
            if ([model.indexTitle isEqualToString:indexTitle]) {
                [indexes addObject:model];
                [others removeObject:model];
            }
        }
//        如果存在则加一组
        if (indexes.count > 0) {
            [_indexTitles addObject:indexTitle];
            [_groupedFriend addObject:indexes];
        }
    }
    if (others.count > 0) {
        [_indexTitles addObject:@"#"];
        [_groupedFriend addObject:others];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedFriend.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.defaultFriend.count;
    }
    return self.groupedFriend[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [FriendCell friendCellWithTableView:tableView andFriend:self.defaultFriend[indexPath.row]];
    } else {
        Friend *model = self.groupedFriend[indexPath.section][indexPath.row];
        cell = [FriendCell friendCellWithTableView:tableView andFriend:model];
    }
    return cell;
}
#pragma mark - 添加搜索栏
- (void)addSearchBar {
//    这里不懂
    _searchController =
    [[UISearchController alloc] initWithSearchResultsController:[UIViewController new]];
    _searchController.searchBar.barStyle = UIBarStyleDefault;
    _searchController.searchBar.tintColor = [UIColor blackColor];
    _searchController.searchBar.translucent = YES;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = @"搜索";
    _searchController.hidesBottomBarWhenPushed = YES;
    CGRect rect = _searchController.searchBar.frame;
    rect.size.height = 44;
    _searchController.searchBar.frame = rect;
    self.tableView.tableHeaderView = _searchController.searchBar;
}
#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        label.text = [NSString stringWithFormat:@"   %@", _indexTitles[section]];
        label.font = [UIFont boldSystemFontOfSize:10];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:141/255.0 green:141/255.0 blue:146/255.0 alpha:0.6];
        return label;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexTitles;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else {
        Friend *selectFriend = self.groupedFriend[indexPath.section][indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChatDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"chat_detail_view"];
        vc.chatFriend = selectFriend.subscriber;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
