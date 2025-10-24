//
//  BaseAttrbutedStringHandler.m
//  XCBaseUIKit
//
//  Created by 卫明何 on 2018/8/24.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
#import <UIKit/UIKit.h>

//3rd part
#import <YYText/YYText.h>

#import "XCMacros.h"

//theme
#import "XCTheme.h"

#import "NSDate+Util.h"
#import "UIImageView+QiNiu.h"
#import "CALayer+QiNiu.h"

@implementation BaseAttrbutedStringHandler

//nick
+ (NSMutableAttributedString *)makeNick:(NSString *)nick color:(UIColor *)color{
    if (nick.length == 0) {
        nick = @" ";
    }
    NSMutableAttributedString * nickString = [[NSMutableAttributedString alloc] initWithString:nick attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:color}];
    return nickString;
}
//LabelNick
+ (NSMutableAttributedString *)makeLabelNick:(NSString *)nick labelAttribute:(NSDictionary *)attribute{
    if (nick.length == 0) {
        nick = @" ";
    }
    CATextLayer *nickLayer = [[CATextLayer alloc]init];
    nickLayer.string = nick;
    nickLayer.wrapped = YES;
    nickLayer.contentsScale = [UIScreen mainScreen].scale;
        nickLayer.alignmentMode = kCAAlignmentLeft;
    nickLayer.truncationMode = kCATruncationEnd;
    
    
    UIFont *nickFont = attribute[k_NickLabel_Font];
    CFStringRef fontName = (__bridge CFStringRef)nickFont.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    nickLayer.font = fontRef;
    nickLayer.fontSize = nickFont.pointSize;
    CGFontRelease(fontRef);
    nickLayer.foregroundColor = ((UIColor *)attribute[k_NickLabel_Color]).CGColor;
    nickLayer.hidden = NO;
    
    CGFloat maxWidth = [attribute[k_NickLabel_MaxWidth] floatValue];
     CGFloat labelHeight = [attribute[k_NickLabel_LabelHeight] floatValue];
    CGFloat nickWidth = [self sizeWithText:nick font:attribute[k_NickLabel_Font] maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].width;
    if (labelHeight && labelHeight > 0 ) {
        if (nickWidth > maxWidth) {
            nickLayer.bounds = CGRectMake(0, 0, maxWidth - 10, labelHeight);
        }else {
            nickLayer.bounds = CGRectMake(0, 0, nickWidth+2, labelHeight);
        }
    }else{
        if (nickWidth > maxWidth) {
            nickLayer.bounds = CGRectMake(0, 0, maxWidth - 10, 18);
        }else {
            nickLayer.bounds = CGRectMake(0, 0, nickWidth+2, 18+2);
        }
    }
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLayer.frame.size.width, nickLayer.frame.size.height) alignToFont:attribute[k_NickLabel_Font] alignment:YYTextVerticalAlignmentCenter];
    [nickString addAttribute:NSBaselineOffsetAttributeName value:@(0.5) range:NSMakeRange(0, nickString.length)];
    return nickString;
}


