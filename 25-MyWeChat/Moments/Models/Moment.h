//
//  Moment.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage, Subscriber;

@interface Moment : NSObject
@property (nonatomic, strong) Subscriber *subscriber;
//@property (nonatomic, strong) UIImage *icon;
//@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSArray *photos;


@end

NS_ASSUME_NONNULL_END
