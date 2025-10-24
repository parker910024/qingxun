//
//  TTItemMenuItem.m
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTItemMenuItem.h"

//theme
#import "XCTheme.h"

@implementation TTItemMenuItem

+ (TTItemMenuItem *)creatWithTitle:(NSString *)title
                         iconName:(NSString *)iconName
                        titleFont:(UIFont *)titleFont
                       titleColor:(UIColor *)titleColor {
    TTItemMenuItem *item = [[TTItemMenuItem alloc]init];
    item.title = title.length > 0 ? title : @"未命名";
    item.iconName = iconName.length > 0 ? iconName : [XCTheme defaultTheme].default_avatar;
    item.titleFont = titleFont ? titleFont : [UIFont systemFontOfSize:15.f];
    item.titleColor = titleColor ? titleColor : UIColorFromRGB(0x1a1a1a);
    return item;
}

+ (TTItemMenuItem *)creatWithTitle:(NSString *)title iconName:(NSString *)iconName titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor itemClickHandler:(MenuItemClickBlock)itemClickHandler {
    TTItemMenuItem *item = [[TTItemMenuItem alloc]init];
    item.title = title.length > 0 ? title : @"未命名";
    item.iconName = iconName.length > 0 ? iconName : [XCTheme defaultTheme].default_avatar;
    item.titleFont = titleFont ? titleFont : [UIFont systemFontOfSize:15.f];
    item.titleColor = titleColor ? titleColor : UIColorFromRGB(0x1a1a1a);
    item.itemClickHandler = itemClickHandler;
    return item;
}

@end
