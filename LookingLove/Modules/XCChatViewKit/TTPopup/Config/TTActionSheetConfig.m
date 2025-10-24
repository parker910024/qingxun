//
//  TTActionSheetConfig.m
//  AFNetworking
//
//  Created by lee on 2019/5/23.
//

#import "TTActionSheetConfig.h"

#import "XCTheme.h"

@implementation TTActionSheetConfig

/**
 构建 actionSheet item 实例
 
 @param title 标题
 @param clickAction 点击事件
 @return item 实例
 */
+ (TTActionSheetConfig *)normalTitle:(NSString *)title clickAction:(TTActionSheetClickAction)clickAction {
    
    return [self normalTitle:title selectColorType:TTItemSelectNormal clickAction:clickAction];
}

+ (TTActionSheetConfig *)normalTitle:(NSString *)title selectColorType:(TTItemSelectType)type clickAction:(TTActionSheetClickAction)clickAction {
    
    UIColor *color = type == TTItemSelectHighLight ? [XCTheme getTTMainColor] : [XCTheme getTTMainTextColor];
    
    TTActionSheetConfig *config = [self actionWithTitle:title color:color handler:clickAction];
    config.type = type;
    
    return config;
}

+ (TTActionSheetConfig *)actionWithTitle:(NSString *)title
                                   color:(UIColor *)textColor
                                 handler:(TTActionSheetClickAction)handler {
        
    TTActionSheetConfig *config = [[TTActionSheetConfig alloc] init];
    config.type = TTItemSelectNormal;
    config.title = title;
    config.titleColor = textColor;
    config.clickAction = handler;
    
    return config;
}

@end
