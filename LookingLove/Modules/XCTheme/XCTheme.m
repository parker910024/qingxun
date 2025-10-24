//
//  XCTheme.m
//  theme
//
//  Created by 卫明何 on 2018/8/8.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import "XCTheme.h"
#import "XCMacros.h"

#define MainDefaultBlueColorStr @"MainDefaultBlueColor"
#define SecondaryRedColorStr    @"SecondaryRedColor"
#define SecondaryYellowColor    @"SecondaryYellowColor"
#define SecondaryPurpleColor    @"SecondaryPurpleColor"
#define LineDefaultGrayColor    @"LineDefaultGrayColor"
#define DefaultBgColor          @"DefaultBgColor"

@interface XCTheme ()

@property (strong, nonatomic) NSDictionary *colorMap;

@end

@implementation XCTheme

+ (instancetype)defaultTheme {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.colorMap = @{
                          MainDefaultBlueColorStr   :   UIColorFromRGB(0xffb608),
                          SecondaryRedColorStr      :   UIColorFromRGB(0xff5353),
                          SecondaryYellowColor      :   UIColorFromRGB(0xffb091),
                          SecondaryPurpleColor      :   UIColorFromRGB(0x964ef4),
                          LineDefaultGrayColor      :   UIColorFromRGB(0xf0f0f0),
                          DefaultBgColor            :   UIColorFromRGB(0xf5f5f5)
                          };
    }
    return self;
}

- (NSDictionary *)getColorMap {
    return self.colorMap;
}


//** ------------------ placeholder  -----------------------------   **/
- (NSString *)default_avatar{
    return @"placeholder_image_square";
}
- (NSString *)default_background{
    return @"default_bg";
}
- (NSString *)default_empty{
   return @"common_noData_empty";
}
- (NSString *)placeholder_image_square{
    return @"placeholder_image_square";
}
- (NSString *)placeholder_image_rectangle{
    return @"placeholder_image_rectangle";
}

- (NSString *)placeholder_image_cycle {
    return @"placeholder_image_cycle";
}

//** ------------------ sex  -----------------------------   **/
- (NSString *)common_sex_male{
    return @"common_sex_male";
}
- (NSString *)common_sex_female{
    return @"common_sex_female";
}


//** ------------------ color  -----------------------------   **/
/**
 获取主色调
 
 @return 颜色
 */
+ (UIColor *)getMainDefaultColor{
    
    return [self getMainDefaultColorWithAlpha:1.0];
}

+ (UIColor *)getMainDefaultColorWithAlpha:(CGFloat)alpha {
   if (projectType() == ProjectType_TuTu ||
       projectType() == ProjectType_Pudding ||
       projectType() == ProjectType_CeEr ||
       projectType() == ProjectType_LookingLove) {
       // 侧耳
       return [self getTTMainColor];
       
   } else if (projectType() == ProjectType_CatASMR) {
       return [self getASMRMainDefaultColorWithAlpha:alpha];
   
   } else if (projectType() == ProjectType_CatEar) {
       return [self getCatEarMainDefaultColorWithAlpha:alpha];
   
   } else {
       return [UIColor clearColor];
   }
}
/**
 获取辅助色
 @return 颜色
 */
+ (UIColor *)getSecondaryColor {
    if (projectType() == ProjectType_CatEar) {
        return [self getCatEarSecondaryColor];
    } else {
        return [UIColor clearColor];
    }
}

/// 文本颜色一二三级

/// 一级文本颜色
+ (UIColor *)mainTextColor {
    
    switch (projectType()) {
        case ProjectType_CeEr:
            return UIColorFromRGB(0x2C2C2E);
            break;
        default:
            return UIColorFromRGB(0x2C2C2E);
            break;
    }
}
/// 二级文本颜色
+ (UIColor *)subTextColor {
    switch (projectType()) {
        case ProjectType_CeEr:
            return UIColorFromRGB(0x626166);
            break;
        default:
            return UIColorFromRGB(0x626166);
            break;
    }
}
/// 三级文本颜色
+ (UIColor *)thirdTextColor {
    switch (projectType()) {
        case ProjectType_CeEr:
            return UIColorFromRGB(0xABAAB3);
            break;
        default:
            return UIColorFromRGB(0xABAAB3);
            break;
    }
}

#pragma mark -
#pragma mark 抓耳
/************************-- ASMR -*************************/
/**
 获取黄色主色调

 @return 颜色
 */
+ (UIColor *)getASMRMainDefaultColor {
    return [self getASMRMainDefaultColorWithAlpha:1.0];
}
+ (UIColor *)getASMRMainDefaultColorWithAlpha:(CGFloat)alpha {
    if (alpha>1) {
        alpha = 1;
    }
    if (alpha<0) {
        alpha = 0;
    }
    return UIColorRGBAlpha(0xffc70f, alpha);
}


