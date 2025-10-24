//
//  TTAlertContentAttributedConfig.h
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  alert 提示内容富文本配置

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTAlertMessageAttributedConfig : NSObject

/** 富文本字段需要特殊显示的文本 */
@property (nonatomic, copy) NSString *text;

/** 颜色 */
@property (nonatomic, strong) UIColor *color;

/** 字体 */
@property (nonatomic, strong) UIFont *font;

/**
 目标文本指定位置，一旦设置则无视 text 的值
 
 @discussion 内容文本中出现相同的目标文本时，可通过设置 range 精确指定位置
 */
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END
