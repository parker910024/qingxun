//
//  BaseAttrbutedStringHandler+TTRoomModule.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+TTRoomModule.h"
#import "TTNobleSourceHandler.h"
#import "TTMessageViewConst.h"

//m
#import "UserInfo.h"
#import "RoomQueueCoreV2.h"
#import "Attachment.h"
#import "XCArrangeMicAttachment.h"
//t
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import <YYText/YYText.h>
#import <NIMSDK/NIMSDK.h>
#import "NSString+Utils.h"
#import "XCKeyWordTool.h"


@implementation BaseAttrbutedStringHandler (TTRoomModule)
#pragma mark - puble method
#pragma mark - 开箱子公屏信息
//创建开箱子公屏信息
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName uid:(NSString *)uid prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num {
    return [self createOpenBoxAttributedString:nickName uid:uid prizeName:prizeName prizeNum:num boxTypeStr:@"砸蛋获得了 "];
}

/// 创建开箱子公屏信息(新版)
/// @param nickName 用户昵称
/// @param uid 用户 uid
/// @param prizeName 奖品名称
/// @param num 奖品数量
/// @param boxTypeStr 砸蛋类型描述(金蛋，至尊蛋)
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName uid:(NSString *)uid prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num boxTypeStr:(NSString *)boxTypeStr {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:@"厉害了! "
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]]];
    
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:nickName
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:boxTypeStr
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:prizeName attributed:[self textAttributedWithColor:[XCTheme getTTRedColor] size:TTMessageViewDefaultFontSize]]];
    
    if (num.intValue>1) {
        [attributedString appendAttributedString:
         [self creatStrAttrByStr:[NSString stringWithFormat:@"x%d",num.intValue]
                      attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]]];
    }
    
    return attributedString;
}

+ (NSMutableAttributedString *)creatOnlineListUserNameWithGenderAttrWithUserInfo:(UserInfo *)userInfo {
    NSDictionary *attrbuted = @{
                                k_NickLabel_Font:[UIFont systemFontOfSize:15.f],
                                k_NickLabel_Color:UIColorFromRGB(0x333333),
                                k_NickLabel_MaxWidth:@(140)
                                };
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    
    if (userInfo.nick.length > 0) {
        [attr appendAttributedString:[self makeLabelNick:userInfo.nick labelAttribute:attrbuted]];
    }
    [attr appendAttributedString:[self creatStrAttrByStr:@"  "]];
    [attr appendAttributedString:[self genderAttributed:userInfo.gender]];
    
    return attr;
}

/**
 在线列表 用户名|性别|官
 @param userInfor 用户信息
 @param isHide 隐身
 */
