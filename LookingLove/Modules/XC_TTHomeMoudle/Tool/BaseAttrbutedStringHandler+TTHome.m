//
//  BaseAttrbutedStringHandler+TTHome.m
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+TTHome.h"

#import <YYText/YYText.h>

#import "XCTheme.h"
#import "TTHomeRecommendDetailData.h"
#import "DiscoveryHeadLineNews.h"
#import "UserInfo.h"
#import "TTNobleSourceHelper.h"

@implementation BaseAttrbutedStringHandler (TTHome)

////头条的富文本
+ (NSMutableAttributedString *)newHeadLineWith:(DiscoveryHeadLineNews *)model withMaxWidht:(CGFloat)maxWidth {

    NSMutableAttributedString *attributting = [[NSMutableAttributedString alloc] init];
    if (model.tipType) {
        UIImageView *nobleBadgeImageView = [[UIImageView alloc]init];
        nobleBadgeImageView.bounds = CGRectMake(0, 0, 30, 15);
        
        NSString *imageName = @"home_headline";
        if (model.tipType == TTHeadlineTipTypeNewest) {
            imageName = @"home_headline_newest";
        } else if(model.tipType == TTHeadlineTipTypeATme) {
            imageName = @"home_headline_me";
        } else if (model.tipType == TTHeadlineTipTypeMonster) {
            imageName = @"home_headline_monster";
        }
        
        nobleBadgeImageView.image = [UIImage imageNamed:imageName];
        nobleBadgeImageView.contentMode = UIViewContentModeScaleToFill;
        NSMutableAttributedString *nobleImageString = [NSMutableAttributedString yy_attachmentStringWithContent:nobleBadgeImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nobleBadgeImageView.frame.size.width, nobleBadgeImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
        [attributting appendAttributedString:nobleImageString];
        [attributting appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.userInteractionEnabled = YES;
    textLabel.textColor = UIColorFromRGB(0x1a1a1a);
    textLabel.text = model.title;
    
    CGFloat maxLabelWidth;
    if (model.tipType) {
        maxLabelWidth  = maxWidth - 35;
    } else {
        maxLabelWidth = maxWidth;
    }
    
    textLabel.bounds = CGRectMake(0, 0, maxLabelWidth, 15);
    textLabel.hidden = NO;
    textLabel.numberOfLines = 1;
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *labelString = [NSMutableAttributedString yy_attachmentStringWithContent:textLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(textLabel.frame.size.width, textLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
    [attributting appendAttributedString:labelString];
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return attributting;
}

//创建 昵称|贵族|性别|等级|魅力等级
+ (NSMutableAttributedString *)creatNick_noble_sex_userLevel_charmLevelByUserInfo:(UserInfo *)userInfo nickType:(BaseAttributedStringNickType)nickType labelAttribute:(NSDictionary *)labelAttribute {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (userInfo.nick.length == 0 || !userInfo.nick) {
        userInfo.nick = @" ";
    }
    //nick
    if (nickType == BaseAttributedStringNickTypeeString) {
        [attributedString appendAttributedString:[self makeNick:userInfo.nick color:[UIColor blackColor]]];
    }else if (nickType == BaseAttributedStringNickTypeUILabel){
        [attributedString appendAttributedString:[self makeLabelNick:userInfo.nick labelAttribute:labelAttribute]];
    }
    [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    
    // noble
    if (userInfo.nobleUsers.level) {
        NSMutableAttributedString *nobleImageString = [TTNobleSourceHelper creatNobleBadge:userInfo size:CGSizeMake(14, 14)];
        [attributedString appendAttributedString:nobleImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    
    // sex
    NSString *sexName = @"";
    if (userInfo.gender == UserInfo_Male) {
        sexName = [XCTheme defaultTheme].common_sex_male;
    } else {
        sexName = [XCTheme defaultTheme].common_sex_female;
    }
    
    NSMutableAttributedString * officalImageString = [self makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:sexName];;
    [attributedString appendAttributedString:officalImageString];
    [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    
    
    //userLevel
    if (userInfo.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:userInfo.userLevelVo.experUrl size:CGSizeMake(33, 13)];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    //charmLevel
    if (userInfo.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:userInfo.userLevelVo.charmUrl size:CGSizeMake(29, 13)];
        [attributedString appendAttributedString:charmImageString];
        [attributedString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    return attributedString;
}

//房间标签富文本
+ (NSMutableAttributedString *)roomTagAttributedStringWithTag:(NSString *)roomTag {
    
    UIFont *font = [UIFont systemFontOfSize:10];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = roomTag;
    label.font = font;
    label.textColor = UIColorFromRGB(0x02C0FF);
    label.textAlignment = NSTextAlignmentCenter;
    
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = UIColorFromRGB(0x02C0FF).CGColor;
    label.layer.borderWidth = 0.5;
    
    CGFloat maxWidth = 60;
    CGFloat margin = 8*2;
    CGFloat labelWidth = [roomTag boundingRectWithSize:CGSizeMake(maxWidth, maxWidth)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: font}
                                              context:nil].size.width+margin;
    
    if (labelWidth > maxWidth) {
        labelWidth = maxWidth;
    }
    
    label.bounds = CGRectMake(0, 0, labelWidth, 16);

    NSMutableAttributedString *attributedString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    return attributedString;
}

@end
