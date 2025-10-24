//
//  XCTheme.h
//  theme
//
//  Created by 卫明何 on 2018/8/8.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorRGBAlpha(rgbValue,a)             [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// 主色调
#define XCThemeMainColor [XCTheme getMainDefaultColor]
// 字体颜色
#define XCThemeMainTextColor [XCTheme mainTextColor]
#define XCThemeSubTextColor [XCTheme subTextColor]
#define XCThemeThirdTextColor [XCTheme thirdTextColor]

@interface XCTheme : NSObject

//** ------------------ placeholder  -----------------------------   **/
@property (nonatomic, copy) NSString *default_avatar;//默认头像
@property (nonatomic, copy) NSString *default_background;//默认背景
@property (nonatomic, copy) NSString *default_empty;//空白默认
@property (nonatomic, copy) NSString *placeholder_image_square;// 正方形占位图
@property (nonatomic, copy) NSString *placeholder_image_rectangle;// 长方形占位图
@property (nonatomic, copy) NSString *placeholder_image_cycle;//圆形占位图

//** ------------------ sex  -----------------------------   **/
@property (nonatomic, copy) NSString *common_sex_female;// female
@property (nonatomic, copy) NSString *common_sex_male;//male

/**
 初始化主题

 @return self
 */
+ (instancetype)defaultTheme;

#pragma mark -
#pragma mark 通用方法

/**
 获取主色调
 
 @return 颜色
 */
+ (UIColor *)getMainDefaultColor;
+ (UIColor *)getMainDefaultColorWithAlpha:(CGFloat)alpha;
/**
 获取辅助色
 @return 颜色
 */
+ (UIColor *)getSecondaryColor;

/// 文本颜色一二三级

/// 一级文本颜色
+ (UIColor *)mainTextColor;
/// 二级文本颜色
+ (UIColor *)subTextColor;
/// 三级文本颜色
+ (UIColor *)thirdTextColor;


#pragma mark -
#pragma mark 抓耳
/************************-- CatchEar -*************************/
/**
 获取抓耳黄色主色调

 @return 颜色
 */
+ (UIColor *)getASMRMainDefaultColor;

/**
 CP 房，公屏。<提示消息>颜色
 */
+ (UIColor *)getASMRMessageViewTipColor;

#pragma mark -
#pragma mark 猫耳
/************************-- CatEar -*************************/
/**
 获取猫耳黑色主色调

 @return 颜色
 */
+ (UIColor *)getCatEarMainDefaultColor;

/**
 获取猫耳绿色辅助色

 @return 颜色
 */
+ (UIColor *)getCatEarSecondaryColor;

#pragma mark -
#pragma mark 侧耳（轻寻）
/*——————————————————   兔兔   ————————————————————————*/
/**
 兔兔主题色 #ff894f
 轻寻主题色 #39EBDF

 @return 兔兔主题色
 */
+ (UIColor *)getTTMainColor;

+ (UIColor *)getTTMainColorWithAlpha:(CGFloat)alpha;
/**
 兔兔渐变 开始颜色 #ff6147

 @return 兔兔渐变 开始颜色
 */
+ (UIColor *)getTTGradualStartColor;

/**
 兔兔渐变 结束颜色 #ff9451

 @return 兔兔渐变 开始颜色
 */
+ (UIColor *)getTTGradualEndColor;


/**
 兔兔 红色辅助色 #ff3852

 @return  兔兔 红色辅助色
 */
+ (UIColor *)getTTRedColor;


/**
 兔兔 蓝色辅助色 #00A9FF

 @return 兔兔 蓝色辅助色
 */
+ (UIColor *)getTTBlueColor;


/**
 兔兔 标题颜色 #333333

 @return 兔兔 标题颜色
 */
+ (UIColor *)getTTMainTextColor;


/**
 兔兔 副标题颜色 #666666

 @return 兔兔 副标题颜色
 */
+ (UIColor *)getTTSubTextColor;


/**
 兔兔 灰色文本颜色 #999999

 @return 兔兔 灰色文本颜色
 */
+ (UIColor *)getTTDeepGrayTextColor;

/**
 兔兔 灰色颜色 #cfcfcf

 @return 兔兔 灰色颜色
 */
+ (UIColor *)getTTGrayColor;


/**
 兔兔 灰色背景色 #F5F5F5

 @return 兔兔 灰色背景色
 */
