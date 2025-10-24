//
//  UILabel+Transform.m
//  XChatFramework
//
//  Created by 卫明何 on 2018/7/9.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UILabel+Transform.h"

@implementation UILabel (Transform)

+ (void)setTransform:(float)radians forLable:(UILabel *)label {
    label.transform = CGAffineTransformMakeRotation(M_PI*radians);
}
@end
