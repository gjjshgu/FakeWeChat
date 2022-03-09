//
//  ChatRootTableViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import "ChatRootTableViewController.h"
#import "ChatRootCell.h"
#import "ChatDetailViewController.h"
#import "myConfig.h"
#import "Subscriber.h"

#import "TabBarController.h"
#import "RootMessage.h"
#import "LastMessage.h"
#import "NSDate+TimeString.h"
#import "TimeFormatter.h"

#define kRecentDict [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_recent_dict.data", self.me.account]]

@interface ChatRootTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *searchRes;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<RootMessage *> *messageArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LastMessage*> *chatRootDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Subscriber *> *contactDict;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<LastMessage *> *> *recentDict;

@property (nonatomic, assign) int newMessageCount;
@property (nonatomic, strong) Subscriber *me;
@property (nonatomic, copy, nullable) NSString *isSelectAccount;

@end

@implementation ChatRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 65;
    self.tableView.backgroundColor = BASE_BACKGROUND_COLOR;
    TabBarController *vc = (TabBarController *)self.tabBarController;
    self.me = vc.me;
    [self addSearchBar];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    监听信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageWithInfo:) name:@"send_message" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    获取服务端消息队列的消息
    [self updateData];
    self.isSelectAccount = nil;
}
#pragma mark - 更新数据
- (void)updateData {
    self.messageArray = [NSMutableArray array];
    NSDictionary *dict = self.chatRootDict;
    int count = 0;
    for (NSString *account in dict.allKeys) {
        Subscriber *subscriber = [self.contactDict objectForKey:account];
        LastMessage *last = [self.chatRootDict objectForKey:account];
        RootMessage *model = [RootMessage messageWithLastMessage:last andSubscriber:subscriber];
        int eachCount = (int)self.recentDict[account].count;
        count += eachCount;
        model.newMessage = eachCount;
        [self.messageArray addObject:model];
    }
    if (count != 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
//    这里加上数组按时间顺序排序
    [self.messageArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RootMessage *object1 = obj1, *object2 = obj2;
        return [object2.time compare:object1.time];
    }];
    [self.tableView reloadData];
}
#pragma mark - 接受信息监听
- (void)receiveMessageWithInfo:(NSNotification *)noteInfo {
    NSDictionary *dict = noteInfo.userInfo;
    TimeFormatter *formatter = [TimeFormatter defaultFormatter];
//    获取数据
    NSDate *date = [formatter dateFromString:dict[@"time"]];
    NSString *sender = dict[@"sender_account"];
    NSString *text = dict[@"text"];
    LastMessage *model = [LastMessage messageWithText:text andTime:date];
//    更新数据
    [self.chatRootDict setValue:model forKey:sender];
//    追加数据
    if (self.isSelectAccount == nil || (self.isSelectAccount != nil && ![sender isEqualToString:self.isSelectAccount])) {
        NSMutableArray *array = [self.recentDict objectForKey:sender];
        if (array == nil) {
            array = [NSMutableArray array];
        }
    //    添加到追加
        [array addObject:model];
        [self.recentDict setValue:array forKey:sender];
    }
///  更新数据
    [self updateData];
//    保存
    NSData *dataChatRoot = [NSKeyedArchiver archivedDataWithRootObject:self.chatRootDict requiringSecureCoding:YES error:nil];
    [[NSFileManager defaultManager]createFileAtPath:CHAT_ROOT_LIST contents:dataChatRoot attributes:nil];
    NSData *dataRecentDict = [NSKeyedArchiver archivedDataWithRootObject:self.recentDict requiringSecureCoding:YES error:nil];
    [[NSFileManager defaultManager]createFileAtPath:kRecentDict contents:dataRecentDict attributes:nil];
}
#pragma mark - 搜索框
- (void)addSearchBar {
    _searchController =
    [[UISearchController alloc] initWithSearchResultsController:[UIViewController new]];
    _searchController.searchBar.barStyle = UIBarStyleDefault;
    _searchController.searchBar.tintColor = [UIColor blackColor];
//    怎么设置文字为取消
//    UIButton *cancelBtn = [_searchController.searchBar valueForKey:@"cancelButton"];
//    cancelBtn.titleLabel.text = @"取消";
    _searchController.searchBar.translucent = YES;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = @"搜索";
    _searchController.hidesBottomBarWhenPushed = YES;
    CGRect rect = _searchController.searchBar.frame;
    rect.size.height = 44;
    _searchController.searchBar.frame = rect;
    self.tableView.tableHeaderView = _searchController.searchBar;
}
#pragma mark - 懒加载
- (NSMutableDictionary<NSString *,Subscriber *> *)contactDict {
    if (_contactDict == nil) {
        TabBarController *con = (TabBarController *)self.tabBarController;
        _contactDict = con.contactDict;
    }
    return _contactDict;
}
- (NSMutableDictionary<NSString *,LastMessage *> *)chatRootDict {
    if (_chatRootDict == nil) {
        TabBarController *con = (TabBarController *)self.tabBarController;
        _chatRootDict = con.chatRootDict;
    }
    return _chatRootDict;
}
- (NSMutableDictionary<NSString *,NSMutableArray<LastMessage *> *> *)recentDict {
    if (_recentDict == nil) {
        NSData *dataRecentDict = [NSData dataWithContentsOfFile:kRecentDict];
        NSMutableDictionary *recentDict = [NSKeyedUnarchiver unarchivedObjectOfClasses:[[NSSet alloc] initWithArray:@[[NSString class], [NSDate class], [LastMessage class], [NSMutableArray class], [NSMutableDictionary class]]] fromData:dataRecentDict error:nil];
        if (recentDict == nil) {
            recentDict = [NSMutableDictionary dictionary];
        }
        _recentDict = recentDict;
    }
    return _recentDict;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRootCell *cell = [ChatRootCell chatRootCellWithTableView:tableView andMessage:self.messageArray[indexPath.row]];
    return cell;
}
#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"chat_detail_view"];
    vc.hidesBottomBarWhenPushed = YES;
//    设置参数
    RootMessage *rmes = self.messageArray[indexPath.row];
    Subscriber *sub = rmes.subscriber;
//    设置不被追加
    self.isSelectAccount = sub.account;
    vc.chatFriend = sub;
    vc.recentMessage = [self.recentDict valueForKey:sub.account];
    [self.recentDict removeObjectForKey:sub.account];
    NSData *dataRecentDict = [NSKeyedArchiver archivedDataWithRootObject:self.recentDict requiringSecureCoding:YES error:nil];
    [[NSFileManager defaultManager]createFileAtPath:kRecentDict contents:dataRecentDict attributes:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search Bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

@end
