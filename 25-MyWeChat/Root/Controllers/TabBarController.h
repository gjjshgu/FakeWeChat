//
//  TabBarController.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SRWebSocket, Subscriber, Friend, RootMessage, LastMessage;
@interface TabBarController : UITabBarController 

@property (strong, nonatomic, nullable) SRWebSocket *webSocket;

@property (nonatomic, strong) Subscriber *me;

@property (nonatomic, strong) NSMutableDictionary<NSString *, Subscriber *> *contactDict;

@property (nonatomic, strong) NSMutableDictionary<NSString *, LastMessage *> *chatRootDict;

- (void)sendToServerWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
