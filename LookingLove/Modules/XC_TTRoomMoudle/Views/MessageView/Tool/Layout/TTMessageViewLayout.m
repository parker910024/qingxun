//
//  TTMessageViewLayout.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageViewLayout.h"

#import <YYText/YYText.h>

@implementation TTMessageViewLayout

+ (instancetype)shareLayout {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (CGFloat)getAttributedHeightWith:(NSMutableAttributedString *)attr {
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 88 - 8 - 30, MAXFLOAT);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:attr];

    return layout.textBoundingSize.height + 20;//+20 是因为要给黑色背景留够空间
}
@end
