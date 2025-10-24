//
//  BaseAttrbutedStringHandler+Voice.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler+Voice.h"

#import "UserInfo.h"
#import "NSDate+Util.h"
#import "XCTheme.h"
#import <YYText/YYText.h>

@implementation BaseAttrbutedStringHandler (Voice)
// 创建 昵称 + 性别富文本 + 星座 + 地区 (昵称限制5个字, 超过.. 地区限制四个字超过..)
+ (NSMutableAttributedString *)creatNick_Sex_Constellation_CityLimitByUserInfo:(UserInfo *)userInfo location:(NSString *)location textColor:(UIColor *)textColor font:(UIFont *)font {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    CGFloat space = 4;
    
    // nick
    NSString *nick = userInfo.nick;
    if (userInfo.nick.length > 5) {
        nick = [userInfo.nick substringToIndex:4];
        nick = [NSString stringWithFormat:@"%@..", nick];
    } else {
        nick = userInfo.nick;
    }
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:nick attributes:@{NSForegroundColorAttributeName : textColor, NSFontAttributeName : font}]];
    
    // sex
    [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:space]];
    if (userInfo.gender == BaseAttributedUserGender_Male) {
        [attr appendAttributedString:[self makeGender:BaseAttributedUserGender_Male size:CGSizeMake(15, 15)]];
    } else {
        [attr appendAttributedString:[self makeGender:BaseAttributedUserGender_Female size:CGSizeMake(15, 15)]];
    }
    
    // constellation 星座
    if (userInfo.birth) {
        [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:space]];
        NSMutableAttributedString *constellationString = [self makeDateLabel:userInfo.birth color:UIColorFromRGB(0x4D73E8)];
        constellationString.yy_baselineOffset = @(2);
        [attr appendAttributedString:constellationString];
    }
    
    // 地区
    if (location) {
        [attr appendAttributedString:[self creatPlaceholderAttributedStringByWidth:space]];
        NSString *locationStr = location;
        if (locationStr.length > 4) {
            locationStr = [location substringToIndex:3];
            locationStr = [NSString stringWithFormat:@"%@..", nick];
        } else {
            locationStr = location;
        }
        UILabel *locationLabel = [[UILabel alloc] init];
        locationLabel.font = [UIFont systemFontOfSize:10];
        locationLabel.text = location;
        locationLabel.textAlignment = NSTextAlignmentCenter;
        locationLabel.backgroundColor = RGBCOLOR(18, 218, 224);
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.layer.cornerRadius = 15/2;
        locationLabel.layer.masksToBounds = YES;
        [locationLabel sizeToFit];
        locationLabel.bounds = CGRectMake(0, 0, locationLabel.frame.size.width + 12, 15);
        NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:locationLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(locationLabel.frame.size.width, locationLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:10] alignment:YYTextVerticalAlignmentCenter];
        dateLabelString.yy_baselineOffset = @(2);
        [attr appendAttributedString:dateLabelString];
    }
    
    return attr;
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
    NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:dateLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(dateLabel.frame.size.width, dateLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:10] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}
@end
