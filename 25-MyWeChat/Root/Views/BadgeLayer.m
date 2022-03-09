//
//  BadgeLayer.m
//  25-MyWeChat
//
//  Created by 黄倬熙 on 2022/2/27.
//

#import "BadgeLayer.h"
#import <UIkit/UIkit.h>

@implementation BadgeLayer

+ (instancetype)badgeWithNumString:(NSString *)string andPoint:(CGPoint)point{
    return [[self alloc] initWithNumString:string andPoint:point];
}
- (instancetype)initWithNumString:(NSString *)string andPoint:(CGPoint)point{
    if (self = [super init]) {
        CGFloat size = 18.3;
        self.backgroundColor = [UIColor redColor].CGColor;
        self.foregroundColor = [UIColor whiteColor].CGColor;
        self.alignmentMode = kCAAlignmentCenter;
        [self setFrame:CGRectMake(0, 0, size, size)];
        point.x -= size;
        point.y -= size / 2;
        self.position = point;
        self.wrapped = YES;
        self.cornerRadius = 9.0f;
        [self setFontSize:14];
        [self setString:string];
        self.anchorPoint = CGPointZero;
        self.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}
@end