+ (UIColor *)getTTSimpleGrayColor;

/**
 兔兔玩友公屏的颜色
 */
+ (UIColor *)getTTWanYouRoomMessageMainColor;

/*
 获取兔兔 公屏提示 颜色 #FFFFFE 0.5
 @return 兔兔 公屏提示 颜色
 */
+ (UIColor *)getTTMessageViewTipColor;

/**
 获取兔兔 公屏文本 颜色  #FFFFFF 0.8
 @return 兔兔 公屏文本 颜色
 */
+ (UIColor *)getTTMessageViewTextColor;

/**
 获取兔兔 公屏NICK 颜色 #FFFFFF 0.5
 @return 兔兔 公屏NICK 颜色
 */
+ (UIColor *)getTTMessageViewNickColor;


/**
 CP 房，公屏。<消息>颜色
 */
+ (UIColor *)getTTMessageViewCPNickColor;

#pragma mark -
#pragma mark 以下项目已经废弃，暂且不知道还有多少项目在调用下列方法。以后请不要调用以下的方法。 2020年01月19日起

#pragma mark -
#pragma mark 哈哈
/************************-- 哈哈 -*************************/
/**
 获取蓝色主色调

 @return 颜色
 */
+ (UIColor *)getMainDefaultBlueColor;

/**
 获取红色辅助色

 @return 颜色
 */
+ (UIColor *)getSecondaryRedColor;

/**
 获取黄色辅助色
 
 @return 颜色
 */
+ (UIColor *)getSecondaryYellowColor;

/**
 获取紫色辅助色
 
 @return 颜色
 */
+ (UIColor *)getSecondaryPurpleColor;

/**
 获取分割线颜色
 
 @return 颜色
 */
+ (UIColor *)getLineDefaultGrayColor;

/**
 获取块底色
 
 @return 颜色
 */
+ (UIColor *)getDefaultBgColor;

/**
 获取按钮蓝色主色调
 
 @return 颜色
 */
+ (UIColor *)getButtonDefaultBlueColor;

#pragma mark -
#pragma mark 萌声
/************************-- 萌声 -*************************/
/**
 获取萌声主题色

 @return 萌声主题色
 */
+ (UIColor *)getMSMainColor;


/**
 获取萌声按钮高亮色 cc2a45
 
 @return 萌声按钮高亮色
 */
+ (UIColor *)getMSHightLightColor;
/**
 获取萌声绿色辅助色 3ACFD3
 主要用于 公屏提示
 
 @return 绿色辅助色
 */
+ (UIColor *)getMSGreenColor;
/**
 获取萌声蓝色辅助色 0d9eff
 主要用于 性别/公屏
 @return 蓝色辅助色
 */
+ (UIColor *)getMSBlueColor;
/**
 获取萌声红色辅助色 ED5E84
 主要用于 公屏
 @return 红色辅助色
 */
+ (UIColor *)getMSRedColor;
/**
 获取萌声 主字体 颜色 333333
 主要用于 主标题 主文字 按钮文字
 @return 萌声 主字体 颜色
 */
+ (UIColor *)getMSMainTextColor;
/**
 获取萌声 二级字体 颜色 666666
 主要用于 标题 文字 按钮文字
 @return 萌声 二级字体 颜色
 */

+ (UIColor *)getMSSecondTextColor;
/**
 获取萌声 三级字体 颜色 999999
 主要用于 标题 文字 按钮文字
 @return 萌声 三级字体 颜色
 */

+ (UIColor *)getMSThirdTextColor;
/**
 获取萌声 深灰色 颜色 cccccc
 主要用于
 @return 萌声 深灰 颜色
 */

+ (UIColor *)getMSDeepGrayColor;
/**
 获取萌声 浅灰色 颜色 f5f5f5
 主要用于
 @return 萌声 浅灰 颜色
 */

+ (UIColor *)getMSSimpleGrayColor;

/**
 获取萌声 公屏提示 颜色
 @return 萌声 公屏提示 颜色
 */
+ (UIColor *)getMSMessageViewTipColor;

/**
 获取萌声 公屏文本 颜色
 @return 萌声 公屏文本 颜色
 */
+ (UIColor *)getMSMessageViewTextColor;

/**
 获取萌声 四种颜色中的随机一种
 @return 萌声 公屏文本 颜色
 */
+ (UIColor *)getMSRandomColorFromFourColor;


@end
