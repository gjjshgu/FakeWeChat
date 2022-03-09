//
//  ChatDetailViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/15.
//

#import "ChatDetailViewController.h"
#import "ChatDetailCell.h"
#import "DetailMessageFrame.h"
#import "DetailMessage.h"
#import "myConfig.h"
#import "Subscriber.h"
#import "TabBarController.h"
#import "RootMessage.h"
#import "LastMessage.h"
#import "NSDate+TimeString.h"
#import "TimeFormatter.h"

#define kFramePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_to_%@_history_chats_frame.data", self.me.account, self.chatFriend.account]]


@interface ChatDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *memeButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UIButton *recordOrTextButton;
@property (nonatomic, strong) NSMutableArray<DetailMessageFrame *> *messageFrames;
@property (nonatomic, strong) NSMutableArray<DetailMessage *> *messages;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LastMessage *> *chatRootDict;
@property (nonatomic, strong) Subscriber *me;

@end

@implementation ChatDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    初始化导航栏
    [self navigationBarSetup];
//    初始化tableView
    [self tableViewSetup];
//    设置默认数据
    [self setDefaultData];
//    加载聊天记录
    [self setupChatHistory];
//    监听收到信息
    [self listen];
}
#pragma mark - 加载新得到的消息
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.recentMessage == nil) {
        return;
    }
    for (int i = 0; i < self.recentMessage.count; i++) {
        [self sendMessage:self.recentMessage[i].text withWhose:DetailMessageOther withDate:self.recentMessage[i].time];
    }
    self.recentMessage = nil;
}
#pragma mark - tableView初始化
- (void)tableViewSetup {
//    去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    不可被选中
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = BASE_BACKGROUND_COLOR;
//    划到最下面
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self scrollToBottomWithAnimate:NO];
        });
    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self scrollToBottomWithAnimate:NO];
