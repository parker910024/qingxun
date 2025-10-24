//
//  UIFont+FontCollection.m
//  HAYO
//
//  Created by apple on 2019/4/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "UIFont+FontCollection.h"

@implementation UIFont (FontCollection)

+ (UIFont *)SFUIDisplay_Regular_WithFontSize:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        return [UIFont systemFontOfSize:size];
    } else {
        return [UIFont fontWithName:@".SFUIDisplay" size:size];
    }
    
}

+ (UIFont *)SFUIDisplay_Medium_WithFontSize:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        return [UIFont boldSystemFontOfSize:size];
    } else {
        return [UIFont fontWithName:@".SFUIDisplay-Medium" size:size];
    }
}

+ (UIFont *)SFUIDisplay_Semibold_WithFontSize:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        return [UIFont boldSystemFontOfSize:size];
    } else {
        return [UIFont fontWithName:@".SFUIDisplay-Semibold" size:size];
    }
}

+ (UIFont *)SFUIDisplay_Heavy_WithFontSize:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        return [UIFont boldSystemFontOfSize:size];
    } else {
        return [UIFont fontWithName:@".SFUIDisplay-Heavy" size:size];
    }
}

+ (UIFont *)fontAwesome5BrandsRegularFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"FontAwesome5BrandsRegular" size:size];
}

+ (UIFont *)fontAwesome5FreeRegularFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"FontAwesome5FreeRegular" size:size];
}

+ (UIFont *)fontAwesome5FreeSolidFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"FontAwesome5FreeSolid" size:size];
}

+ (UIFont *)weatherAndTimeFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Weather&Time" size:size];
}

+ (UIFont *)PingFangSC_Ultralight_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Ultralight" size:size];
}

+ (UIFont *)PingFangSC_Thin_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Thin" size:size];
}

+ (UIFont *)PingFangSC_Regular_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)PingFangSC_Semibold_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

+ (UIFont *)PingFangSC_Light_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}

+ (UIFont *)PingFangSC_Medium_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)HelveticaNeue_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)HelveticaNeue_Bold_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+ (UIFont *)FZFSJW_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"FZFSJW--GB1-0" size:size];
}

+ (UIFont *)QXyingbikaiWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"QXyingbikai" size:size];
}

+ (UIFont *)HappyZcool_KH_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HuXiaoBoKuHei" size:size];
}

+ (UIFont *)HappyZcool_2016_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HappyZcool-2016" size:size];
}

+ (UIFont *)PangMenZhengDaoWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"PangMenZhengDao" size:size];
}

+ (UIFont *)HYHeiZaiTiW_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"HYHeiZaiTiW" size:size];
}

+ (UIFont *)AaFangMeng_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"AaFangMeng" size:size];
}

+ (UIFont *)LSSST_1498_WithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"LSSST-1498" size:size];
}

+ (UIFont *)EN_LatoRegularWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

+ (UIFont *)EN_LatoBoldWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont *)EN_LatoThinWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Lato-Thin" size:size];
}

+ (UIFont *)EN_LatoLightWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont *)EN_LatoThinItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Lato-ThinItalic" size:size];
}

+ (UIFont *)EN_SnellRoundhandWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"SnellRoundhand" size:size];
}

+ (UIFont *)EN_SnellRoundhandBoldWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"SnellRoundhand-Bold" size:size];
}

+ (UIFont *)EN_SnellRoundhandBlackWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"SnellRoundhand-Black" size:size];
}

+ (UIFont *)EN_GillSansLightWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-Light" size:size];
}

+ (UIFont *)EN_GillSansLightItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-LightItalic" size:size];
}

+ (UIFont *)EN_GillSansWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans" size:size];
}

+ (UIFont *)EN_GillSansItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-Italic" size:size];
}

+ (UIFont *)EN_GillSansSemiBoldWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-SemiBold" size:size];
}

+ (UIFont *)EN_GillSansSemiBoldItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:size];
}

+ (UIFont *)EN_GillSansBoldWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-Bold" size:size];
}

+ (UIFont *)EN_GillSansBoldItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-BoldItalic" size:size];
}

+ (UIFont *)EN_GillSansUltraBoldWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"GillSans-UltraBold" size:size];
}

+ (UIFont *)EN_GeorgiaWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Georgia" size:size];
}

+ (UIFont *)EN_GeorgiaItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Georgia-Italic" size:size];
}

+ (UIFont *)EN_GeorgiaBoldWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Georgia-Bold" size:size];
}

+ (UIFont *)EN_GeorgiaBoldItalicWithFontSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Georgia-BoldItalic" size:size];
}

#pragma mark - DINAlternate-Bold

+ (UIFont *)DINAlternate_BoldWithFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"DINOT-Bold" size:size];
}

+ (UIFont *)DINAlternate_MediumWithFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"DINOT-Medium" size:size];
}

+ (UIFont *)ArialFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"Arial" size:size];
}


#pragma mark - SFUIText-Regular
+ (UIFont *)SFUIText_regularWithFontSize:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        return [UIFont systemFontOfSize:size];
    } else {
        return [UIFont fontWithName:@".SFUIDisplay" size:size];
    }
}

#pragma mark - SFProDisplay
+ (UIFont *)SFProDisplay_regularWithFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"SFProDisplay-Regular" size:size];
}

+ (UIFont *)SFProDisplay_blodWithFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"SFProDisplay-Bold" size:size];
}

+ (UIFont *)SFProDisplay_semiblodWithFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"SFProDisplay-Semibold" size:size];
}

+ (UIFont *)SFProDisplay_medimWithFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"SFProDisplay-Medium" size:size];
}
@end
