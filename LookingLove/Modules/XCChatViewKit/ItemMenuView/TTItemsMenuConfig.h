//
//  TTItemsConfig.h
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTItemsMenuConfig : NSObject

@property (nonatomic,assign) CGFloat itemHeight;

@property (nonatomic,assign) UIEdgeInsets separatorInset;

@property (strong, nonatomic) UIColor *separatorColor;

@property (strong, nonatomic) UIColor *backgroudColor;

@property (assign, nonatomic) CGFloat menuWidth;

/**
 c生成

 @param itemHeight item的高度
 @param separatorInset 分割线的边界
 @param separatorColor 分割线颜色
 @param backgroudColor 菜单的背景颜色
 @return TTItemsMenuConfig
 */
+ (TTItemsMenuConfig *)creatMenuConfigWithItemHeight:(CGFloat)itemHeight
                                           menuWidth:(CGFloat)menuWidth
                                    separatorInset:(UIEdgeInsets)separatorInset
                                    separatorColor:(UIColor *)separatorColor
                                    backgroudColor:(UIColor *)backgroudColor;

@end

NS_ASSUME_NONNULL_END
