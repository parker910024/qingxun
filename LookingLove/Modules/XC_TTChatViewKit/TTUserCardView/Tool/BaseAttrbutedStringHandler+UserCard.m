//
//  BaseAttrbutedStringHandler+UserCard.m
//  TuTu
//
//  Created by 卫明 on 2018/11/15.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+UserCard.h"

//theme
#import "XCTheme.h"
#import "NSString+Utils.h"

//3rd part
#import <YYText/YYText.h>

//helper
#import "TTNobleSourceHelper.h"

@implementation BaseAttrbutedStringHandler (UserCard)

+ (NSMutableAttributedString *)makeUserCardInfoByUserInfo:(UserInfo *)userInfo type:(ShowUserCardType)type {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@""];
    if (userInfo.nick.length > 0) {
        NSMutableAttributedString *nick;
        if (type == ShowUserCardType_Rank) {
          nick = [self makeLabelNick:userInfo.nobleUsers.rankHide ?  @"神秘人" : userInfo.nick  labelAttribute:@{k_NickLabel_Font:[UIFont systemFontOfSize:14.f],k_NickLabel_Color:UIColorFromRGB(0xffffff),k_NickLabel_MaxWidth:@(150)}];
        }else if(type == ShowUserCardType_Online){
            nick = [self makeLabelNick:userInfo.nobleUsers.enterHide ?  @"神秘人" : userInfo.nick  labelAttribute:@{k_NickLabel_Font:[UIFont systemFontOfSize:14.f],k_NickLabel_Color:UIColorFromRGB(0xffffff),k_NickLabel_MaxWidth:@(150)}];
        }else{
            nick = [self makeLabelNick:userInfo.nick  labelAttribute:@{k_NickLabel_Font:[UIFont systemFontOfSize:14.f],k_NickLabel_Color:UIColorFromRGB(0xffffff),k_NickLabel_MaxWidth:@(150),k_NickLabel_LabelHeight:@(20)}];
        }
       
        [string appendAttributedString:nick];
    }
    
    if (userInfo.gender == UserInfo_Male) {
        [string appendAttributedString:[self makeGender:BaseAttributedUserGender_Male size:CGSizeMake(13, 13)]];
    }else if (userInfo.gender == UserInfo_Female) {
        [string appendAttributedString:[self makeGender:BaseAttributedUserGender_Female size:CGSizeMake(13, 13)]];
    }
    [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    
    //换行
    [string appendAttributedString:[self creatStrAttrByStr:@"\n"]];
    
    //官|新|靓|性别|勋章|经验等级|魅力等级
    
    if (userInfo.nobleUsers.badge && userInfo.nobleUsers.level > 0) {
        [string appendAttributedString:[self makeNobleBadge:userInfo]];
        [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }

    //主播认证
    if (userInfo.nameplate && userInfo.nameplate.fixedWord.length > 0) {
        NSMutableAttributedString *tagImageString = [self certificationTagWithName:userInfo.nameplate.fixedWord image:userInfo.nameplate.iconPic];
        [string appendAttributedString:tagImageString];
        [string appendAttributedString:[self creatStrAttrByStr:@"  "]];
    }
    
    if (userInfo.userLevelVo.experUrl.length > 0) {
        [string appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 38, 15) urlString:userInfo.userLevelVo.experUrl imageName:nil]];
    }
    [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    if (userInfo.userLevelVo.charmUrl.length > 0) {
        [string appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 38, 15) urlString:userInfo.userLevelVo.charmUrl imageName:nil]];
    }
    
    //换行
    [string appendAttributedString:[self creatStrAttrByStr:@"\n"]];
    
    if (userInfo.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 10, 10) urlString:nil imageName:@"common_offical"];
        [string appendAttributedString:officalBadge];
        [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (userInfo.newUser) {
        NSMutableAttributedString *newUser = [self makeImageAttributedString:CGRectMake(0, 0, 10, 10) urlString:nil imageName:@"common_newuser"];
        [string appendAttributedString:newUser];
        [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    
    if (userInfo.hasPrettyErbanNo) {
        NSMutableAttributedString *pretty = [self makeImageAttributedString:CGRectMake(0, 0, 10, 10) urlString:nil imageName:@"common_beauty"];
        [string appendAttributedString:pretty];
        [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
   
    
    //ID
    if (userInfo.erbanNo.length > 0) {
        NSString *IDStr;
        if (type == ShowUserCardType_Rank) {
            IDStr = [NSString stringWithFormat:@"ID%@",userInfo.nobleUsers.rankHide ? @"********" : userInfo.erbanNo];
        }else if (type == ShowUserCardType_Online){
            IDStr = [NSString stringWithFormat:@"ID%@",userInfo.nobleUsers.enterHide ? @"********" : userInfo.erbanNo];
        }else{
            IDStr = [NSString stringWithFormat:@"ID%@", userInfo.erbanNo];
        }
        
        NSMutableAttributedString *ID = [[NSMutableAttributedString alloc]initWithString:IDStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [ID addAttribute:NSForegroundColorAttributeName value:UIColorRGBAlpha(0xffffff, 0.5) range:NSMakeRange(0, ID.length)];
        [string appendAttributedString:ID];
    }
    
    //换行
    [string appendAttributedString:[self creatStrAttrByStr:@"\n"]];
    
    NSMutableAttributedString *family = [[NSMutableAttributedString alloc] initWithString:@"所在家族"];
    [family addAttribute:NSForegroundColorAttributeName value:UIColorRGBAlpha(0xffffff, 0.5) range:NSMakeRange(0, family.length)];
    [family addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, family.length)];
    [string appendAttributedString:family];
    
    [string appendAttributedString:[self creatPlaceholderAttributedStringByWidth:12]];
    
    NSMutableAttributedString *familyName = [[NSMutableAttributedString alloc]initWithString:userInfo.family.familyName.length > 0 ? userInfo.family.familyName : @"未加入家族"];
    [familyName addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, familyName.length)];
    [familyName addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, familyName.length)];
    [string appendAttributedString:familyName];
    
    //主播认证标签
    if (userInfo.tagList.count > 0) {
        //换行
        [string appendAttributedString:[self creatStrAttrByStr:@"\n"]];
        [string appendAttributedString:[self anchorTagAttributedStringTags:userInfo.tagList]];
    }
    
    string.yy_lineSpacing = 3;
    
    return string;
}

/// 主播标签富文本
/// @param tagList 标签列表
+ (NSMutableAttributedString *)anchorTagAttributedStringTags:(NSArray *)tagList {
    
    if (tagList.count == 0) {
        return nil;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    for (NSString *tag in tagList) {
        if (str.length > 0) {
            [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:4]];
        }
        NSAttributedString *tagStr = [self tagAttributedString:tag];
        [str appendAttributedString:tagStr];
    }
    
    return str;
}

/// 主播标签富文本
/// @param tag 技能标签
+ (NSAttributedString *)tagAttributedString:(NSString *)tag {
    if (tag == nil) {
        return nil;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@", tag];
    UIFont *font = [UIFont systemFontOfSize:10];
    CGFloat width = [NSString sizeWithText:content font:font maxSize:CGSizeMake(200, 30)].width;
    
    width += 10;//边距
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, width, 15);
    label.font = font;
    label.text = content;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    label.backgroundColor = UIColorRGBAlpha(0xF2EEFF, 0.2);
    
    NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}

//nobleBadge
+ (NSMutableAttributedString *)makeNobleBadge:(UserInfo *)userInfo{
    UIImageView *nobleBadgeImageView = [[UIImageView alloc]init];
    [TTNobleSourceHelper disposeImageView:nobleBadgeImageView withSource:userInfo.nobleUsers.badge imageType:ImageTypeUserLibaryDetail];
    nobleBadgeImageView.bounds = CGRectMake(0, 0, 15, 15);
    nobleBadgeImageView.contentMode = UIViewContentModeScaleToFill;
    
    NSMutableAttributedString * nobleImageString = [NSMutableAttributedString yy_attachmentStringWithContent:nobleBadgeImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nobleBadgeImageView.frame.size.width, nobleBadgeImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return nobleImageString;
}
@end
