//
//  TTFunctionMenuButton.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFunctionMenuButton.h"

@implementation TTFunctionMenuButton

- (void)setButtonNormalImage:(NSString *)normalImage disableImage:(NSString *)disableImage selectedImage:(NSString *)selectedImage{
    
    [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
}


@end
