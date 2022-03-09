//
//  TabBarController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import "TabBarController.h"
#import "myConfig.h"
#import "SocketRocket.h"
#import "NSDictionary+ToJson.h"
#import "Subscriber.h"
#import "LastMessage.h"
#import "SVProgressHUD.h"

@interface TabBarController () <SRWebSocketDelegate>

@property (nonatomic, assign) int reConnectTime;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    设置bar选中后字体颜色
    self.tabBar.tintColor = BASE_COLOR;
    self.webSocket.delegate = self;
//    异步执行I/O操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self setupContact];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self setupChatRoot];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self reConnect];
}
#pragma mark - 监听进入后台事件
- (void)applicationEnterBackground{
    [self disConnect];
    // 关闭连接
}
- (void)applicationBecomeActive {
//    重新连接（服务端不再是同一个对象了）
    [self reConnect];
    NSLog(@"%s", __FUNCTION__);
}
#pragma mark - 连接处理
- (void)initConnect {
    self.webSocket = nil;
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:8765"]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}
- (void)disConnect {
    // 关闭连接
    [self.webSocket close];
    self.webSocket = nil;
}
- (void)reConnect {
    [self disConnect];
    [SVProgressHUD showWithStatus:@"载入中"];
    if (_reConnectTime > 64) {
        return;
    }
    NSLog(@"正在尝试重连：%d", _reConnectTime);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initConnect];
    });
    if (_reConnectTime == 0) {
        _reConnectTime = 2;
    } else {
        _reConnectTime *= 2;
    }
}
#pragma mark - SRWebSocket Delegate
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
//    open失败调用
    NSLog(@"连接失败");
    [self reConnect];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (code == 1000) {
        return;
    }
    [self reConnect];
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功");
//    重置重连时间
    _reConnectTime = 0;
    dispatch_after((dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dict = @{
            @"type": @"message_queue",
            @"account": self.me.account
        };
        [self sendToServerWithDict:dict];
        [SVProgressHUD dismiss];
    });
}
#pragma mark - 加载联系人 聊天列表
- (void)setupContact {
    NSData *contactData = [NSData dataWithContentsOfFile:CONTACT_PATH];
    
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSKeyedUnarchiver unarchivedDictionaryWithKeysOfClasses:[[NSSet alloc] initWithArray:@[[NSString class]]] objectsOfClasses:[[NSSet alloc] initWithArray:@[[NSString class], [Subscriber class], [UIImage class]]] fromData:contactData error:nil];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    self.contactDict = dict;
}
- (void)setupChatRoot {
    NSData *chatRootData = [NSData dataWithContentsOfFile:CHAT_ROOT_LIST];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSKeyedUnarchiver unarchivedDictionaryWithKeysOfClasses:[[NSSet alloc] initWithArray:@[[NSString class]]] objectsOfClasses:[[NSSet alloc] initWithArray:@[[NSString class], [NSDate class], [LastMessage class]]] fromData:chatRootData error:nil];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    self.chatRootDict = dict;
}

#pragma mark - 接收信息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *getmessage = [NSDictionary dictionaryWithJsonString:message];
    NSString *type = getmessage[@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:self userInfo:getmessage];
}

#pragma mark - 发送信息
- (void)sendToServerWithDict:(NSDictionary *)dict {
    NSString *jsonStr = [dict jsonStringGet];
    [self.webSocket sendString:jsonStr error:nil];
}
@end