/**
 CP 房，公屏。<提示消息>颜色
 */
+ (UIColor *)getASMRMessageViewTipColor{
    return UIColorFromRGB(0xFFD463);
}

#pragma mark -
#pragma mark 猫耳

/************************-- CatEar -*************************/
/**
 获取猫耳黑色主色调

 @return 颜色
 */
+ (UIColor *)getCatEarMainDefaultColor {
    return [self getCatEarMainDefaultColorWithAlpha:1.0];
}
+ (UIColor *)getCatEarMainDefaultColorWithAlpha:(CGFloat)alpha {
    return UIColorRGBAlpha(0x202845, alpha);
}
/**
 获取猫耳绿色辅助色

 @return 颜色
 */
+ (UIColor *)getCatEarSecondaryColor {
    return UIColorRGBAlpha(0x28E4C0, 1.0);
}

#pragma mark -
#pragma mark 哈哈
/******-- 哈哈-*******/
/**
 获取蓝色主色调
 
 @return 颜色
 */
+ (UIColor *)getMainDefaultBlueColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:MainDefaultBlueColorStr];
}

/**
 获取红色辅助色
 
 @return 颜色
 */
+ (UIColor *)getSecondaryRedColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:SecondaryRedColorStr];
}


/**
 获取黄色辅助色
 
 @return 颜色
 */
+ (UIColor *)getSecondaryYellowColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:SecondaryYellowColor];
}

/**
 获取紫色辅助色
 
 @return 颜色
 */
+ (UIColor *)getSecondaryPurpleColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:SecondaryPurpleColor];
}

/**
 获取分割线颜色
 
 @return 颜色
 */
+ (UIColor *)getLineDefaultGrayColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:LineDefaultGrayColor];
}

/**
 获取块底色
 
 @return 颜色
 */
+ (UIColor *)getDefaultBgColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:DefaultBgColor];
}

/**
 获取按钮蓝色主色调
 
 @return 颜色
 */
+ (UIColor *)getButtonDefaultBlueColor {
    return [[[XCTheme defaultTheme]getColorMap] objectForKey:MainDefaultBlueColorStr];
}


/******-- 萌声 -*******/
/**
 获取萌声主题色  6c62f5
 
 @return 萌声主题色
 */
+ (UIColor *)getMSMainColor {
    return UIColorFromRGB(0x6c62f5);
}


/**
 获取萌声按钮高亮色 cc2a45

 @return 萌声按钮高亮色
 */
+ (UIColor *)getMSHightLightColor {
    return UIColorFromRGB(0xcc2a45);
}


/**
 获取萌声绿色辅助色 3ACFD3
 主要用于 公屏提示
 
 @return 绿色辅助色
 */
+ (UIColor *)getMSGreenColor {
    return UIColorFromRGB(0x3ACFD3);
}


/**
 获取萌声蓝色辅助色 0d9eff
 主要用于 性别/公屏
 @return 蓝色辅助色
 */
+ (UIColor *)getMSBlueColor {
    return UIColorFromRGB(0x0d9eff);
}


/**
 获取萌声红色辅助色 ED5E84
 主要用于 公屏
 @return 红色辅助色
 */
+ (UIColor *)getMSRedColor {
    return UIColorFromRGB(0xED5E84);
}


/**
 获取萌声 主字体 颜色 333333
 主要用于 主标题 主文字 按钮文字
 @return 萌声 主字体 颜色
 */
+ (UIColor *)getMSMainTextColor {
    return UIColorFromRGB(0x333333);
}


/**
 获取萌声 二级字体 颜色 666666
 主要用于 标题 文字 按钮文字
 @return 萌声 二级字体 颜色
 */

+ (UIColor *)getMSSecondTextColor {
    return UIColorFromRGB(0x666666);
}

/**
 获取萌声 三级字体 颜色 999999
 主要用于 标题 文字 按钮文字
 @return 萌声 三级字体 颜色
 */

+ (UIColor *)getMSThirdTextColor {
    return UIColorFromRGB(0x999999);
}


/**
 获取萌声 深灰色 颜色 cccccc
 主要用于
 @return 萌声 深灰 颜色
 */

+ (UIColor *)getMSDeepGrayColor {
    return UIColorFromRGB(0xcccccc);
}


/**
 获取萌声 浅灰色 颜色 f5f5f5
 主要用于
 @return 萌声 浅灰 颜色
 */

+ (UIColor *)getMSSimpleGrayColor {
    return UIColorFromRGB(0xf5f5f5);
}

/**
 获取萌声 公屏提示 颜色
 @return 萌声 公屏提示 颜色
 */
+ (UIColor *)getMSMessageViewTipColor{
    return UIColorRGBAlpha(0xffffff, 0.5);
}

/**
 获取萌声 公屏文本 颜色
 @return 萌声 公屏文本 颜色
 */
