//
//  TopData.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/18.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class UIImage, Subscriber;

@interface TopData : NSObject

@property (nonatomic, strong) UIImage *coverImg;
//@property (nonatomic, strong) UIImage *iconImg;
//@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Subscriber *subscriber;

@end

NS_ASSUME_NONNULL_END
