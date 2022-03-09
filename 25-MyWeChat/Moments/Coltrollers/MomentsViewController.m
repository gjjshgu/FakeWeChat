//
//  MonentsViewController.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import "MomentsViewController.h"
#import "MomentsTopCell.h"
#import "Moment.h"
#import "MomentFrame.h"
#import "MomentsDetailCell.h"
#import "myConfig.h"
#import "TopData.h"

#import "Subscriber.h"
//#import "RootData.h"
#import "TabBarController.h"
//#import "SocketRocket.h"
#import "SVProgressHUD.h"

#define kCoverPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_cover_img.jpg", self.me.account]]

@interface MomentsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIButton *coverButton;
@property (nonatomic, weak, readonly) UIButton *iconButton;
@property (nonatomic, strong) NSMutableArray<Moment *> *moments;
@property (nonatomic, strong) NSMutableArray<MomentFrame *> *momentFrames;
@property (nonatomic, strong) TopData *top;
@property (nonatomic, weak) UIImageView *barImgView;

@property (nonatomic, strong) Subscriber *me;
//@property (nonatomic, weak) RootData *data;
//@property (nonatomic, weak) SRWebSocket *webSocket;

@end

@implementation MomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    设置默认数据
//    [self defaultData];
    [self setDefaultData];
//    设置tableview
    [self tableViewSetup];
//    设置bar
    [self navigetionBarSetup];
}
#pragma mark - 设置朋友圈数据
- (NSMutableArray<Moment *> *)moments {
    if (_moments == nil) {
        _moments = [NSMutableArray arrayWithObject:[NSNull null]];
    }
    return _moments;
}
- (NSMutableArray<MomentFrame *> *)momentFrames {
    if (_momentFrames == nil) {
        _momentFrames = [NSMutableArray arrayWithObject:[NSNull null]];
    }
    return _momentFrames;
}
- (void)setDataWithMoment:(Moment *)model {
    [self.moments insertObject:model atIndex:1];
    MomentFrame *frame = [MomentFrame frameWithMoment:model];
    [self.momentFrames insertObject:frame atIndex:1];
}
#pragma mark - 加载客户端对象和数据
- (void)setDefaultData {
    TabBarController *con = (TabBarController *)self.tabBarController;
//    _webSocket = con.webSocket;
    _me = con.me;
//    _webSocket.delegate = self;
}
// 默认数据
- (TopData *)top {
    if (_top == nil) {
        UIImage *img = [UIImage imageWithContentsOfFile:kCoverPath];
        if (img == nil) {
            img = [UIImage imageNamed:@"default_avater"];
        }
        _top = [TopData new];
        _top.coverImg = img;
        _top.subscriber = self.me;
//        _top.iconImg = self.data.icon;
//        _top.name = self.data.name;
    }
    return _top;
}
#pragma mark - 简略发文字
- (void)sendWithText:(NSString *)text {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"M-d HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    NSDictionary *dict = @{
        @"type": @"moments_text",
        @"account" : self.me.account,
        @"username" : self.me.name,
        @"text" : text,
        @"date" : dateStr,
    };
    
}
- (void)simpleSendText {
    NSString *mainTitle = [NSString stringWithFormat:@"发表文字"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:mainTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //获取第1个输入框；
        UITextField *titleTextField = alertController.textFields.firstObject;
        NSString *text = titleTextField.text;
        if (text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"输入内容不能为空"];
            return;
        }
        [self sendWithText:text];
        }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //定义输入框
    [alertController addTextFieldWithConfigurationHandler:nil];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - 拍照按钮单击事件
- (void)cameraButtonSetup {
    UIBarButtonItem *camButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonClick)];
    self.navigationItem.rightBarButtonItem = camButton;
}
- (void)cameraButtonClick {
//    创建控制器
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    添加按钮
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *getPhoto = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *textButton = [UIAlertAction actionWithTitle:@"发文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self simpleSendText];
    }];
//    通过kvc设置颜色
    [takePhoto setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [getPhoto setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [cancel setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
//    添加到控制器
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:getPhoto];
    [actionSheet addAction:cancel];
    [actionSheet addAction:textButton];
//    显示
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark - 设置导航栏
- (void)navigetionBarSetup {
//    设置bar字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    设置导航栏透明 （背景为空图片就透明了）
    _barImgView = self.navigationController.navigationBar.subviews.firstObject;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.barImgView.alpha = 0;
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor]; 这样不行
//    消除状态栏下面横线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
//    添加按钮
    [self cameraButtonSetup];
}
#pragma mark - 设置tableView
- (void)tableViewSetup {
//    设置背景颜色
//    self.tableView.backgroundColor = MOMENTS_BACKGROUND_COLOR;
//    设置不被选中
    self.tableView.allowsSelection = NO;
//    设置内边距
    CGFloat barHeight = -CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat margin = -25;
    self.tableView.contentInset = UIEdgeInsetsMake(barHeight+margin, 0, 0, 0);
//    取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = [UIScreen mainScreen].bounds.size.height * 0.33;
    CGFloat maxAlphaOffset = minAlphaOffset + 60;
    CGFloat offset = scrollView.contentOffset.y;
    if (offset > minAlphaOffset) {
        self.navigationItem.title = @"朋友圈";
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
        UIColor *textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
        self.navigationController.navigationBar.tintColor = textColor;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor}];
        self.barImgView.alpha = alpha;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = nil;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}
#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        MomentsTopCell *topCell = [MomentsTopCell topCellWithTableView:tableView andData:self.top];
        self.coverButton = topCell.coverButton;
        [topCell.coverButton addTarget:self action:@selector(coverButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        cell = topCell;
    } else {
        MomentFrame *frame = self.momentFrames[indexPath.row];
        MomentsDetailCell *detailCell = [MomentsDetailCell momentDetailCellWithTableView:tableView andFrame:frame];
        cell = detailCell;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [UIScreen mainScreen].bounds.size.height * 0.50;
    }
    return self.momentFrames[indexPath.row].rowHeight;
}
#pragma mark - 顶部按钮点击事件
- (void)coverButtonClicked {
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.top.coverImg = img;
//    还没做图片裁剪
    [picker dismissViewControllerAnimated:YES completion:nil];
//    更新图片
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    保存图片
    [UIImageJPEGRepresentation(img, 0.5) writeToFile:kCoverPath atomically:YES];
}


@end
