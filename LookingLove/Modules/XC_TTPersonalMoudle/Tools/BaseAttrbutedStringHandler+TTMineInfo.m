//
//  BaseAttrbutedStringHandler+TTMineInfo.m
//  TuTu
//
//  Created by lee on 2018/11/17.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+TTMineInfo.h"
#import "TTNobleSourceHelper.h"
//view
#import <YYText/YYText.h>
//model
#import "UserInfo.h"
//t
#import "NSDate+Util.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCKeyWordTool.h"

@implementation BaseAttrbutedStringHandler (TTMineInfo)

+ (NSMutableAttributedString *)creatTitle_userRank_charmRank_constellationByUserInfo:(UserInfo *)userInfo {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    
    if (!userInfo) {
        //        NSAssert(NO, @"must have userInfo data.");
        return attributedString;
    }
    // title 爵位
    if (userInfo.nobleUsers.badge) {
        NSMutableAttributedString *titleImageString = [TTNobleSourceHelper creatNobleBadge:userInfo size:CGSizeMake(16, 15)];
        [attributedString appendAttributedString:titleImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    
    //主播认证
    if (userInfo.nameplate && userInfo.nameplate.fixedWord.length>0) {
        NSMutableAttributedString *tagImageString = [self certificationTagWithName:userInfo.nameplate.fixedWord image:userInfo.nameplate.iconPic];
        [attributedString appendAttributedString:tagImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    
    // userRank 用户级别
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl size:CGSizeMake(38, 15)];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    
    //charmRank  魅力等级
    if (userInfo.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:userInfo.userLevelVo.charmUrl size:CGSizeMake(38, 15)];
        [attributedString appendAttributedString:charmImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    
    // constellation 星座
    if (userInfo.birth) {
        NSMutableAttributedString *constellationString = [self makeDateLabel:userInfo.birth color:UIColorFromRGB(0x4D73E8)];
        [attributedString appendAttributedString:constellationString];
    }
    
    return attributedString;
}


/** 创建 爵位 | 靓 | 星座 |ID*/
+ (NSMutableAttributedString *)creatTitle_Beauty_Constellation_IDByUserInfo:(UserInfo *)userInfo {
    // title 爵位
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (!userInfo) {
        //        NSAssert(NO, @"must have userInfo data.");
        return attributedString;
    }

#pragma mark - 需要注意的点！
    // 空格内容，必须统一添加到内容的后面，不可以不添加空格内容，否则会出现空格过大，或者因为没有空格导致两个内容积压在一起
    if (userInfo.nobleUsers.badge) {
        NSMutableAttributedString *titleImageString = [TTNobleSourceHelper creatNobleBadge:userInfo size:CGSizeMake(16, 15)];
        [attributedString appendAttributedString:titleImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //主播认证
    if (userInfo.nameplate && userInfo.nameplate.fixedWord.length>0) {
        NSMutableAttributedString *tagImageString = [self certificationTagWithName:userInfo.nameplate.fixedWord image:userInfo.nameplate.iconPic];
        [attributedString appendAttributedString:tagImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    
    // constellation 星座
    if (userInfo.birth) {
        NSMutableAttributedString *constellationString = [self makeDateLabel:userInfo.birth color:UIColorFromRGB(0x4D73E8)];
        constellationString.yy_baselineOffset = @(2);
        [attributedString appendAttributedString:constellationString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
        
    }
    
    [attributedString appendAttributedString:[self creatStrAttrByStr:@"\n"]];
    if (userInfo.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
        [attributedString appendAttributedString:officalBadge];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (userInfo.newUser) {
        NSMutableAttributedString *newUser = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_newuser"];
        [attributedString appendAttributedString:newUser];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    //靓
    if (userInfo.hasPrettyErbanNo) {
        [attributedString appendAttributedString:[self makeBeautyImage:@"common_beauty" size:CGSizeMake(13, 13)]];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    if (userInfo.erbanNo) {
        NSString * idString = [NSString stringWithFormat:@"ID:%@", userInfo.erbanNo];
        [attributedString  appendAttributedString:[self creatStrAttrByStr:idString attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[XCTheme getTTMainTextColor]}]];
    }
    // 因为换行，设置行间距
    [attributedString setYy_lineSpacing:4];

    return attributedString;
}

/**
 官|良|ID
 */
+ (NSMutableAttributedString *)createTitle_Offical_Beauty_IDWith:(UserInfo *)info{
    NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] init];
    
    if (info.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
        [attribut appendAttributedString:officalBadge];
        [attribut appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (info.hasPrettyErbanNo) {
        [attribut appendAttributedString:[self makeBeautyImage]];
        [attribut appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    [attribut appendAttributedString:[self creatStrAttrByStr:[NSString stringWithFormat:@"%@号：%@",[XCKeyWordTool sharedInstance].myAppName,info.erbanNo] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:UIColorFromRGB(0xf5f5f5)}]];
    
    return attribut;
}

/**
 官 | 靓 | ID | 地理信息
 
 @param info 用户信息
 */
+ (NSMutableAttributedString *)createTitle_Offical_Beauty_ID_LoactionWith:(UserInfo *)info {
    NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] init];
    
    if (info.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
        [attribut appendAttributedString:officalBadge];
        [attribut appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (info.hasPrettyErbanNo) {
        [attribut appendAttributedString:[self makeBeautyImage]];
        [attribut appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    [attribut appendAttributedString:[self creatStrAttrByStr:[NSString stringWithFormat:@"ID：%@",info.erbanNo] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:UIColorFromRGB(0xf5f5f5)}]];
    
    if (info.userExpand && info.userExpand.showLocation) { // 是否有地理位置拓展
        if (info.userExpand.provinceName.length > 0 &&
            info.userExpand.cityName.length > 0) {
            // 如果有省市字段
            // 图标
            [attribut appendAttributedString:[self creatPlaceholderAttributedStringByWidth:13]];
            NSMutableAttributedString *locationIcon = [self makeImageAttributedString:CGRectMake(0, 0, 12, 12) urlString:nil imageName:@"mineInfo_location_icon"];
            [attribut appendAttributedString:locationIcon];
            // 省
            [attribut appendAttributedString:[self creatStrAttrByStr:@" "]];
            [attribut appendAttributedString:[self creatStrAttrByStr:info.userExpand.provinceName attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:UIColorFromRGB(0xf5f5f5)}]];
            // 市
            [attribut appendAttributedString:[self creatStrAttrByStr:@" "]];
            [attribut appendAttributedString:[self creatStrAttrByStr:info.userExpand.cityName attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:UIColorFromRGB(0xf5f5f5)}]];
        }
    }
    
    return attribut;
}

//靓
+ (NSAttributedString *)makeBeautyImage {
    return [self makeBeautyImage:@"common_beauty" size:CGSizeMake(13, 13)];
}

//IDlabel
+ (NSMutableAttributedString *)makeIDLabel {
    UIFont *font = [UIFont systemFontOfSize:13];
    NSString *ID = @"ID";
    UILabel *nickLabel = [[UILabel alloc]init];
    nickLabel.text = ID;
    nickLabel.font = font;
    nickLabel.textColor = UIColorFromRGB(0xffffff);
    nickLabel.bounds = CGRectMake(0, 0, 13, 13);
    nickLabel.layer.masksToBounds = YES;
    nickLabel.layer.cornerRadius = 13/2;
    nickLabel.textAlignment = NSTextAlignmentCenter;
    nickLabel.backgroundColor = UIColorFromRGB(0xB2B2B2);
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

//dateLabel
+ (NSMutableAttributedString *)makeDateLabel:(long)birth color:(UIColor *)color{
    NSString *dateStr = [NSString stringWithFormat:@" %@ ",[NSDate calculateConstellationWithMonth:birth]];
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.bounds = CGRectMake(0, 0, 42, 15);
    dateLabel.text = dateStr;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.backgroundColor = color;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.layer.cornerRadius = 15/2;
    dateLabel.layer.masksToBounds = YES;
    NSMutableAttributedString * dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:dateLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(dateLabel.frame.size.width, dateLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}

//铭牌时间
+ (NSMutableAttributedString *)creatNameplateTitle:(NSInteger)time {
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString * charmImageString = [self makeImageAttributedString:CGRectMake(0, 0, 12, 12) urlString:@"" imageName:@"person_nameplate_time"];
    [attributedString appendAttributedString:charmImageString];
    NSString *dateStr = @"";

    if (time < 0) {
        dateStr = @" 已过期";
    } else {
        dateStr = [NSString stringWithFormat:@" 剩余%ld天",(long)time];
    }
    [attributedString appendAttributedString:[self creatStrAttrByStr:dateStr attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:UIColorFromRGB(0x9A9A9A)}]];
    return attributedString;
}
@end
