//
//  NSString+CountHeight.h
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/15.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CountHeight)

- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font;

+ (CGSize)sizeWithText:(NSString *)text andMaxSize:(CGSize)maxSize andFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
