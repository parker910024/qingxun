//
//  TTAlertButtonConfig.h
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  alert 按钮配置

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTAlertButtonConfig : NSObject
/** 按钮标题 */
@property (nonatomic, copy) NSString *title;
/** 按钮字体 */
@property (nonatomic, strong) UIFont *font;
/** 按钮字体颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 背景图 */
@property (nonatomic, strong) UIImage *backgroundImage;
/** 圆角 */
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
