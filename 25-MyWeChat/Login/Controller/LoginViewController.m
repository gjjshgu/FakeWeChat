//
//  LoginViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/21.
//

#import "LoginViewController.h"
#import "TabBarController.h"
#import "myConfig.h"
#import "SocketRocket.h"
#import "SVProgressHUD.h"
//#import "RootData.h"
#import "NSDictionary+ToJson.h"
//#import "User.h"
#import "Subscriber.h"
#import "RootMessage.h"
#import "Friend.h"
#import "LastMessage.h"

#define kAutoLogin @"auto_login"

@interface LoginViewController () <SRWebSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL isSignIn;

@property (strong, nonatomic) SRWebSocket *webSocket;
@property (nonatomic, strong) Subscriber *me;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSignIn = YES;
//    self.signUpButton.titleLabel.textColor = USERNAME_BLUE_COLOR;
    self.signUpButton.tintColor = USERNAME_BLUE_COLOR;
    self.navigationController.navigationBarHidden = YES;
//    类型
    self.accountField.textContentType = UITextContentTypeUsername;
    self.passwordField.textContentType = UITextContentTypeNewPassword;
//    websocket
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:8765"]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    
    
//    保存设置
//    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    
    
}
- (IBAction)signUpClicked:(UIButton *)sender {
    if (self.isSignIn) {
        self.titleLabel.text = @"注册新账号";
        [sender setTitle:@"登录" forState:UIControlStateNormal];
//        [sender.titleLabel setFont:[UIFont systemFontOfSize:9]];
        sender.titleLabel.font = [UIFont systemFontOfSize:9];
//        sender.titleLabel.text = ;
        self.isSignIn = NO;
    } else {
        self.titleLabel.text = @"微信号 /QQ号 /邮箱登录";
//        sender.titleLabel.text = @"注册";
        [sender setTitle:@"注册" forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:9];
        self.isSignIn = YES;
    }
    
}
- (IBAction)signInClicked:(id)sender {
//    账号密码提交后台
    NSString *type;
    if (self.isSignIn) {
        type = @"sign_in";
    }else {
        type = @"sign_up";
    }
    NSDictionary *dict = @{
        @"type": type,
        @"account": self.accountField.text,
        @"password": self.passwordField.text,
    };
    NSString *jsonStr = [dict jsonStringGet];
    [self.webSocket sendString:jsonStr error:nil];
//    后台返回是否登录
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)loginWithUsername:(NSString *)username {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarController *vc = [storyboard instantiateViewControllerWithIdentifier:@"root_tab_bar_controller"];
    vc.webSocket = self.webSocket;
//    账号核心信息
    UIImage *defaultImg = [UIImage imageNamed:@"default_avater"];
    self.me = [Subscriber subscriberWithName:username andAccount:self.accountField.text andIcon:defaultImg];
    vc.me = self.me;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SRWebsocket代理方法
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *getmessage = [NSDictionary dictionaryWithJsonString:message];
    if ([getmessage[@"type"] isEqualToString:@"success"]) {
//        登录
        [self loginWithUsername:getmessage[@"username"]];
    } else if ([getmessage[@"type"] isEqualToString:@"sign_up_failed"]) {
        [SVProgressHUD showErrorWithStatus:@"该账号已登录"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
    }
}


@end
