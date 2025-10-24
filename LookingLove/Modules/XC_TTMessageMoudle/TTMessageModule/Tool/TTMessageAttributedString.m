//
//  TTMessageAttributedString.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageAttributedString.h"
#import "XCTheme.h"
#import "NobleCore.h"
#import "TTNobleSourceHelper.h"
#import <YYText.h>

@implementation TTMessageAttributedString

+ (NSMutableAttributedString *)createMessageNameWith:(UserInfo *)userInfo{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]init];
    if (userInfo.nick) {
      // 55 头像的宽度 15 头像距离左边的距离 65+15 找到他的那个按钮以及距离右边的间距 5 找到他和nick的距离  性别以及间隙14+5
        CGFloat width =KScreenWidth - 55- 15- 19 -80 - 30;
        // noble
        if (userInfo.nobleUsers.level) {
            width  = width - 19;
        }
        //userLevel
        if (userInfo.userLevelVo.experUrl) {
            width  = width - 39;
        }
        //charmLevel
        if (userInfo.userLevelVo.charmUrl) {
            width  = width - 34;
        }
        
        NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                    k_NickLabel_Color:[XCTheme getTTMainTextColor],
                                    k_NickLabel_MaxWidth:@(width),
                                    k_NickLabel_LabelHeight:@(22)
                                    };
        [attributedString appendAttributedString:[self makeLabelNick:userInfo.nick labelAttribute:attribute]];
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
    [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    
    if (userInfo.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
        [attributedString appendAttributedString:officalBadge];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    // noble
    if (userInfo.nobleUsers.level) {
        NSMutableAttributedString *nobleImageString = [TTNobleSourceHelper creatNobleBadge:userInfo size:CGSizeMake(14, 14)];
        [attributedString appendAttributedString:nobleImageString];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    //userLevel
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    //charmLevel
    if (userInfo.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:userInfo.userLevelVo.charmUrl];
        [attributedString appendAttributedString:charmImageString];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
   
    return attributedString;
}

/** 通过attention 创建富文本*/
+ (NSMutableAttributedString *)createMessageNameWithAttention:(Attention *)attention{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]init];
    if (attention.nick) {
        CGFloat width =KScreenWidth - 55- 15- 19 -80 - 20;
        // noble
        if (attention.nobleUsers.level) {
            width  = width - 19;
        }
        //userLevel
        if (attention.userLevelVo.experUrl) {
           width  = width - 39;
        }
        //charmLevel
        if (attention.userLevelVo.charmUrl) {
          width  = width - 34;
        }

        if (attention.defUser == AccountType_Official) {
           width  = width - 18;
        }
        
        NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                    k_NickLabel_Color:[XCTheme getTTMainTextColor],
                                    k_NickLabel_MaxWidth:@(width),
                                    k_NickLabel_LabelHeight:@(22)
                                    };
        [attributedString appendAttributedString:[self makeLabelNick:attention.nick labelAttribute:attribute]];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    

    BaseAttributedUserGender gender;
    if (attention.gender == UserInfo_Male) {
        gender = BaseAttributedUserGender_Male;
    }else{
        gender = BaseAttributedUserGender_Female;
    }
    NSMutableAttributedString * genderAttributString = [self makeGender:gender];
    [attributedString appendAttributedString:genderAttributString];
    [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    //官
    if (attention.defUser == AccountType_Official) {
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
        [attributedString appendAttributedString:officalBadge];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    // noble
    if (attention.nobleUsers.level) {
        UserInfo * infor = [UserInfo modelDictionary:[attention model2dictionary]];
        NSMutableAttributedString *nobleImageString = [TTNobleSourceHelper creatNobleBadge:infor size:CGSizeMake(14, 14)];
        [attributedString appendAttributedString:nobleImageString];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    //userLevel
    if (attention.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:attention.userLevelVo.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    //charmLevel
    if (attention.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:attention.userLevelVo.charmUrl];
        [attributedString appendAttributedString:charmImageString];
    }
    
    return attributedString;
}

+ (NSMutableAttributedString *)creatResultByMessageStatus:(Message_Bussiness_Status)messageStatus nick:(nullable NSString *)nick {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    switch (messageStatus) {
        case Message_Bussiness_Status_Agree:
        {
            [attr appendAttributedString:[self makeBussinessResult:messageStatus]];
            if (nick.length > 0) {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
                [attr appendAttributedString:[self creatStrAttrByStr:@"已被" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0x67cd44)]];
                [attr appendAttributedString:[self creatStrAttrByStr:nick font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0x67cd44)]];
                [attr appendAttributedString:[self creatStrAttrByStr:@"同意" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0x67cd44)]];
                
            }else {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
                [attr appendAttributedString:[self creatStrAttrByStr:@"已同意" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0x67cd44)]];
            }
            
        }
            break;
        case Message_Bussiness_Status_Refused:
        {
            [attr appendAttributedString:[self makeBussinessResult:messageStatus]];
            if (nick.length > 0) {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
                [attr appendAttributedString:[self creatStrAttrByStr:@"已被" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0xff6565)]];
                [attr appendAttributedString:[self creatStrAttrByStr:nick font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0xff6565)]];
                [attr appendAttributedString:[self creatStrAttrByStr:@"拒绝" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0xff6565)]];
                
            }else {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
                [attr appendAttributedString:[self creatStrAttrByStr:@"已拒绝" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0xff6565)]];
            }
        }
            break;
        case Message_Bussiness_Status_OutDate:
        {
            [attr appendAttributedString:[self creatStrAttrByStr:@"消息已过期" font:[UIFont systemFontOfSize:14.f] textColor:UIColorFromRGB(0xff6565)]];
        }
            break;
        case Message_Bussiness_Status_Untreated:
        default:
            break;
    }
    return attr;
}

//创建原生勋章富文本
+ (NSMutableAttributedString *)creatOrignBadgeAttributedbyUserInfo:(SingleNobleInfo *)nobleInfo {
    if (!nobleInfo) {
        return [self creatStrAttrByStr:@""];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if ([nobleInfo.badge isKindOfClass:[NSString class]]) {
        UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:nobleInfo.badge];
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.bounds = CGRectMake(0, -3, 20, 20);
        imageAttachment.image = image;
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attributedString appendAttributedString:imageString];
    }
    
    return attributedString;
}

//result Icon
+ (NSMutableAttributedString *)makeBussinessResult:(Message_Bussiness_Status)messageStatus{
    UIImageView *resultImage = [[UIImageView alloc]init];
    if (messageStatus == Message_Bussiness_Status_Agree) {
        resultImage.image = [UIImage imageNamed:@"message_common_agree"];
    }else if (messageStatus == Message_Bussiness_Status_Refused) {
        resultImage.image = [UIImage imageNamed:@"message_common_disagress"];
    }
    
    resultImage.bounds = CGRectMake(5, 0, 19, 19);
    NSMutableAttributedString * resultString = [NSMutableAttributedString yy_attachmentStringWithContent:resultImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(resultImage.frame.size.width, resultImage.frame.size.height) alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
    return resultString;
}

+ (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor{
    if (str.length == 0 || !str) {
        str = @" ";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, attr.length)];
    return attr;
}

@end