+ (UIColor *)getMSMessageViewTextColor{
    return UIColorRGBAlpha(0xffffff, 1.0);
}

/**
 获取萌声 四种颜色中的随机一种
 @return 萌声 公屏文本 颜色
 */
+ (UIColor *)getMSRandomColorFromFourColor {
    int x = arc4random() % 4;
    if (x == 0) {
        return RGBACOLOR(108, 98, 245, 0.18);
    } else if (x == 1) {
        return RGBACOLOR(249, 181, 183, 0.18);
    } else if (x == 2) {
        return RGBACOLOR(101, 214, 179, 0.18);
    } else {
        return RGBACOLOR(182, 141, 240, 0.18);
    }
}

#pragma mark -
#pragma mark 侧耳（轻寻）
/*——————————————————   兔兔   ————————————————————————*/

/**
 兔兔主题色 #ff894f
 轻寻主题色 #39EBDF
 
 @return 兔兔主题色
 */
+ (UIColor *)getTTMainColor {
    return [self getTTMainColorWithAlpha:1.0];
}

+ (UIColor *)getTTMainColorWithAlpha:(CGFloat)alpha {
    if (projectType() == ProjectType_LookingLove) {
        return UIColorRGBAlpha(0x39EBDF, alpha);
    } else if (projectType() == ProjectType_Planet) {
        return UIColorRGBAlpha(0x7754f6, alpha);
    } else if (projectType() == ProjectType_DontSilent) {
        return UIColorRGBAlpha(0x818bff, alpha);
    } else if (projectType() == ProjectType_CeEr) {
        return UIColorRGBAlpha(0x9976FC, alpha); // 侧耳
    }
    return UIColorRGBAlpha(0xff894f, alpha);
}

/**
 兔兔渐变 开始颜色 #ff6147
 
 @return 兔兔渐变 开始颜色
 */
+ (UIColor *)getTTGradualStartColor {
    return UIColorFromRGB(0xff6147);
}

/**
 兔兔渐变 结束颜色 #ff9451
 
 @return 兔兔渐变 结束颜色
 */
+ (UIColor *)getTTGradualEndColor {
    return UIColorFromRGB(0xff9451);
}

/**
 兔兔 红色辅助色 #ff3852
 
 @return  兔兔 红色辅助色
 */
+ (UIColor *)getTTRedColor {
    return UIColorFromRGB(0xff3852);
}


/**
 兔兔 蓝色辅助色 #00A9FF
 
 @return 兔兔 蓝色辅助色
 */
+ (UIColor *)getTTBlueColor {
    return UIColorFromRGB(0x00A9FF);
}


/**
 兔兔 标题颜色 #333333
 
 @return 兔兔 标题颜色
 */
+ (UIColor *)getTTMainTextColor {
    return UIColorFromRGB(0x333333);
}


/**
 兔兔 副标题颜色 #666666
 
 @return 兔兔 副标题颜色
 */
+ (UIColor *)getTTSubTextColor {
    return UIColorFromRGB(0x666666);
}


/**
 兔兔 灰色文本颜色 #999999
 
 @return 兔兔 灰色文本颜色
 */
+ (UIColor *)getTTDeepGrayTextColor {
    return UIColorFromRGB(0x999999);
}

/**
 兔兔 灰色颜色 #cfcfcf
 
 @return 兔兔 灰色颜色
 */
+ (UIColor *)getTTGrayColor {
    return UIColorFromRGB(0xcfcfcf);
}


/**
 兔兔 灰色背景色 #F5F5F5
 
 @return 兔兔 灰色背景色
 */
+ (UIColor *)getTTSimpleGrayColor {
    return UIColorFromRGB(0xF5F5F5);
}

/**
 兔兔玩友公屏的颜色(黄色的)
 */
+ (UIColor *)getTTWanYouRoomMessageMainColor{
    return UIColorFromRGB(0xFEAF87);
}
/*
 获取兔兔 公屏提示 颜色 #FFFFFE 0.5
 @return 兔兔 公屏提示 颜色
 */
+ (UIColor *)getTTMessageViewTipColor{
    return UIColorRGBAlpha(0xfffffe, 0.5);
}

/**
 获取兔兔 公屏文本 颜色  #FFFFFF 0.8
 @return 兔兔 公屏文本 颜色
 */
+ (UIColor *)getTTMessageViewTextColor{
    return UIColorRGBAlpha(0xffffff, 0.8);
}

/**
 获取兔兔 公屏NICK 颜色 #FFFFFF 0.5
 @return 兔兔 公屏NICK 颜色
 */
+ (UIColor *)getTTMessageViewNickColor{
    return UIColorRGBAlpha(0xffffff, 0.5);
}


/**
 CP 房，公屏。<消息>颜色
 */
+ (UIColor *)getTTMessageViewCPNickColor{
    return UIColorFromRGB(0xFFD98C);
}
@end
