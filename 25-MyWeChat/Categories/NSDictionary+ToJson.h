//
//  NSDictionary+ToJson.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ToJson)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)jsonStringGet;

@end

NS_ASSUME_NONNULL_END
