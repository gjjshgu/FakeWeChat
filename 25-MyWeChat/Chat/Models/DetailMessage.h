//
//  DetailMessage.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/16.
//

#import <UIkit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    DetailMessageMe = 0,
    DetailMessageOther = 1
} DetailMessageWhose;
typedef enum {
    DetailMessageText = 0,
    DetailMessageAudio = 1,
    DetailMessagePhoto = 3,
    DetailMessageVideo = 4
} DetailMessageType;

@interface DetailMessage : NSObject <NSSecureCoding>


@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, assign) int messageType;
@property (nonatomic, assign) int messageWhose;
@property (nonatomic, strong) UIImage *icon;
// 是否显示时间label
@property (nonatomic, assign) BOOL hideTime;

//

+ (instancetype)messageWithText:(NSString *)text andTime:(NSDate *)time andType:(DetailMessageType)type andWhose:(DetailMessageWhose)whose andIcon:(UIImage *)icon;
- (instancetype)initWithText:(NSString *)text andTime:(NSDate *)time andType:(DetailMessageType)type andWhose:(DetailMessageWhose)whose andIcon:(UIImage *)icon;



@end

NS_ASSUME_NONNULL_END
