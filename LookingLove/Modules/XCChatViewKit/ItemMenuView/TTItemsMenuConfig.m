//
//  TTItemsConfig.m
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTItemsMenuConfig.h"

//theme
#import "XCTheme.h"

@implementation TTItemsMenuConfig

+ (TTItemsMenuConfig *)creatMenuConfigWithItemHeight:(CGFloat)itemHeight
                                           menuWidth:(CGFloat)menuWidth
                                      separatorInset:(UIEdgeInsets)separatorInset
                                      separatorColor:(nonnull UIColor *)separatorColor
                                      backgroudColor:(nonnull UIColor *)backgroudColor {
    TTItemsMenuConfig *config = [[TTItemsMenuConfig alloc]init];
    config.itemHeight = itemHeight > 0 ? itemHeight : 50;
    config.separatorInset = separatorInset;
    config.separatorColor = separatorColor ? separatorColor : UIColorFromRGB(0xebebeb);
    config.backgroudColor = backgroudColor ? backgroudColor : UIColorFromRGB(0xffffff);
    config.menuWidth = menuWidth > 0 ? menuWidth : 140;
    return config;
}

@end
