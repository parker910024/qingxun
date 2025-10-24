//
//  BaseAttrbutedStringHandler+TTGuildInfo.m
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+TTGuildInfo.h"
#import "TTNobleSourceHelper.h"
//view
#import <YYText/YYText.h>
//model
#import "UserInfo.h"
//t
#import "NSDate+Util.h"
#import "XCTheme.h"
#import "XCMacros.h"

@implementation BaseAttrbutedStringHandler (TTGuildInfo)

+ (NSMutableAttributedString *)creatName_Sex_userRank_charmRankByUserInfo:(UserInfo *)userInfo {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (!userInfo) {
        //        NSAssert(NO, @"must have userInfo data.");
        return attributedString;
    }
    
    if (userInfo.nick.length > 0) {
        NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15.f],
                                    k_NickLabel_Color:UIColorFromRGB(0x333333),
                                    k_NickLabel_MaxWidth:@(120)
                                    };
        NSMutableAttributedString *nickAttri = [self makeLabelNick:userInfo.nick labelAttribute:attribute];
        [attributedString appendAttributedString:nickAttri];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    BaseAttributedUserGender gender;
    if (userInfo.gender == UserInfo_Male) {
        gender = BaseAttributedUserGender_Male;
    }else{
        gender = BaseAttributedUserGender_Female;
    }
    NSMutableAttributedString * genderAttributString = [self makeGender:gender];
    [attributedString appendAttributedString:genderAttributString];
    [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];

    // userRank 用户级别
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl size:CGSizeMake(35, 14)];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //charmRank  魅力等级
    if (userInfo.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:userInfo.userLevelVo.charmUrl size:CGSizeMake(30, 14)];
        [attributedString appendAttributedString:charmImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    return attributedString;
}


@end
