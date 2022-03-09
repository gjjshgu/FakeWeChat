//
//  NSDate+TimeString.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TimeString)

- (NSString *)chatStringFormat;

//- (NSString *)momentStringFormat;

- (BOOL)isOneMinuteLaterWithLastTime:(NSDate *)time;



@end

NS_ASSUME_NONNULL_END
