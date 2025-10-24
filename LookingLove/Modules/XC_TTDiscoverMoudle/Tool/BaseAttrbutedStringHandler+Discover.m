//
//  BaseAttrbutedStringHandler+Discover.m
//  TTPlay
//
//  Created by Macx on 2019/1/23.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+Discover.h"

#import <YYText/YYText.h>

#import "UserInfo.h"
#import "DiscoveryHeadLineNews.h"
#import "TTHomeRecommendDetailData.h"
#import "TTNobleSourceHelper.h"
#import "XCTheme.h"

@implementation BaseAttrbutedStringHandler (Discover)
// 创建 性别+用户等级+魅力等级富文本
+ (NSMutableAttributedString *)creatSex_userLevel_charmLevelByUserInfo:(UserInfo *)userInfo {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    CGFloat space = 5;
    
    // sex
    if (userInfo.gender == BaseAttributedUserGender_Male) {
        [attr appendAttributedString:[self makeGender:BaseAttributedUserGender_Male size:CGSizeMake(13, 13)]];
    } else {
        [attr appendAttributedString:[self makeGender:BaseAttributedUserGender_Female size:CGSizeMake(13, 13)]];
    }
    [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:space]];
    
    // experUrl
    [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 33, 13) urlString:userInfo.userLevelVo.experUrl imageName:nil]];
    [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:space]];
    
    // charmUrl
    [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 29, 13) urlString:userInfo.userLevelVo.charmUrl imageName:nil]];
    
    return attr;
}


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
@end