//    });
}
#pragma mark - 导航栏初始化
- (void)navigationBarSetup {
    self.navigationItem.title = self.chatFriend.name;
//    添加按钮
    UIBarButtonItem *b1 = [[UIBarButtonItem alloc] initWithTitle:@"···" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = b1;
}
#pragma mark - 加载和存储聊天记录
- (void)setupChatHistory {
    NSData *dataFrame = [NSData dataWithContentsOfFile:kFramePath];
    if (dataFrame == nil) {
        return;
    }
    _messageFrames = (NSMutableArray *)[NSKeyedUnarchiver unarchivedArrayOfObjectsOfClasses:[[NSSet alloc] initWithArray:@[[NSString class], [DetailMessageFrame class], [DetailMessage class], [UIImage class], [NSDate class]]] fromData:dataFrame error:nil];
    _messages = [NSMutableArray array];
    for (DetailMessageFrame *frame in _messageFrames) {
        [_messages addObject:frame.message];
    }
}
- (void)saveChatHistory {
//   保存更新后的聊天记录
    NSData *dataFrame = [NSKeyedArchiver archivedDataWithRootObject:self.messageFrames requiringSecureCoding:YES error:nil];
    [[NSFileManager defaultManager]createFileAtPath:kFramePath contents:dataFrame attributes:nil];
//    保存更新后的聊天列表
    NSData *dataChatRoot = [NSKeyedArchiver archivedDataWithRootObject:self.chatRootDict requiringSecureCoding:YES error:nil];
    [[NSFileManager defaultManager]createFileAtPath:CHAT_ROOT_LIST contents:dataChatRoot attributes:nil];
}
#pragma mark - 加载全局变量
- (void)setDefaultData {
    TabBarController *con = (TabBarController *)self.tabBarController;
    _me = con.me;
    _chatRootDict = con.chatRootDict;
}
#pragma mark - 设置tableview
- (IBAction)textOrRecord:(UIButton *)sender {
    if (self.recordButton.hidden == YES) {
        self.recordButton.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"Album_ToolViewKeyboard"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"Album_ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        [self.inputField endEditing:YES];
    } else {
        self.recordButton.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
        [sender setImage:nil forState:UIControlStateHighlighted];
        [self.inputField becomeFirstResponder];
    }
}
#pragma mark - 监听事件
- (void)listen {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    监听键盘弹出通知
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    监听获得信息通知
    [center addObserver:self selector:@selector(receiveMessageWithInfo:) name:@"send_message" object:nil];
}
- (void)dealloc {
//    一定要在dealloc中移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 键盘弹出事件
- (void)keyboardWillChangeFrame:(NSNotification *)noteInfo {
    CGRect keyboardEndRect = [noteInfo.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginRect = [noteInfo.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardEndRect.origin.y;
    CGFloat keyboardW = keyboardBeginRect.origin.y - keyboardEndRect.origin.y;
    

    
//    上移 (问题：如果信息并没有满全屏，上移会导致这些信息往上挪）
///    CGFloat transformValue = keyboardY - self.view.frame.size.height;
///    self.view.transform = CGAffineTransformMakeTranslation(0, transformValue);
//    tableview往上缩小
//    需要上移的控件
    NSArray *upMoveView = @[_inputField, _recordButton, _memeButton, _otherButton, _recordOrTextButton];
    CGRect viewFrame = self.view.frame, tableViewFrame = self.tableView.frame;
    
    viewFrame.size.height = keyboardY;
    tableViewFrame.size.height -= keyboardW;
//    如果只是键盘大小发生改变，则不需要动画
    CGFloat aniTime = ABS(keyboardW) < keyboardBeginRect.size.height ? 0.01 : 0.2;
//    动画拉起
    [UIView animateWithDuration:aniTime animations:^{
        for (UIView *view in upMoveView) {
            CGRect frame = view.frame;
            frame.origin.y -= keyboardW;
            view.frame = frame;
        }
        self.view.frame = viewFrame;
        self.tableView.frame = tableViewFrame;
    }];
//    让tableview滚动到最后一行
    [self scrollToBottomWithAnimate:YES];
}
#pragma mark - 工具
- (void)scrollToBottomWithAnimate:(BOOL)animate {
    if (self.messages.count == 0) {
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:animate];
}
#pragma mark - 发送消息
- (void)sendToServerWithText:(NSString *)text andDate:(NSDate *)date{
    TimeFormatter *formatter = [TimeFormatter defaultFormatter];
    NSDictionary *dict = @{
        @"type": @"send_message",
        @"sender_account": self.me.account,
        @"target_account": self.chatFriend.account,
        @"message_type": @"text",
        @"text": text,
        @"time": [formatter stringFromDate:date]
    };
    SEND_MESSAGE(dict);
}
- (void)addMessagesToModel:(DetailMessage *)model{
//    判断是否隐藏时间标签
    model.hideTime = [model.time isOneMinuteLaterWithLastTime:self.messages.lastObject.time];
    [self.messages addObject:model];
//    创建frame模型
    DetailMessageFrame *frame = [DetailMessageFrame frameWithMessage:model];
    [self.messageFrames addObject:frame];
}
- (void)sendMessage:(NSString *)text withWhose:(DetailMessageWhose)whose withDate:(NSDate *)date{
//    创建模型
    DetailMessage *model = [DetailMessage new];
//    给模型赋值
    model.text = text;
    model.icon = [UIImage imageNamed:@"default_avater"];
    model.messageType = DetailMessageText;
    model.messageWhose = whose;
    model.time = date;
//    添加到数据
    [self addMessagesToModel:model];
//    刷新tableview
    [self.tableView reloadData];
//    滚动到最后一行
    [self scrollToBottomWithAnimate:YES];
//    发送网络请求
    if (whose == DetailMessageMe) {
        [self sendToServerWithText:text andDate:date];
    }
//    更新聊天列表
    LastMessage *lastMessage = [LastMessage messageWithText:text andTime:date];
    [self.chatRootDict setValue:lastMessage forKey:self.chatFriend.account];
//    保存到本地
    [self saveChatHistory];
}
#pragma mark - 接受信息监听
- (void)receiveMessageWithInfo:(NSNotification *)noteInfo {
    NSDictionary *dict = noteInfo.userInfo;
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.dateFormat = DATE_FORMAT_RULE;
    TimeFormatter *formatter = [TimeFormatter defaultFormatter];
    NSDate *date = [formatter dateFromString:dict[@"time"]];
    [self sendMessage:dict[@"text"] withWhose:DetailMessageOther withDate:date];
}
#pragma mark - 重写getter方法
- (NSMutableArray<DetailMessage *> *)messages {
    if (_messages == nil) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}
- (NSMutableArray<DetailMessageFrame *> *)messageFrames {
    if (_messageFrames == nil) {
        _messageFrames = [NSMutableArray array];
    }
    return _messageFrames;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    获取模型数据
    DetailMessageFrame *frame = self.messageFrames[indexPath.row];
//    创建单元格
    ChatDetailCell *cell = [ChatDetailCell detailCellWithTableView:tableView];
//    把模型数据给单元格
    cell.messageFrame = frame;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   返回每一行的行高
    DetailMessageFrame *frame = self.messageFrames[indexPath.row];
    return frame.rowHeight;
}
#pragma mark - Table view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    结束编辑模式 （还没做点到除了编辑框以外的东西都要结束）
    [self.inputField endEditing:YES];
}
#pragma mark - Text Field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        return NO;
    }
    [self sendMessage:textField.text withWhose:DetailMessageMe withDate:[NSDate date]];
//    清空输入框
    textField.text = @"";
    return YES;
}


@end
