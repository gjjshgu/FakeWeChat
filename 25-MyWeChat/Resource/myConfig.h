//
//  myConfig.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#ifndef myConfig_h
#define myConfig_h
// 各种颜色
#define BASE_COLOR [UIColor colorWithRed:104/255.0 green:187/255.0 blue:30/255.0 alpha:1]
#define BASE_BACKGROUND_COLOR [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]
#define USERNAME_BLUE_COLOR [UIColor colorWithRed:87/255.0f green:107/255.0f blue:148/255.0f alpha:1]
#define MOMENTS_BACKGROUND_COLOR [UIColor colorWithRed:17/255.0f green:17/255.0f blue:17/255.0f alpha:1]
// 聊天列表保存
#define CHAT_ROOT_LIST [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_chat_root_list.data", self.me.account]]
// 发送信息到服务器
#define SEND_MESSAGE(dict) [(TabBarController *)self.tabBarController sendToServerWithDict:dict]
// 联系人保存路径
#define CONTACT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"contact_dict_%@.data", self.me.account]]
// dateformatter格式
#define DATE_FORMAT_RULE @"yyyy-MM-dd HH:mm:ss"
#endif /* myConfig_h */
