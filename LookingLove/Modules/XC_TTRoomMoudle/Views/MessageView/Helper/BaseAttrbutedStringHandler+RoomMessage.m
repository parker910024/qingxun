//
//  BaseAttrbutedStringHandler+RoomMessage.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+RoomMessage.h"
#import "TTMessageViewConst.h"
#import "TTNobleSourceHandler.h"

#import "XCTheme.h"
#import <YYText.h>
#import "CALayer+QiNiu.h"

#import "UIImageView+QiNiu.h"
#import "PrivilegeInfo.h"

@implementation BaseAttrbutedStringHandler (RoomMessage)

#pragma mark - puble method
//创建 官|用户等级|昵称
+ (NSMutableAttributedString *)creatOffical_nobleBadge_userLevel_nickAttributedByUserInfo:(UserInfo *)userInfo{
    return [self creatOffical_nobleBadge_userLevel_nickAttributedByUserInfo:userInfo nickType:BaseAttributedStringNickTypeeString labelAttribute:nil];
}

+ (NSMutableAttributedString *)creatOffical_nobleBadge_userLevel_nickAttributedByUserInfo:(UserInfo *)userInfo nickType:(BaseAttributedStringNickType)nickType labelAttribute:(NSDictionary *)labelAttribute{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (userInfo.nick.length == 0 || !userInfo.nick) {
        userInfo.nick = @" ";
    }
    //offical
    if (userInfo.defUser == AccountType_Official) {
        NSMutableAttributedString * officalImageString = [self makeOfficalImage:userInfo];
        [attributedString appendAttributedString:officalImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }else{
        if (userInfo.newUser) {
             NSMutableAttributedString *newUser = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_newuser"];
            [attributedString appendAttributedString:newUser];
            [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
        }
    }
    
    //noble
    if (userInfo.nobleUsers.level) {
        NSMutableAttributedString * nobleImageString = [self makeNobleBadge:userInfo];
        [attributedString appendAttributedString:nobleImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //主播铭牌
    if (userInfo.nameplate && userInfo.nameplate.fixedWord.length>0) {
        NSMutableAttributedString *certTag = [self certificationTagWithName:userInfo.nameplate.fixedWord image:userInfo.nameplate.iconPic];
        [attributedString appendAttributedString:certTag];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //userLevel
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //基线调整，让noble和userLevel下调，以和nick对齐
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@-1 range:NSMakeRange(0, attributedString.length)];

    //nick
    if (nickType == BaseAttributedStringNickTypeeString) {
        [attributedString appendAttributedString:[self makeNick:userInfo.nick color:[UIColor blackColor]]];
    }else if (nickType == BaseAttributedStringNickTypeUILabel){
        [attributedString appendAttributedString:[self makeLabelNick:userInfo.nick labelAttribute:labelAttribute]];
    }
    
    return attributedString;
}


#pragma mark - 开箱子公屏信息

//创建开箱子公屏信息（兼容旧版 or 其他 App)
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num{
    return [self createOpenBoxAttributedString:nickName prizeName:prizeName prizeNum:num boxTypeStr:@"砸蛋获得了 "];
}

/// 创建开箱子公屏信息
/// @param nickName 用户昵称
/// @param prizeName 奖品名称
/// @param num 奖品数量
/// @param boxTypeStr 砸蛋方式(金蛋，至尊蛋)
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num boxTypeStr:(NSString *)boxTypeStr {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:@"厉害了! "
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:nickName
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:boxTypeStr
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:prizeName attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    
    if (num.intValue>1) {
        [attributedString appendAttributedString:
         [self creatStrAttrByStr:[NSString stringWithFormat:@"x%d",num.intValue]
                      attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTextColor] size:TTMessageViewDefaultFontSize]]];
    }
    
    return attributedString;
}

//创建开箱子 全麦送 公屏信息
+ (NSMutableAttributedString *)createOpenBoxAllMicroSendAttributedString:(NSString *)nickName prizeValue:(NSInteger)value prizeUrl:(NSString *)prizUrl prizeNum:(NSInteger)num {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:@"厉害了! " attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:nickName attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:@"砸蛋触发暴击  " attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:@"赠送全麦" attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]]];
    
    CALayer *layer = [[CALayer alloc]init];
    layer.bounds = CGRectMake(0, -10, 40, 37);
    layer.contentsScale = [UIScreen mainScreen].scale;
    [layer qn_setImageImageWithUrl:prizUrl placeholderImage:nil type:(ImageType)ImageTypeRoomGift];

    NSMutableAttributedString * imageString1 = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeScaleAspectFit attachmentSize:layer.frame.size alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
    [attributedString appendAttributedString:imageString1];
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:[NSString stringWithFormat:@"(价值%ld萌币)",value]
                  attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize],
                               NSForegroundColorAttributeName:UIColorRGBAlpha(0xffffff, 0.5)}]];
    if (!num) {
        num = 1;
    }
    [attributedString appendAttributedString:
     [self creatStrAttrByStr:[NSString stringWithFormat:@"x%ld",num]
                  attributed:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]]];
    
    return attributedString;
}