//gender
+ (NSMutableAttributedString *)makeGender:(BaseAttributedUserGender)gender{
    return [self makeGender:gender size:CGSizeMake(15, 15)];
}
+ (NSMutableAttributedString *)makeGender:(BaseAttributedUserGender)gender size:(CGSize)size {
    
    CALayer *genderLayer = [[CALayer alloc]init];

    if (gender == BaseAttributedUserGender_Female) {
        genderLayer.contents = (__bridge id)[UIImage imageNamed:@"common_sex_female"].CGImage;
    }else if (gender == BaseAttributedUserGender_Male) {
        genderLayer.contents = (__bridge id)[UIImage imageNamed:@"common_sex_male"].CGImage;
    }

    genderLayer.bounds = CGRectMake(5, 0, size.width, size.height);
    genderLayer.contentsGravity = kCAGravityResizeAspect;
    genderLayer.contentsScale = [UIScreen mainScreen].scale;

    NSMutableAttributedString * genderString = [NSMutableAttributedString yy_attachmentStringWithContent:genderLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(genderLayer.frame.size.width, genderLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return genderString;
}

//erBanId
+ (NSMutableAttributedString *)makeErBanId:(NSString *)erbanNo{
    NSString *erBanId = [NSString stringWithFormat:@"ID:%@",erbanNo];
    CGFloat textWidth = [self sizeWithText:erBanId font:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].width;
    
    CATextLayer *textLabel = [[CATextLayer alloc]init];
    textLabel.string = erBanId;
    textLabel.alignmentMode = kCAAlignmentCenter;
    textLabel.backgroundColor = UIColorFromRGB(0x98c6ff).CGColor;
    textLabel.foregroundColor = [UIColor whiteColor].CGColor;
    textLabel.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = [UIFont systemFontOfSize:11];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    textLabel.font = fontRef;
    textLabel.fontSize = font.pointSize;
    CGFontRelease(fontRef);

    textLabel.bounds = CGRectMake(0, 0, textWidth+10, 15);


    NSMutableAttributedString * labelString = [NSMutableAttributedString yy_attachmentStringWithContent:textLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(textLabel.frame.size.width, textLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return labelString;
}

//dateLabel
+ (NSMutableAttributedString *)makeDateLabel:(long)birth{
    NSString *dateStr = [NSString stringWithFormat:@" %@ ",[NSDate calculateConstellationWithMonth:birth]];
    CGFloat dateWidth = [self sizeWithText:dateStr font:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].width;
    
    CATextLayer *dateLabel = [[CATextLayer alloc]init];
    dateLabel.string = dateStr;
    dateLabel.bounds = CGRectMake(0, 0, dateWidth+10, 15);
    dateLabel.alignmentMode = kCAAlignmentCenter;
    dateLabel.backgroundColor = UIColorFromRGB(0xFFA13C).CGColor;
    dateLabel.foregroundColor = [UIColor whiteColor].CGColor;
    dateLabel.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = [UIFont systemFontOfSize:11];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    dateLabel.font = fontRef;
    dateLabel.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    NSMutableAttributedString * dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:dateLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(dateLabel.frame.size.width, dateLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:11] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}


//beautyImage
+ (NSMutableAttributedString *)makeBeautyImage:(NSString *)imageName{
    return [self makeBeautyImage:imageName size:CGSizeMake(15, 15)];
}
+ (NSMutableAttributedString *)makeBeautyImage:(NSString *)imageName size:(CGSize)size {
    
    CALayer *beautyLayer = [[CALayer alloc]init];
    beautyLayer.contents = (__bridge id)[UIImage imageNamed:imageName.length > 0 ? imageName : @"common_beauty"].CGImage;
    beautyLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    beautyLayer.contentsGravity = kCAGravityResize;
    beautyLayer.contentsScale = [UIScreen mainScreen].scale;
    
    NSMutableAttributedString * beautyImageString = [NSMutableAttributedString yy_attachmentStringWithContent:beautyLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(beautyLayer.frame.size.width, beautyLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return beautyImageString;
}

//experImage
+ (NSMutableAttributedString *)makeExperImage:(NSString *)experUrl{
    return [self makeExperImage:experUrl size:CGSizeMake(34, 14)];
}
+ (NSMutableAttributedString *)makeExperImage:(NSString *)experUrl size:(CGSize)size {
    
    CALayer *experLayer = [[CALayer alloc]init];
    experLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    experLayer.contentsGravity = kCAGravityResize;
    experLayer.contentsScale = [UIScreen mainScreen].scale;
    [experLayer qn_setImageImageWithUrl:experUrl placeholderImage:nil type:ImageTypeUserLibary];

    NSMutableAttributedString * experImageString = [NSMutableAttributedString yy_attachmentStringWithContent:experLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(experLayer.frame.size.width, experLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return experImageString;
}

//charmImage
+ (NSMutableAttributedString *)makeCharmImage:(NSString *)charmUrl{
    return [self makeCharmImage:charmUrl size:CGSizeMake(34, 14)];
}
+ (NSMutableAttributedString *)makeCharmImage:(NSString *)charmUrl size:(CGSize)size {
    CALayer *charmLayer = [[CALayer alloc]init];
    charmLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    charmLayer.contentsGravity = kCAGravityResize;
    charmLayer.contentsScale = [UIScreen mainScreen].scale;
    [charmLayer qn_setImageImageWithUrl:charmUrl placeholderImage:nil type:ImageTypeUserLibary];

    NSMutableAttributedString * charmImageString = [NSMutableAttributedString yy_attachmentStringWithContent:charmLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(charmLayer.frame.size.width, charmLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return charmImageString;
}


//newUserImage
+ (NSMutableAttributedString *)makeNewUserImage:(NSString *)newUserIconUrl{
    return [self makeNewUserImage:newUserIconUrl size:CGSizeMake(15, 15)];
}
+ (NSMutableAttributedString *)makeNewUserImage:(NSString *)newUserIconUrl size:(CGSize)size {
    CALayer *newUserlayer = [[CALayer alloc]init];
    newUserlayer.bounds = CGRectMake(0, 0, size.width, size.height);
    newUserlayer.contentsGravity = kCAGravityResize;
    newUserlayer.contentsScale = [UIScreen mainScreen].scale;
    [newUserlayer qn_setImageImageWithUrl:newUserIconUrl placeholderImage:nil type:ImageTypeUserLibary];

    NSMutableAttributedString * newUserImageString = [NSMutableAttributedString yy_attachmentStringWithContent:newUserlayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(newUserlayer.frame.size.width, newUserlayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return newUserImageString;
}

+ (NSMutableAttributedString *)makeImageAttributedString:(CGRect)frame urlString:(NSString *)urlString imageName:(NSString *)imageName{
    
    CALayer *charmLayer = [[CALayer alloc]init];
    charmLayer.bounds = frame;
    charmLayer.contentsGravity = kCAGravityResize;
    charmLayer.contentsScale = [UIScreen mainScreen].scale;
    
    if (urlString.length>0) {
        [charmLayer qn_setImageImageWithUrl:urlString placeholderImage:nil type:ImageTypeUserLibary];
    }else{
        charmLayer.contents = (__bridge id)[UIImage imageNamed:imageName].CGImage;
    }
    NSMutableAttributedString * charmImageString = [NSMutableAttributedString yy_attachmentStringWithContent:charmLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(charmLayer.frame.size.width, charmLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return charmImageString;
}


+ (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str {
    if (str.length == 0 || !str) {
        str = @" ";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    return attr;
}

+ (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str attributed:(NSDictionary *)attribute{
    if (str.length == 0 || !str) {
        str = @" ";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes:attribute];
    return attr;
}

/// 生产文字富文本
/// @param string 文本
/// @param textColor 文本颜色
/// @param textFont 文本大小
/// @param alignmentFont 对其大小
+ (NSMutableAttributedString *)textAttributedString:(NSString *)string textColor:(UIColor *)textColor textFont:(UIFont *)textFont alignmentFont:(UIFont *)alignmentFont {
    
    return [self textAttributedString:string textColor:textColor textFont:textFont alignmentFont:alignmentFont fixedWidth:0];
}

/// 生产文字富文本
/// @param string 文本
/// @param textColor 文本颜色
/// @param textFont 文本大小
/// @param alignmentFont 对其大小
/// @param fixedWidth 固定宽度，小于等于零为不固定（自动计算）
+ (NSMutableAttributedString *)textAttributedString:(NSString *)string textColor:(UIColor *)textColor textFont:(UIFont *)textFont alignmentFont:(UIFont *)alignmentFont fixedWidth:(CGFloat)fixedWidth {
    
    CGFloat width = [self sizeWithText:string font:textFont maxSize:CGSizeMake(KScreenWidth, 50)].width+1;
    if (fixedWidth > 0) {
        width = fixedWidth;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, width, alignmentFont.pointSize);
    label.font = textFont;
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    
    NSMutableAttributedString *str = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:alignmentFont alignment:YYTextVerticalAlignmentCenter];
    return str;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSMutableAttributedString *)placeholderAttributedString:(CGFloat)width {
    return [self creatPlaceholderAttributedStringByWidth:width];
}

+ (NSMutableAttributedString *)creatPlaceholderAttributedStringByWidth:(CGFloat)width{
    
    CALayer *placeholderView = [[CALayer alloc]init];
    placeholderView.bounds = CGRectMake(0, 0, width, 1);
  
    NSMutableAttributedString * placeholderViewString = [NSMutableAttributedString yy_attachmentStringWithContent:placeholderView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(placeholderView.frame.size.width, placeholderView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return placeholderViewString;
}

+ (NSMutableAttributedString *)creatNickNameAttributedStringByNickName:(NSString *)nickName font:(UIFont *)font hasPrettyErbanNo:(BOOL)hasPrettyErbanNo type:(BaseAttributedStringNickType)type limitWidth:(CGFloat)limitWidth {
    return [self creatNickNameAttributedStringByNickName:nickName font:font hasPrettyErbanNo:hasPrettyErbanNo type:type normalColor:RGBCOLOR(51, 51, 51) beautyColor:RGBCOLOR(235, 83, 53) limitWidth:limitWidth];
}

+ (NSMutableAttributedString *)creatNickNameAttributedStringByNickName:(NSString *)nickName font:(UIFont *)font hasPrettyErbanNo:(BOOL)hasPrettyErbanNo type:(BaseAttributedStringNickType)type normalColor:(UIColor *)normalColor beautyColor:(UIColor *)beautyColor limitWidth:(CGFloat)limitWidth {
    if (nickName.length == 0) {
        nickName = @" ";
    }
    
    UIColor *nickColor = normalColor;
    if (hasPrettyErbanNo) { // 靓号
        nickColor = beautyColor ? beautyColor : RGBCOLOR(235, 83, 53);
    } else {
        nickColor = normalColor ? normalColor : RGBCOLOR(51, 51, 51);
    }
    
    NSMutableAttributedString *nickString;
    if (type == BaseAttributedStringNickTypeUILabel) {
        
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.text = nickName;
        nickLabel.numberOfLines = 1;
        nickLabel.hidden = NO;
        nickLabel.font = font;
        nickLabel.textColor = nickColor;
        
        CGFloat maxWidth = limitWidth ? limitWidth : 150;
        CGFloat nickWidth = [self sizeWithText:nickName font:font maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].width;
        CGFloat nickHeight = [self sizeWithText:nickName font:font maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].height;
        if (nickWidth > maxWidth) {
            nickLabel.bounds = CGRectMake(0, 0, maxWidth - 10, nickHeight);
        } else {
            nickLabel.bounds = CGRectMake(0, 0, nickWidth + 0.5, nickHeight);
        }
        nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
    } else {
        nickString = [[NSMutableAttributedString alloc] initWithString:nickName attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:nickColor}];
    }
    return nickString;
}

/// 官方主播认证标签
/// @param tagName 标签名
/// @param imageName 背景图片
+ (NSMutableAttributedString *)certificationTagWithName:(NSString *)tagName image:(NSString *)imageName {
    return [self certificationTagWithName:tagName image:imageName size:CGSizeMake(60, 15) textFont:[UIFont systemFontOfSize:9] alignmentFont:[UIFont systemFontOfSize:15]];
}

/// 官方主播认证标签
/// @param tagName 标签名
/// @param imageName 背景图片
/// @param size 大小
/// @param textFont 文字大小
/// @param alignmentFont 对其大小
+ (NSMutableAttributedString *)certificationTagWithName:(NSString *)tagName image:(NSString *)imageName size:(CGSize)size textFont:(UIFont *)textFont alignmentFont:(UIFont *)alignmentFont {

    if (tagName == nil || tagName.length == 0) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    [imageView qn_setImageImageWithUrl:imageName placeholderImage:nil type:ImageTypeUserLibaryDetail success:^(UIImage * _Nonnull image) {
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(17, 0, 40, 15);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = UIColor.whiteColor;
    label.text = tagName;
    [imageView addSubview:label];
    
    NSMutableAttributedString *string = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:size alignToFont:alignmentFont alignment:YYTextVerticalAlignmentCenter];
    return string;
}

@end