+ (NSMutableAttributedString *)createOnlineListUserNameAndGenderAndOfficalWithUserInfor:(UserInfo *)userInfor isHide:(BOOL)isHide{
    NSDictionary *attrbuted = @{
                                k_NickLabel_Font:[UIFont systemFontOfSize:14.f],
                                k_NickLabel_Color:UIColorFromRGB(0xffffff),
                                k_NickLabel_MaxWidth:@(140),
                                k_NickLabel_LabelHeight:@(20)
                                };
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    
    //官方主播（非隐身下）
    if (!isHide && userInfor.nameplate && userInfor.nameplate.fixedWord.length>0) {
        [attr appendAttributedString:[self certificationTagWithName:userInfor.nameplate.fixedWord image:userInfor.nameplate.iconPic]];
        [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (isHide) {
        userInfor.nick = @"神秘人";
    }
    if (userInfor.nick.length > 0) {
        [attr appendAttributedString:[self makeLabelNick:userInfor.nick labelAttribute:attrbuted]];
    }
    [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    [attr appendAttributedString:[self genderAttributed:userInfor.gender]];
    [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    //官方
    if (userInfor.defUser == AccountType_Official) {
        [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"]];
         [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (userInfor.nobleUsers.level) {
        [attr appendAttributedString:[self badgeAttributed:userInfor.nobleUsers.badge]];
    }
    return attr;
}

//房间在线列表副标题（新 官方 房主 管理 等级 魅力值）
+ (NSMutableAttributedString *)roomOnlineSubTitleAttributedStringWithUserInfo:(UserInfo *)userInfo chatRoomMember:(NIMChatroomMember *)chatRoomMember {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    //新
    if (userInfo.newUser) {
        [attributedString appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_newuser"]];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    

    if (chatRoomMember.type == NIMChatroomMemberTypeCreator) {
        //房主
        [attributedString appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 38, 15) urlString:nil imageName:@"room_online_tag_owner"]];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    } else {
        //管理
        if (chatRoomMember.type == NIMChatroomMemberTypeManager) {
            [attributedString appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 38, 15) urlString:nil imageName:@"room_online_tag_manager"]];
            [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
        }
    }
    

    //经验值
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //魅力值
    if (userInfo.userLevelVo.charmUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.charmUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    return attributedString;
}

//名字|性别
+ (NSMutableAttributedString *)creatNickAndGenderAttributedStringByUserInfo:(UserInfo *)userInfo nameTextColor:(UIColor *)nameColor {
    return [self creatNickAndGenderAttributedStringByUserInfo:userInfo nameTextColor:nameColor nameFont:[UIFont systemFontOfSize:13]];
}

//名字|性别
+ (NSMutableAttributedString *)creatNickAndGenderAttributedStringByUserInfo:(UserInfo *)userInfo nameTextColor:(UIColor *)nameColor nameFont:(UIFont *)font {
    
    NSDictionary *attribute = @{k_NickLabel_Font:font,
                                k_NickLabel_Color:nameColor,
                                k_NickLabel_MaxWidth:@140};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[self makeLabelNick:userInfo.nick labelAttribute:attribute]];
    [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    [attributedString appendAttributedString:[self genderAttributed:userInfo.gender]];
    return attributedString;
}

//勋章|经验等级|魅力等级
+ (NSMutableAttributedString *)creatBadge_expLevel_charmLevelByUserInfo:(UserInfo *)userInfo {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (userInfo.nobleUsers.level) {
        [attributedString appendAttributedString:[self badgeAttributed:userInfo.nobleUsers.badge]];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    [attributedString appendAttributedString:[self makeExperImage:userInfo.userLevelVo.experUrl]];
    [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    [attributedString appendAttributedString:[self makeCharmImage:userInfo.userLevelVo.charmUrl]];
    return attributedString;
}

//兔兔号|粉丝数
+ (NSMutableAttributedString *)creatErbanNumAndFansAttributedStringByUserInfo:(UserInfo *)userInfo labelAttribute:(NSDictionary *)labelAttribute {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSString *erbanNo = [NSString stringWithFormat:@"%@号：%@ | %ld粉丝",[XCKeyWordTool sharedInstance].myAppName,userInfo.erbanNo,userInfo.fansNum];
    [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:erbanNo]];
    [attributedString addAttributes:@{NSFontAttributeName:labelAttribute[k_NickLabel_Font],
                                      NSForegroundColorAttributeName:labelAttribute[k_NickLabel_Color]
                                      } range:NSMakeRange(0, erbanNo.length)];
    return attributedString;
}

//家族
+ (NSMutableAttributedString *)creatFamilyStrByUserInfo:(UserInfo *)userInfo labelAttribute:(NSDictionary *)labelAttribute {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    NSString *family = [NSString stringWithFormat:@"TA的家族："];
    NSString *familyName = [NSString stringWithFormat:@"%@",userInfo.family.familyName];
    [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:family]];
    [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:familyName]];
    [attributedString addAttributes:@{NSFontAttributeName:labelAttribute[k_NickLabel_Font],
                                      NSForegroundColorAttributeName:labelAttribute[k_NickLabel_Color]
                                      } range:NSMakeRange(0, family.length)];
    if (userInfo.nobleUsers.level) {
        [attributedString addAttributes:@{NSFontAttributeName:labelAttribute[k_NickLabel_Font],
                                          NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
                                          } range:NSMakeRange(family.length, familyName.length)];
    }else {
        [attributedString addAttributes:@{NSFontAttributeName:labelAttribute[k_NickLabel_Font],
                                          NSForegroundColorAttributeName:UIColorFromRGB(0xfea700)
                                          } range:NSMakeRange(family.length, familyName.length)];
    }
    
    return attributedString;
}

//开通贵族提示卡片
+ (NSMutableAttributedString *)creatOpenNobleTipCardNeedLevelString:(NSString *)needLevel{
    
    NSMutableAttributedString *needAttributedString = [[NSMutableAttributedString alloc] init];
    NSString *needString = [NSString stringWithFormat:@"- 需开通%@ - \n",needLevel];
    
    NSMutableAttributedString *needLevelString = [self creatStrAttrByStr:needString attributed:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:23],
       NSForegroundColorAttributeName:UIColorFromRGB(0xE0B980)}];
    
   NSMutableAttributedString *needTipString = [self creatStrAttrByStr:@"才可使用该礼物" attributed:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
       NSForegroundColorAttributeName:UIColorFromRGB(0xE0B980)}];
    
    [needAttributedString appendAttributedString:needLevelString];
    [needAttributedString appendAttributedString:needTipString];
    needAttributedString.yy_alignment = NSTextAlignmentCenter;
    
    return needAttributedString;
}
+ (NSMutableAttributedString *)creatOpenNobleTipCardCurrentLevelString:(NSString *)currentLevel{
    
    NSMutableAttributedString *currentAttributedString = [[NSMutableAttributedString alloc] init];
    NSString *currentString = [NSString stringWithFormat:@"·当前为%@·",currentLevel];
    
    NSMutableAttributedString *currentLevelString = [self creatStrAttrByStr:currentString attributed:
                                                @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                                  NSForegroundColorAttributeName:UIColorFromRGB(0xE0B980)}];
    
    [currentAttributedString appendAttributedString:currentLevelString];
    currentAttributedString.yy_alignment = NSTextAlignmentCenter;
    return currentAttributedString;
}


//创建欢迎xx富文本
+ (NSMutableAttributedString *)creatWelcomeAttributedByNick:(NSString *)nick{
    if (nick.length == 0 || !nick) {
        nick = @" ";
    }
    NSString *str = [NSString stringWithFormat:@"欢迎“%@”光临本房间",nick];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFFFFF) range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] range:NSMakeRange(0, attr.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] range:NSMakeRange(2, nick.length + 2)];
    return attr;
}

