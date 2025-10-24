//
//  BaseAttrbutedStringHandler+TTDynamicInfo.m
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/23.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"
#import "LLDynamicModel.h"
#import <YYText/YYText.h>
#import "XCTheme.h"
#import "TTNobleSourceHelper.h"

#import "NSString+Utils.h"

@implementation BaseAttrbutedStringHandler (TTDynamicInfo)
/** 创建 爵位|等级|魅力等级|星座 */
 + (NSMutableAttributedString *)creatNick_userAge_charmRank_constellationByDynamicModel:(LLDynamicModel *)dynamicModel {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    
    if (!dynamicModel) {
        //        NSAssert(NO, @"must have userInfo data.");
        return attributedString;
    }
    
    if (dynamicModel.nick) {
        NSString *nick = dynamicModel.nick;
        if (nick.length > 6) {
            nick = [nick substringToIndex:6];
            nick = [NSString stringWithFormat:@"%@...", nick];
        }
        
//        [attributedString appendAttributedString:[self creatStrAttrByStr:nick]];
        NSMutableAttributedString *nickName = [[NSMutableAttributedString alloc] initWithString:nick];
        nickName.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        nickName.yy_color = [XCTheme getTTMainTextColor];
        
        [attributedString appendAttributedString:nickName];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
     
     NSString *genderImageName;
     UIColor *backgroundColor = UIColorFromRGB(0xFC588F); // 默认女性用户的背景色
     
     if (dynamicModel.gender == 1) { // 男性
         genderImageName = @"dynamic_info_male_big";
         backgroundColor = UIColorFromRGB(0x2FB5FC);
     } else if (dynamicModel.gender == 2) { // 女性
         genderImageName = @"dynamic_info_female_big";
         backgroundColor = UIColorFromRGB(0xFC588F);
     }
     
     UIButton *ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [ageButton setImage:[UIImage imageNamed:genderImageName] forState:UIControlStateNormal];
     [ageButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
     [ageButton setBackgroundColor:backgroundColor];
     ageButton.layer.cornerRadius = 7;
     ageButton.layer.masksToBounds = YES;
     ageButton.userInteractionEnabled = NO;
     
     CGRect rect = CGRectMake(0, 0, 14, 14);
     if (dynamicModel.age) {
         [ageButton setTitle:[NSString stringWithFormat:@" %ld", (long)dynamicModel.age] forState:UIControlStateNormal];
         rect = CGRectMake(0, 0, 30, 14);
         ageButton.imageEdgeInsets = UIEdgeInsetsZero;
         
         if (dynamicModel.gender == 1) { // 男性
             genderImageName = @"dynamic_info_male";
             backgroundColor = UIColorFromRGB(0x2FB5FC);
         } else if (dynamicModel.gender == 2) { // 女性
             genderImageName = @"dynamic_info_female";
             backgroundColor = UIColorFromRGB(0xFC588F);
         }
         [ageButton setImage:[UIImage imageNamed:genderImageName] forState:UIControlStateNormal];
     }
     ageButton.frame = rect;
     
     NSMutableAttributedString *ageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:ageButton contentMode:UIViewContentModeScaleAspectFit attachmentSize:rect.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
    
     // 性别，年龄
     [attributedString appendAttributedString:ageAtt];
     [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
     
     // 如果是官方号
     if (dynamicModel.defUser == 2) {
         [attributedString appendAttributedString:[self makeBeautyImage:@"dynamic_Official_icon" size:CGSizeMake(13, 13)]];
         [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
     }
    
    // title 爵位
    if (dynamicModel.badge) {
        NSMutableAttributedString *titleImageString = [TTNobleSourceHelper creatDynamicNobleBadge:dynamicModel.badge size:CGSizeMake(16, 15)];
        [attributedString appendAttributedString:titleImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    return attributedString;
}

// 创建动态内容 首贴标签-内容
+ (NSMutableAttributedString *)creatFirstDynamicIcon_content:(LLDynamicModel *)dynamicModel {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (dynamicModel.isFirstDynamic) {
        [attributedString appendAttributedString:[self makeBeautyImage:@"dynamic_first_icon" size:CGSizeMake(32, 15)]];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    [attributedString appendAttributedString:[self creatStrAttrByStr:dynamicModel.content attributed:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}]];
    attributedString.yy_lineSpacing = 5;
    return attributedString;
}

/// 主播技能标签富文本
/// @param tag 技能标签
/// @param color 显示颜色
+ (NSAttributedString *)anchorSkillTagAttributedStringWithLabel:(NSString *)tag color:(UIColor *)color {
    if (tag == nil) {
        return nil;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@", tag];
    UIFont *font = [UIFont systemFontOfSize:10];
    CGFloat width = [NSString sizeWithText:content font:font maxSize:CGSizeMake(200, 30)].width;
    width += 10;//两边距
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, width, 15);
    label.font = font;
    label.text = content;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = color.CGColor;
    label.layer.borderWidth = 0.5;
    
    NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}

@end
