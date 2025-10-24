//
//  TTPublicChatAttrbutedStringHandler.m
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatAttrbutedStringHandler.h"
#import "TTNobleSourceHelper.h"

//theme
#import "XCTheme.h"
#import <YYText.h>

@implementation TTPublicChatAttrbutedStringHandler

+ (NSMutableAttributedString *)makePublicChatUserNameWithUserInfo:(UserInfo *)userInfo {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]init];
    
    if (userInfo.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_offical"];
        [attributedString appendAttributedString:officalBadge];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    if (userInfo.newUser) {
        NSMutableAttributedString *newUser = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_newuser"];
        [attributedString appendAttributedString:newUser];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    if (userInfo.hasPrettyErbanNo) {
        NSMutableAttributedString *pretty = [self makeImageAttributedString:CGRectMake(0, 0, 13, 13) urlString:nil imageName:@"common_beauty"];
        [attributedString appendAttributedString:pretty];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //官方主播认证
    if (userInfo.nameplate && userInfo.nameplate.fixedWord.length>0) {
        NSMutableAttributedString *certTag = [self certificationTagWithName:userInfo.nameplate.fixedWord image:userInfo.nameplate.iconPic];
        [attributedString appendAttributedString:certTag];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    //noble
    if (userInfo.nobleUsers.level) {
        NSMutableAttributedString * nobleImageString = [TTNobleSourceHelper creatNobleBadge:userInfo size:CGSizeMake(13, 14)];
        [attributedString appendAttributedString:nobleImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    //userLevel
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    //charmLevel
    if (userInfo.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:userInfo.userLevelVo.charmUrl];
        [attributedString appendAttributedString:charmImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    if (userInfo.nick.length > 0) {
        NSMutableAttributedString *nick = [self creatStrAttrByStr:userInfo.nick];
        [nick addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x737373) range:NSMakeRange(0, nick.length)];
        [nick addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, nick.length)];
        [attributedString appendAttributedString:nick];
    }
    
    return attributedString;
}

+ (NSMutableAttributedString *)makeEmojiAttributedString:(UIImage *)image {
    
    UIImageView *emoji = [[UIImageView alloc]init];
    emoji.bounds = CGRectMake(0, 0, 20, 20);
    emoji.contentMode = UIViewContentModeScaleAspectFill;
    emoji.image = image;
    
    NSMutableAttributedString *emojiStr = [NSMutableAttributedString yy_attachmentStringWithContent:emoji contentMode:UIViewContentModeScaleAspectFit attachmentSize:emoji.bounds.size alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    
    return emojiStr;
}

@end