//开通贵族富文本
+ (NSMutableAttributedString *)creatOpenNobleAttrByNick:(NSString *)nick nobleName:(NSString *)nobleName{
    if (nick.length == 0 || !nick) {
        nick = @" ";
    }
    NSMutableAttributedString *sourceStr = [[NSMutableAttributedString alloc] init];
    [sourceStr appendAttributedString:[self creatStrAttrByStr:@"恭喜"]];
    NSString *nickStr = [NSString stringWithFormat:@"”%@“",nick];
    [sourceStr appendAttributedString:[self creatStrAttrByStr:nickStr]];
    [sourceStr appendAttributedString:[self creatStrAttrByStr:@"开通"]];
    NSString *nobleNameStr = [NSString stringWithFormat:@"“%@”",nobleName];
    [sourceStr appendAttributedString:[self creatStrAttrByStr:nobleNameStr]];
    [sourceStr appendAttributedString:[self creatStrAttrByStr:@"贵族"]];
    
    [sourceStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, sourceStr.length)];
    [sourceStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF3CF77) range:NSMakeRange(2, nickStr.length)];
    [sourceStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF3CF77) range:NSMakeRange(4 + nickStr.length, nobleNameStr.length)];
    
    return sourceStr;
}


//房间排麦的公屏消息
+ (NSMutableAttributedString *)crateRoomArrangeMicWith:(Attachment *)attachment{
    NSMutableAttributedString * arrangeAtt = [[NSMutableAttributedString alloc] init];
    if (attachment) {
        //房间开启了排麦
        XCArrangeMicAttachment * arrangeMic = [XCArrangeMicAttachment yy_modelWithJSON:attachment.data];
        if (attachment.second == Custom_Noti_Header_ArrangeMic_Mode_Open) {
            NSString * title = @"管理员开启了排麦模式";
            [arrangeAtt appendAttributedString:[self creatStrAttrByStr:title attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize], NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}]];
             NSRange range = [title rangeOfString:@"开启了"];
            [arrangeAtt addAttribute:NSForegroundColorAttributeName value:UIColorRGBAlpha(0xffffff, 0.5) range:range];
        }else if (attachment.second == Custom_Noti_Header_ArrangeMic_Mode_Close){
            //房间关闭了排麦
            NSString * title = @"管理员关闭了排麦模式";
           [arrangeAtt appendAttributedString:[self creatStrAttrByStr:title attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize], NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}]];
            NSRange range = [title rangeOfString:@"关闭了"];
             [arrangeAtt addAttribute:NSForegroundColorAttributeName value:UIColorRGBAlpha(0xffffff, 0.5) range:range];
        }else if (attachment.second == Custom_Noti_Header_ArrangeMic_Free_Mic_Open){
            //将坑位设置成自由麦
            if ([arrangeMic.micPos intValue] != -1) {
                 NSString * micString = [NSString stringWithFormat:@"%ld麦", [arrangeMic.micPos integerValue] + 1];
                NSString * title = [NSString stringWithFormat:@"管理员设置%@为自由麦", micString];
                [arrangeAtt appendAttributedString:[self creatStrAttrByStr:title attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize], NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}]];
                NSRange range = [title rangeOfString:micString];
                [arrangeAtt addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainColor] range:range];
            }
        }else if (attachment.second == Custom_Noti_Header_ArrangeMic_Free_Mic_Close){
            //将坑位设置为排麦
            if ([arrangeMic.micPos intValue] != -1) {
                NSString * micString = [NSString stringWithFormat:@"%ld麦", [arrangeMic.micPos integerValue] + 1];
                NSString * title = [NSString stringWithFormat:@"管理员关闭%@自由麦", micString];
                [arrangeAtt appendAttributedString:[self creatStrAttrByStr:title attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize], NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}]];
                NSRange range = [title rangeOfString:micString];
                 [arrangeAtt addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewCPNickColor] range:range];
            }
        }
    }
    return arrangeAtt;
}

