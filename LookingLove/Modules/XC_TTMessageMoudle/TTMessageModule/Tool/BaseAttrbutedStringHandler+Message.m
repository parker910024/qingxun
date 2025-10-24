//
//  BaseAttrbutedStringHandler+Message.m
//  TTPlay
//
//  Created by Macx on 2019/1/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+Message.h"

#import "XCTheme.h"

#import <YYText/YYText.h>

@implementation BaseAttrbutedStringHandler (Message)
// 创建 昵称 + 性别富文本 (昵称限制4个字, 超过...)
+ (NSMutableAttributedString *)creatNick_SexLimitByUserInfo:(UserInfo *)userInfo textColor:(UIColor *)textColor font:(UIFont *)font {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    CGFloat space = 2;
    
    // nick
    NSString *nick = userInfo.nick;
    if (userInfo.nick.length > 4) {
        nick = [userInfo.nick substringToIndex:3];
        nick = [NSString stringWithFormat:@"%@...", nick];
    } else {
        nick = userInfo.nick;
    }
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:nick attributes:@{NSForegroundColorAttributeName : textColor, NSFontAttributeName : font}]];
    
    [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:space]];
    // sex
    if (userInfo.gender == BaseAttributedUserGender_Male) {
        [attr appendAttributedString:[self makeGender:BaseAttributedUserGender_Male size:CGSizeMake(11, 11)]];
    } else {
        [attr appendAttributedString:[self makeGender:BaseAttributedUserGender_Female size:CGSizeMake(11, 11)]];
    }
    
    return attr;
}

/** 姓名性别年龄富文本 */
+ (NSMutableAttributedString *)nickGenderAgeAttributedStringWithNick:(NSString *)nick gender:(UserGender)gender age:(NSInteger)age {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (nick) {
        if (nick.length > 7) {
            nick = [nick substringToIndex:7];
        }
        
        [attributedString appendAttributedString:[self creatStrAttrByStr:nick]];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
     
    attributedString.yy_color = [XCTheme getTTDeepGrayTextColor];
    attributedString.yy_font = [UIFont systemFontOfSize:15];
    
    BOOL male = gender == UserInfo_Male;
    if (age <= 0) {
        //性别
        BaseAttributedUserGender attrGender = male ? BaseAttributedUserGender_Male : BaseAttributedUserGender_Female;
        NSMutableAttributedString *genderAttributString = [self makeGender:attrGender];
        [attributedString appendAttributedString:genderAttributString];
        
    } else {
        // 性别，年龄
        NSString *genderImageName = male ? @"dynamic_info_male" : @"dynamic_info_female";
        UIColor *backgroundColor = male ? UIColorFromRGB(0x529EF2) : UIColorFromRGB(0xFC588F);
         
         UIButton *genderAgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        genderAgeButton.userInteractionEnabled = NO;
         [genderAgeButton setImage:[UIImage imageNamed:genderImageName] forState:UIControlStateNormal];
         [genderAgeButton setTitle:[NSString stringWithFormat:@"%ld", age] forState:UIControlStateNormal];
         [genderAgeButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
         [genderAgeButton setBackgroundColor:backgroundColor];
         genderAgeButton.frame = CGRectMake(0, 0, 30, 14);
         genderAgeButton.layer.cornerRadius = 3;
         genderAgeButton.layer.masksToBounds = YES;
         genderAgeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        
         NSMutableAttributedString *ageGenderAtt = [NSMutableAttributedString yy_attachmentStringWithContent:genderAgeButton contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(30, 14) alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
         [attributedString appendAttributedString:ageGenderAtt];
    }
    
     [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:4]];

    return attributedString;
}

@end
