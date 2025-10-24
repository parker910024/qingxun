//
//  TTFunctionMenuItem.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFunctionMenuItem.h"


@implementation TTFunctionMenuItem


+ (instancetype)itemWithFunctionTag:(TTFunctionMenuItemTag)functionTag title:(NSString *)title imageName:(NSString *)imageName{
    
    TTFunctionMenuItem *item = [[self alloc] init];
    item.functionTag = functionTag;
    item.title = title;
    item.imageName = imageName;
    return item;
}


@end