#pragma mark - private method
+ (NSDictionary *)textAttributedWithColor:(UIColor *)textColor size:(CGFloat)size{
    return @{NSForegroundColorAttributeName:textColor,NSFontAttributeName:[UIFont systemFontOfSize:size]};
}

//gender
+ (NSMutableAttributedString *)genderAttributed:(UserGender)gender {
    NSString *imageName = gender == UserInfo_Male ? [XCTheme defaultTheme].common_sex_male : [XCTheme defaultTheme].common_sex_female;
    NSMutableAttributedString * genderString = [self makeImageAttributedString:CGRectMake(5, 0, 15, 15) urlString:nil imageName:imageName];
    return genderString;
}

//nobleBadge
+ (NSMutableAttributedString *)badgeAttributed:(id)badge {
    UIImageView *nobleBadgeImageView = [[UIImageView alloc]init];
    [TTNobleSourceHandler handlerImageView:nobleBadgeImageView soure:badge imageType:ImageTypeUserLibaryDetail];
    nobleBadgeImageView.bounds = CGRectMake(0, 0, 15, 15);
    nobleBadgeImageView.contentMode = UIViewContentModeScaleToFill;
    
    NSMutableAttributedString * nobleImageString = [NSMutableAttributedString yy_attachmentStringWithContent:nobleBadgeImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nobleBadgeImageView.frame.size.width, nobleBadgeImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return nobleImageString;
}

@end
