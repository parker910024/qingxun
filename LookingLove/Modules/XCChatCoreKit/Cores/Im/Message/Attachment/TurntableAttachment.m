//
//  TurntableInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "TurntableAttachment.h"

@implementation TurntableAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCTurntableContentView";
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {

    CGSize size = [@"恭喜你，获取抽奖机会，点击我抽奖>>" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return CGSizeMake(size.width+20 , size.height);

}


@end
