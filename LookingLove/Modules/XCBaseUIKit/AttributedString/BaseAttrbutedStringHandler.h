//
//  BaseAttrbutedStringHandler.h
//  XCBaseUIKit
//
//  Created by 卫明何 on 2018/8/24.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *k_NickLabel_Font = @"font";
static NSString *k_NickLabel_Color = @"color";
static NSString *k_NickLabel_MaxWidth = @"maxWidth";
static NSString *k_NickLabel_LabelHeight = @"labelHeight";
typedef enum : NSUInteger {
    BaseAttributedStringNickTypeUILabel,
    BaseAttributedStringNickTypeeString,
} BaseAttributedStringNickType;

typedef enum : NSUInteger {
    BaseAttributedStringKickTypeBeDownMic,
    BaseAttributedStringKickTypeBeKick,
    BaseAttributedStringKickTypeBeBack,
} BaseAttributedStringKickType;

typedef enum : NSUInteger {
    BaseAttributedUserGender_Male = 1,
    BaseAttributedUserGender_Female = 2,
} BaseAttributedUserGender;

@interface BaseAttrbutedStringHandler : NSObject

/**
 生成带颜色的富文本 昵称

 @param nick 昵称
 @param color 颜色
 @return 富文本
 */
+ (NSMutableAttributedString *)makeNick:(NSString *)nick color:(UIColor *)color;

/**
 生成带富文本元素的富文本 昵称

 @param nick 昵称
 @param attribute 富文本字典
 @return 富文本
 */
+ (NSMutableAttributedString *)makeLabelNick:(NSString *)nick labelAttribute:(NSDictionary *)attribute;

/**
 生成性别图标富文本, 图标尺寸默认(15, 15)

 @param gender 性别
 @return 富文本
 */
+ (NSMutableAttributedString *)makeGender:(BaseAttributedUserGender)gender;
+ (NSMutableAttributedString *)makeGender:(BaseAttributedUserGender)gender size:(CGSize)size;

/**
 生成耳伴号

 @param erbanNo 耳伴号
 @return 富文本
 */
+ (NSMutableAttributedString *)makeErBanId:(NSString *)erbanNo;

/**
 星座

 @param birth 生日 userInfo.brith
 @return 富文本
 */
+ (NSMutableAttributedString *)makeDateLabel:(long)birth;

/**
 生成靓号富文本（需要在图片主工程资源文件夹里面命名为“common_beauty”的图片）
 size默认(15,15)  可自定义

 @return 富文本
 */
+ (NSMutableAttributedString *)makeBeautyImage:(NSString *)imageName;
+ (NSMutableAttributedString *)makeBeautyImage:(NSString *)imageName size:(CGSize)size;

/**
 生成经验等级Icon富文本

 @param experUrl 经验等级URL
 @return 富文本
 */
+ (NSMutableAttributedString *)makeExperImage:(NSString *)experUrl;
+ (NSMutableAttributedString *)makeExperImage:(NSString *)experUrl size:(CGSize)size;

/**
 生成魅力等级Icon富文本

 @param charmUrl 魅力等级URL
 @return 富文本
 */
+ (NSMutableAttributedString *)makeCharmImage:(NSString *)charmUrl;
+ (NSMutableAttributedString *)makeCharmImage:(NSString *)charmUrl size:(CGSize)size;

/**
 生成“新”Icon富文本

 @param newUserIconUrl 新ICon
 @return 富文本
 */
+ (NSMutableAttributedString *)makeNewUserImage:(NSString *)newUserIconUrl;
+ (NSMutableAttributedString *)makeNewUserImage:(NSString *)newUserIconUrl size:(CGSize)size;

/**
 生成图片富文本

 @param frame 图片大小
 @param urlString 图片url
 @param imageName 本地图片名字 只要url为空就会读取本图片名字
 @return 富文本
 */
+ (NSMutableAttributedString *)makeImageAttributedString:(CGRect)frame urlString:(NSString *)urlString imageName:(NSString *)imageName;

/**
 直接生成字符富文本

 @param str 文字
 @return 富文本
 */
+ (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str;

/**
 生成带属性的富文本

 @param str 文本
 @param attribute 富文本字典
 @return 富文本
 */
+ (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str attributed:(NSDictionary *)attribute;

/// 生产文字富文本
/// @param string 文本
/// @param textColor 文本颜色
/// @param textFont 文本大小
/// @param alignmentFont 对其大小
+ (NSMutableAttributedString *)textAttributedString:(NSString *)string textColor:(UIColor *)textColor textFont:(UIFont *)textFont alignmentFont:(UIFont *)alignmentFont;

/// 生产文字富文本
/// @param string 文本
/// @param textColor 文本颜色
/// @param textFont 文本大小
/// @param alignmentFont 对其大小
/// @param fixedWidth 固定宽度，小于等于零为不固定（自动计算）
+ (NSMutableAttributedString *)textAttributedString:(NSString *)string textColor:(UIColor *)textColor textFont:(UIFont *)textFont alignmentFont:(UIFont *)alignmentFont fixedWidth:(CGFloat)fixedWidth;

/**
 生成指定宽度的占位富文本
 
 @param width 占位宽度
 @return 富文本
 */
+ (NSMutableAttributedString *)creatPlaceholderAttributedStringByWidth:(CGFloat)width;
+ (NSMutableAttributedString *)placeholderAttributedString:(CGFloat)width;

/**
 haha 专用, 根据是否靓号创建 昵称 富文本 (normalColor默认为r:51 g:51 b:51, 靓号颜色为r:235 g:83 b:53), 使用参数较多的方法, 颜色不传也会用此默认方法

 @param nickName 昵称
 @param font 字号
 @param hasPrettyErbanNo 是否靓号
 @param type 是使用label(yylabel限制宽度150)还是正常富文本的格式
 @param type type为BaseAttributedStringNickTypeUILabel限制的宽度, 如果传0则默认为150
 @return 富文本
 */
+ (NSMutableAttributedString *)creatNickNameAttributedStringByNickName:(NSString *)nickName font:(UIFont *)font hasPrettyErbanNo:(BOOL)hasPrettyErbanNo type:(BaseAttributedStringNickType)type limitWidth:(CGFloat)limitWidth;
+ (NSMutableAttributedString *)creatNickNameAttributedStringByNickName:(NSString *)nickName font:(UIFont *)font hasPrettyErbanNo:(BOOL)hasPrettyErbanNo type:(BaseAttributedStringNickType)type normalColor:(UIColor *)normalColor beautyColor:(UIColor *)beautyColor limitWidth:(CGFloat)limitWidth;

/// 官方主播认证标签
/// @param tagName 标签名
/// @param imageName 背景图片
+ (NSMutableAttributedString *)certificationTagWithName:(NSString *)tagName image:(NSString *)imageName;

/// 官方主播认证标签
/// @param tagName 标签名
/// @param imageName 背景图片
/// @param size 大小
/// @param textFont 文字大小
/// @param alignmentFont 对其大小
+ (NSMutableAttributedString *)certificationTagWithName:(NSString *)tagName image:(NSString *)imageName size:(CGSize)size textFont:(UIFont *)textFont alignmentFont:(UIFont *)alignmentFont;
@end
