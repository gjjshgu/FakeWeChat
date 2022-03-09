//
//  ChatDetailViewController.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Subscriber, LastMessage;
@interface ChatDetailViewController : UIViewController

@property (strong, nonatomic) Subscriber *chatFriend;

//@property (nonatomic, assign) BOOL newMessage;

@property (nonatomic, copy, nullable) NSArray<LastMessage *> *recentMessage;
//
//@property (nonatomic, copy, nullable) NSArray<NSDate *> *recentTime;

@end

NS_ASSUME_NONNULL_END
