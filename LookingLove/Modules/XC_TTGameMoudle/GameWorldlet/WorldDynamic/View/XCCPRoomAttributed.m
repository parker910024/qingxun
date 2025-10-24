//
//  XCCPRoomAttributed.m
//  UKiss
//
//  Created by apple on 2018/10/14.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "XCCPRoomAttributed.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "AuthCore.h"
#import "NSDate+TimeCategory.h"
#import <YYText/YYText.h>
#import "XCTheme.h"

@implementation XCCPRoomAttributed

/**性别 用户昵称 是否编辑 */
+ (NSMutableAttributedString *)creatSexUserNameEidtByUserInfo:(UserInfo *)userInfo attribute:(NSDictionary *)attribute{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString * genderImageString = [self getMakeGender:userInfo.gender];
    [attributedString appendAttributedString:genderImageString];

    NSMutableAttributedString * labelString = [self makeUserName:userInfo.nick attribute:attribute bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelString];
    
    if (userInfo.uid == [GetCore(AuthCore).getUid userIDValue]){
        NSMutableAttributedString * editImageString = [self makeImageAttributedString:CGRectMake(5, 0, 15, 15) urlString:nil imageName:@"chat_btn_edit"];
        [attributedString appendAttributedString:editImageString];
    }
    
    return attributedString;
}

//UserName
+ (NSMutableAttributedString *)makeUserName:(NSString *)nick attribute:(NSDictionary *)attribute bgColor:(UIColor *)color{
    NSString *userName = [NSString stringWithFormat:@"%@",nick];
     CGFloat maxWidth = ([[attribute objectForKey:k_NickLabel_MaxWidth] integerValue]>0) ? [[attribute objectForKey:k_NickLabel_MaxWidth] integerValue] : KScreenWidth;
    CGFloat textWidth = [self sizeWithText:userName font:attribute[k_NickLabel_Font] maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].width;
    UILabel *textLabel = [self createLabel:userName fontSize:attribute[k_NickLabel_Font]
                                    bounds:CGRectMake(0, 0, textWidth+10, 15)
                                 textColor:attribute[k_NickLabel_Color] bgColor:color];
    NSMutableAttributedString * labelString = [NSMutableAttributedString yy_attachmentStringWithContent:textLabel
                                                                                            contentMode:UIViewContentModeScaleAspectFit
                                                                                         attachmentSize:CGSizeMake(textLabel.frame.size.width, textLabel.frame.size.height)
                                                                                            alignToFont:attribute[k_NickLabel_Font] alignment:YYTextVerticalAlignmentCenter];
    return labelString;
}


+ (NSMutableAttributedString *)creatUserNameSexAgeByUserInfo:(UserInfo *)userInfo{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSDictionary * dictlabel = @{
                            k_NickLabel_Font:[UIFont systemFontOfSize:15],
                            k_NickLabel_Color:UIColorFromRGB(0xC1BEE3)
                            };
    NSMutableAttributedString * labelString = [self makeUserName:userInfo.communityNick attribute:dictlabel bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelString];
    
    NSMutableAttributedString * genderImageString = [self getMakeGender:userInfo.gender];
    [attributedString appendAttributedString:genderImageString];

//    if (userInfo.uid == [GetCore(AuthCore).getUid userIDValue]){
//        NSMutableAttributedString * editImageString = [self makeImageAttributedString:CGRectMake(5, 0, 15, 15) urlString:nil imageName:@"chat_btn_edit"];
//        [attributedString appendAttributedString:editImageString];
//    }
    NSString *age = [NSString stringWithFormat:@"%ld",(long)[NSDate ageWithDateFromBirth:userInfo.birth]];
    
    NSDictionary * dictlabelAge = @{
                                 k_NickLabel_Font:[UIFont systemFontOfSize:12],
                                 k_NickLabel_Color:UIColorFromRGB(0x8986AA)
                                 };
    NSMutableAttributedString * labelAgeString = [self makeUserName:age attribute:dictlabelAge bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelAgeString];
    return attributedString;
}