//创建拉黑/踢出房间/踢下麦富文本
+ (NSMutableAttributedString *)creatKick:(BaseAttributedStringKickType)kickTye handleNick:(NSString *)handleNick targetNick:(NSString *)targetNick{
    if (handleNick == nil) {
        handleNick = @"";
    }
    if (targetNick == nil) {
        targetNick = @"";
    }
    NSMutableAttributedString *sourceStr = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *targetStr = [[NSMutableAttributedString alloc]initWithString:targetNick attributes:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    
    NSMutableAttributedString *tipStr = [[NSMutableAttributedString alloc]initWithString:@"被"  attributes:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
    
    NSMutableAttributedString *handleStr = [[NSMutableAttributedString alloc]initWithString:handleNick  attributes:[self textAttributedWithColor:[XCTheme getTTMessageViewCPNickColor] size:TTMessageViewDefaultFontSize]];
    
    NSMutableAttributedString *actionStr = nil;
    switch (kickTye) {
        case BaseAttributedStringKickTypeBeDownMic:
            actionStr = [[NSMutableAttributedString alloc]initWithString:@"请下麦" attributes:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
            break;
        case BaseAttributedStringKickTypeBeKick:
            actionStr = [[NSMutableAttributedString alloc]initWithString:@"请出房间" attributes:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
            break;
        case BaseAttributedStringKickTypeBeBack:
            actionStr = [[NSMutableAttributedString alloc]initWithString:@"关进小黑屋" attributes:[self textAttributedWithColor:[XCTheme getTTMessageViewTipColor] size:TTMessageViewDefaultFontSize]];
            break;
        default:
            actionStr = [[NSMutableAttributedString alloc] initWithString:@""];
            break;
    }
    [sourceStr appendAttributedString:targetStr];
    [sourceStr appendAttributedString:tipStr];
    [sourceStr appendAttributedString:handleStr];
    [sourceStr appendAttributedString:actionStr];
    return sourceStr;
}

+ (NSMutableAttributedString *)creatRobotOutRoomStrBy:(NSString *)robotName{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    NSMutableAttributedString *robotNameStr = [self creatStrAttrByStr:robotName];
    [robotNameStr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewCPNickColor] range:NSMakeRange(0, robotNameStr.length)];
    [str appendAttributedString:robotNameStr];
    
    [str appendAttributedString:[self creatPlaceholderAttributedStringByWidth:3]];
    
    NSMutableAttributedString *outStr = [self creatStrAttrByStr:@"退出了房间"];
    [outStr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewTipColor] range:NSMakeRange(0, outStr.length)];
    [str appendAttributedString:outStr];
    return str;
}

//排麦的时候 管理员抱人上麦
+ (NSMutableAttributedString *)createEmbrace:(NSString *)nick{
    NSMutableAttributedString * attributt = [[NSMutableAttributedString alloc] init];
    if (nick && nick.length >0) {
        nick = nick;
    }else{
        nick = @"";
    }
    NSString * title = [NSString stringWithFormat:@"管理员将%@抱上麦了", nick];
    NSRange range = [title rangeOfString:nick];
    [attributt appendAttributedString:[self creatStrAttrByStr:title attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize], NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}]];
    [attributt addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMessageViewCPNickColor] range:range];
    return attributt;
    
}

//系统通知富文本
+ (NSMutableAttributedString *)creatSysNobleNotify:(NSString *)nick andSingleNobleInfo:(PrivilegeInfo *)singleNobleInfo typeStr:(NSString *)typeStr{
    
    if (nick.length == 0 || !nick) {
        nick = @" ";
    }
    
    NSMutableAttributedString *sourceStr = [[NSMutableAttributedString alloc] init];
    
    CALayer *sysNotifyLayer = [[CALayer alloc]init];
    sysNotifyLayer.contents = (__bridge id)[UIImage imageNamed:@"noble_sys_notify_icon"].CGImage;
    sysNotifyLayer.bounds = CGRectMake(0, 0, 42, 12);
    sysNotifyLayer.contentsScale = [UIScreen mainScreen].scale;
    
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:sysNotifyLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(sysNotifyLayer.frame.size.width, sysNotifyLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
    [sourceStr appendAttributedString:imageString];
    
    [sourceStr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    
    [sourceStr appendAttributedString:
     [self creatStrAttrByStr:@"恭喜"
                  attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    
    [sourceStr appendAttributedString:
     [self creatStrAttrByStr:nick
                 attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    
    [sourceStr appendAttributedString:
     [self creatStrAttrByStr:@"在房间内"
                  attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    
    [sourceStr appendAttributedString:
     [self creatStrAttrByStr:typeStr
                  attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewNickColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    
    [sourceStr appendAttributedString:
     [self creatStrAttrByStr:[NSString stringWithFormat:@"\"%@\"",singleNobleInfo.name]
                  attributed:@{NSForegroundColorAttributeName:[XCTheme getTTMessageViewCPNickColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}]];
    
    return sourceStr;
}

+ (NSDictionary *)textAttributedWithColor:(UIColor *)textColor size:(CGFloat)size{
    return @{NSForegroundColorAttributeName:textColor,NSFontAttributeName:[UIFont systemFontOfSize:size]};
}



#pragma mark - private method
//officalImage
+ (NSMutableAttributedString *)makeOfficalImage:(UserInfo *)userInfo{
    NSMutableAttributedString * officalImageString = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
    return officalImageString;
}
//newImage
+ (NSMutableAttributedString *)makeNewImage:(UserInfo *)userInfo{
    NSMutableAttributedString * newImageString = [self makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:@"common_newuser"];
    return newImageString;
}

//nobleBadge
+ (NSMutableAttributedString *)makeNobleBadge:(UserInfo *)userInfo{
    
    CALayer *layer = [[CALayer alloc]init];
    [TTNobleSourceHandler handlerLayer:layer soure:userInfo.nobleUsers.badge imageType:ImageTypeUserLibaryDetail];
    layer.bounds = CGRectMake(0, 0, 15, 15);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    
    NSMutableAttributedString * nobleImageString = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(layer.frame.size.width, layer.frame.size.height) alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
    return nobleImageString;
}

@end
