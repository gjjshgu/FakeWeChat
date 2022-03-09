//
//  NSString+CountHeight.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/15.
//

#import "NSString+CountHeight.h"

@implementation NSString (CountHeight)
- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName :font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)sizeWithText:(NSString *)text andMaxSize:(CGSize)maxSize andFont:(UIFont *)font {
    return [text sizeOfTextWithMaxSize:maxSize andFont:font];
}
@end