+ (NSMutableAttributedString *)creatUserNickNameSexAgeByUserInfo:(UserInfo *)userInfo nickAttribute:(NSDictionary *)nickAttribute ageAttribute:(NSDictionary *)ageAttribute{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString * labelString = [self makeUserName:(GetCore(AuthCore).getUid.userIDValue != userInfo.uid) ? userInfo.communityNick:userInfo.nick  attribute:nickAttribute bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelString];
    
    NSMutableAttributedString * genderImageString = [self getMakeGender:userInfo.gender];
    [attributedString appendAttributedString:genderImageString];
    
    NSString *age = [NSString stringWithFormat:@"%ld",(long)[NSDate ageWithDateFromBirth:userInfo.birth]];
    NSMutableAttributedString * labelAgeString = [self makeUserName:age attribute:ageAttribute bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelAgeString];
    return attributedString;
}
/**用户马甲名 性别 年龄 */
+ (NSMutableAttributedString *)creatCommunityUserName:(NSString *)communityNick withSex:(UserGender)gender withAge:(NSString *)age{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSDictionary * dictlabel = @{
                                 k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                 k_NickLabel_Color:UIColorFromRGB(0xA49EFE)
                                 };
    NSMutableAttributedString * labelString = [self makeUserName:communityNick attribute:dictlabel bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelString];
    
    NSMutableAttributedString * genderImageString = [self getMakeGender:gender];
    [attributedString appendAttributedString:genderImageString];
    
    NSDictionary * dictlabelAge = @{
                                    k_NickLabel_Font:[UIFont systemFontOfSize:12],
                                    k_NickLabel_Color:UIColorFromRGB(0x8986AA)
                                    };
    NSMutableAttributedString * labelAgeString = [self makeUserName:age attribute:dictlabelAge bgColor:[UIColor clearColor]];;
    [attributedString appendAttributedString:labelAgeString];
    return attributedString;
}
//gender
+ (NSMutableAttributedString *)getMakeGender:(UserGender)userGender{
    NSString *imageName = @"ic_no_back_sex_girl";
    if (userGender == UserInfo_Male) {
        imageName = @"ic_no_back_sex_boy";
    }
    NSMutableAttributedString * genderString = [self makeImageAttributedString:CGRectMake(5, 0, 15, 15) urlString:nil imageName:imageName];
    return genderString;
}
//genderStrange
+ (NSMutableAttributedString *)makeStrangeGender:(UserGender)userGender{
    NSString *imageName = @"chat_icon_girl";
    if (userGender == UserInfo_Male) {
        imageName = @"chat_icon_boy";
    }
    NSMutableAttributedString * genderString = [self makeImageAttributedString:CGRectMake(5, 0, 15, 15) urlString:nil imageName:imageName];
    return genderString;
}


//根据图片资源创建图片富文本
+ (NSMutableAttributedString *)makeImageAttributedString:(CGRect)frame urlString:(NSString *)urlString imageName:(NSString *)imageName{
    UIImageView *charmImageView = [[UIImageView alloc]init];
    charmImageView.bounds = frame;
    charmImageView.contentMode = UIViewContentModeScaleToFill;
    if (urlString.length>0) {
        [charmImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }else{
        charmImageView.image = [UIImage imageNamed:imageName];
    }
    NSMutableAttributedString * charmImageString = [NSMutableAttributedString yy_attachmentStringWithContent:charmImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(charmImageView.frame.size.width, charmImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return charmImageString;
}


// 创建label
+ (UILabel *)createLabel:(NSString *)text fontSize:(UIFont *)fontSize bounds:(CGRect)labelBounds textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = fontSize;
    textLabel.bounds = labelBounds;
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = bgColor;
    textLabel.textColor = textColor;
    return textLabel;
}


/**
 返回文字size
 
 @param text string
 @param font 字号
 @param maxSize maxSize
 @return size
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
