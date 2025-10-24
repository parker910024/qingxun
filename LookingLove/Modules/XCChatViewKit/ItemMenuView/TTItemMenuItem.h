//
//  TTItemMenuItem.h
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MenuItemClickBlock)(void);

@interface TTItemMenuItem : NSObject

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) UIFont *titleFont;

@property (strong, nonatomic) UIColor *titleColor;

@property (strong, nonatomic) NSString *iconName;

@property (nonatomic, copy) MenuItemClickBlock itemClickHandler;
/**
 创建item

 @param title 标题
 @param iconName 表意文字m
 @return item
 */
+ (TTItemMenuItem *)creatWithTitle:(NSString *)title
                         iconName:(NSString *)iconName
                        titleFont:(nullable UIFont *)titleFont
                       titleColor:(nullable UIColor *)titleColor;

/**
 创建item

 @param title 标题
 @param iconName 表意文字m
 @return item
 */
+ (TTItemMenuItem *)creatWithTitle:(NSString *)title
                          iconName:(NSString *)iconName
                         titleFont:(nullable UIFont *)titleFont
                        titleColor:(nullable UIColor *)titleColor
                  itemClickHandler:(MenuItemClickBlock)itemClickHandler;

@end

NS_ASSUME_NONNULL_END
