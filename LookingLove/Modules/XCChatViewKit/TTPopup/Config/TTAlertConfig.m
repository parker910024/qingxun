//
//  TTAlertConfig.m
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTAlertConfig.h"
#import "XCTheme.h"
#import "XCMacros.h"

static CGFloat kAlertTitleFont = 18.f;
static CGFloat kAlertButtonFont = 15.f;
static CGFloat kAlertMessageFont = 14.f;
static CGFloat kAlertCornerRadius = 12.f;
static CGFloat kAlertBackgroundColorAlpha = 0.3;
static CGFloat kAlertMessageFontLineSpace = -1;
static CGFloat kAlertButtonCornerRadius = 8.f;

@implementation TTAlertConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _backgroundColor = [UIColor whiteColor];
        
        //背景颜色
        if (projectType() == ProjectType_CatEar) {
            _backgroundColor = UIColorFromRGB(0x202845);
        } else if (projectType() == ProjectType_LookingLove) {
            kAlertTitleFont = 16.f;
            kAlertCornerRadius = 14.f;
            kAlertButtonCornerRadius = 19.f;
        }
        
        // title
        _title = @"提示";// 标题
        _titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:kAlertTitleFont];// 字体
        _titleColor = XCThemeSubTextColor;// 颜色
        
        // message
        _message = @"";
        _messageFont = [UIFont systemFontOfSize:kAlertMessageFont];// 内容
        _messageColor = XCThemeMainTextColor;// 颜色
        _messageLineSpacing = kAlertMessageFontLineSpace;// 字体行间距
        _messageAttributedConfig = @[];// 自定义富文本样式
        
        /// button
        // cancel button
        _cancelButtonConfig = [[TTAlertButtonConfig alloc] init];
        _cancelButtonConfig.title = @"取消";// 取消按钮
        _cancelButtonConfig.font = [UIFont systemFontOfSize:kAlertButtonFont];// 按钮字体
        _cancelButtonConfig.titleColor = XCThemeSubTextColor;// 字体颜色
        _cancelButtonConfig.backgroundColor = UIColorFromRGB(0xEEEDF0);// 按钮背景色
        _cancelButtonConfig.cornerRadius = kAlertButtonCornerRadius;// 按钮背景图
        
        // confirm button
        _confirmButtonConfig = [[TTAlertButtonConfig alloc] init];
        _confirmButtonConfig.title = @"确定";
        _confirmButtonConfig.font = [UIFont systemFontOfSize:kAlertButtonFont];
        _confirmButtonConfig.titleColor = UIColorFromRGB(0xFFFFFF);
        _confirmButtonConfig.backgroundColor = XCThemeMainColor;
        _confirmButtonConfig.cornerRadius = kAlertButtonCornerRadius;
        
        _cornerRadius = kAlertCornerRadius;// 默认圆角
        
        _shouldDismissOnBackgroundTouch = YES;// 点击蒙层是否消失
        
        // mask default 0.3 black
        _maskBackgroundAlpha = kAlertBackgroundColorAlpha;  // alert 背景色
        
        _disableAutoDismissWhenClickButton = NO;
        
        if (projectType() == ProjectType_LookingLove) {
            _cancelButtonConfig.titleColor = XCThemeMainTextColor;// 字体颜色
            _cancelButtonConfig.backgroundColor = UIColor.whiteColor;// 按钮背景色
            
            _confirmButtonConfig.backgroundColor = XCThemeMainColor;
            _confirmButtonConfig.titleColor = XCThemeMainTextColor;
        }
        
        if (projectType() == ProjectType_CatASMR) {
           
            _messageFont = [UIFont systemFontOfSize:15];
            _messageColor = UIColorFromRGB(0x454545);
            _titleFont = [UIFont boldSystemFontOfSize:18];
            
            _confirmButtonConfig.backgroundColor = XCTheme.getASMRMainDefaultColor;
            _confirmButtonConfig.titleColor = UIColorFromRGB(0x1A1A1A);
            _confirmButtonConfig.font = [UIFont boldSystemFontOfSize:16];
            _confirmButtonConfig.cornerRadius = 22;
            
            _cancelButtonConfig.backgroundColor = UIColorFromRGB(0xFAFAFA);
            _cancelButtonConfig.titleColor = UIColorFromRGB(0x1A1A1A);
            _cancelButtonConfig.font = [UIFont boldSystemFontOfSize:16];
            _cancelButtonConfig.cornerRadius = 22;
            
        }
    }
    return self;
}

@end

