//
//  UIFont+FontCollection.h
//  HAYO
//
//  Created by apple on 2019/4/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (FontCollection)

+ (UIFont *)SFUIDisplay_Regular_WithFontSize:(CGFloat)size;

+ (UIFont *)SFUIDisplay_Medium_WithFontSize:(CGFloat)size;

+ (UIFont *)SFUIDisplay_Semibold_WithFontSize:(CGFloat)size;

+ (UIFont *)SFUIDisplay_Heavy_WithFontSize:(CGFloat)size;

#pragma mark - Font awesome.

+ (UIFont *)fontAwesome5BrandsRegularFontSize:(CGFloat)size;
+ (UIFont *)fontAwesome5FreeRegularFontSize:(CGFloat)size;
+ (UIFont *)fontAwesome5FreeSolidFontSize:(CGFloat)size;
+ (UIFont *)weatherAndTimeFontSize:(CGFloat)size;

#pragma mark - Fonts.

/**
 全新硬笔楷书简
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)QXyingbikaiWithFontSize:(CGFloat)size;

/**
 方正仿宋简体
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)FZFSJW_WithFontSize:(CGFloat)size;

/**
 [系统自带] PingFangSC - Ultralight
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PingFangSC_Ultralight_WithFontSize:(CGFloat)size;

/**
 [系统自带] PingFangSC - Thin
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PingFangSC_Thin_WithFontSize:(CGFloat)size;

/**
 [系统自带] PingFangSC - Light
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PingFangSC_Light_WithFontSize:(CGFloat)size;

/**
 [系统自带] PingFangSC - Regular
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PingFangSC_Regular_WithFontSize:(CGFloat)size;

/**
 [系统自带] PingFangSC - Medium
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PingFangSC_Medium_WithFontSize:(CGFloat)size;

/**
 [系统自带] PingFangSC - Semibold
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PingFangSC_Semibold_WithFontSize:(CGFloat)size;

/**
 [系统自带] Helvetica - Neue
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)HelveticaNeue_WithFontSize:(CGFloat)size;

/**
 [系统自带] Helvetica - Neue - Bold
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)HelveticaNeue_Bold_WithFontSize:(CGFloat)size;

/**
 站酷酷黑
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)HappyZcool_KH_WithFontSize:(CGFloat)size;

/**
 站酷快乐体
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)HappyZcool_2016_WithFontSize:(CGFloat)size;

/**
 庞门正道标题体
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)PangMenZhengDaoWithFontSize:(CGFloat)size;

/**
 汉仪黑仔体W Regular
 
 @param size 字体尺寸
 @return 对应字体
 */
+ (UIFont *)HYHeiZaiTiW_WithFontSize:(CGFloat)size;

/**
 字体管家方萌
 
 @param size 字体大小
 @return 对应字体
 */
+ (UIFont *)AaFangMeng_WithFontSize:(CGFloat)size;

/**
 凌氏随手体
 
 @param size 字体大小
 @return 对应字体
 */
+ (UIFont *)LSSST_1498_WithFontSize:(CGFloat)size;

+ (UIFont *)EN_LatoRegularWithFontSize:(CGFloat)size;
+ (UIFont *)EN_LatoBoldWithFontSize:(CGFloat)size;
+ (UIFont *)EN_LatoThinWithFontSize:(CGFloat)size;
+ (UIFont *)EN_LatoLightWithFontSize:(CGFloat)size;
+ (UIFont *)EN_LatoThinItalicWithFontSize:(CGFloat)size;


+ (UIFont *)EN_SnellRoundhandWithFontSize:(CGFloat)size;
+ (UIFont *)EN_SnellRoundhandBoldWithFontSize:(CGFloat)size;
+ (UIFont *)EN_SnellRoundhandBlackWithFontSize:(CGFloat)size;


+ (UIFont *)EN_GillSansLightWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansLightItalicWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansItalicWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansSemiBoldWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansSemiBoldItalicWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansBoldWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansBoldItalicWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GillSansUltraBoldWithFontSize:(CGFloat)size;

+ (UIFont *)EN_GeorgiaWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GeorgiaItalicWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GeorgiaBoldWithFontSize:(CGFloat)size;
+ (UIFont *)EN_GeorgiaBoldItalicWithFontSize:(CGFloat)size;

#pragma mark - DINAlternate-Bold

+ (UIFont *)DINAlternate_BoldWithFontSize:(CGFloat)size;
+ (UIFont *)DINAlternate_MediumWithFontSize:(CGFloat)size;
+ (UIFont *)ArialFontSize:(CGFloat)size;



#pragma mark - SFUIText-Regular
+ (UIFont *)SFUIText_regularWithFontSize:(CGFloat)size;

#pragma mark - SFProDisplay
+ (UIFont *)SFProDisplay_regularWithFontSize:(CGFloat)size ;
+ (UIFont *)SFProDisplay_blodWithFontSize:(CGFloat)size;
+ (UIFont *)SFProDisplay_semiblodWithFontSize:(CGFloat)size ;
+ (UIFont *)SFProDisplay_medimWithFontSize:(CGFloat)size ;
@end

NS_ASSUME_NONNULL_END
