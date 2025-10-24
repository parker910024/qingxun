//
//  TTActionSheetConfig.h
//  AFNetworking
//
//  Created by lee on 2019/5/23.
//  action sheet item 配置

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TTItemSelectNormal,
    TTItemSelectHighLight,
} TTItemSelectType;


NS_ASSUME_NONNULL_BEGIN
typedef void(^TTActionSheetClickAction)(void);

@interface TTActionSheetConfig : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;

/**
 标题颜色
 默认 TTItemSelectNormal 时为 [XCTheme getTTMainTextColor]
 默认 TTItemSelectHighLight 时为 [XCTheme getTTMainColor]
 */
@property (nonatomic, strong) UIColor *titleColor;

/** 是否选中 */
@property (nonatomic, assign) TTItemSelectType type;

/** 点击事件 */
@property (nonatomic, copy) TTActionSheetClickAction clickAction;

/**
 构建 actionSheet item 实例
 
 @param title 标题
 @param clickAction 点击事件
 @return item 实例
 */
+ (TTActionSheetConfig *)normalTitle:(NSString *)title
                         clickAction:(TTActionSheetClickAction)clickAction;
+ (TTActionSheetConfig *)normalTitle:(NSString *)title
                     selectColorType:(TTItemSelectType)type clickAction:(TTActionSheetClickAction)clickAction;


/// 构建实例
/// @param title 标题
/// @param textColor 颜色
/// @param handler 事件处理
+ (TTActionSheetConfig *)actionWithTitle:(NSString *)title
                                   color:(UIColor *)textColor
                                 handler:(TTActionSheetClickAction)handler;
@end

NS_ASSUME_NONNULL_END
