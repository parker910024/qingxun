//
//  TTFamilyAttributedString.m
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyAttributedString.h"
#import <YYText.h>
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"

@implementation TTFamilyAttributedString

+ (NSMutableAttributedString *)createFamilyPersonHeaderAttributstring:(XCFamily *)familyInfor{
    NSMutableAttributedString * attributing = [[NSMutableAttributedString alloc] init];
    UIImageView * idImageView = [[UIImageView alloc] init];
    idImageView.image = [UIImage imageNamed:@"family_person_id"];
    idImageView.bounds = CGRectMake(0, 0, 14, 14);
    NSMutableAttributedString *idImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:idImageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:idImageView.bounds.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
    [attributing appendAttributedString:idImageAtt];
    [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
    
    UILabel * idLabel = [[UILabel alloc] init];
    idLabel.text = familyInfor.familyId;
    idLabel.textColor = UIColorRGBAlpha(0xffffff, 0.7);
    CGSize idsize = [self sizeWithText:familyInfor.familyId font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth,CGFLOAT_MAX)];
    idLabel.bounds = CGRectMake(0, 0, idsize.width + 2, idsize.height);
    idLabel.font = [UIFont systemFontOfSize:12];
    idLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *familyIdAttribut = [NSMutableAttributedString yy_attachmentStringWithContent:idLabel contentMode:UIViewContentModeScaleAspectFill attachmentSize:idLabel.bounds.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
    [attributing appendAttributedString:familyIdAttribut];
    [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
    [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
    
    UIImageView * menberImageView = [[UIImageView alloc] init];
    menberImageView.image = [UIImage imageNamed:@"family_person_member"];
    menberImageView.bounds = CGRectMake(0, 0, 14, 14);
    NSMutableAttributedString *memberImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:menberImageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:menberImageView.bounds.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
    [attributing appendAttributedString:memberImageAtt];
    [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
    
    UILabel * memberLabel = [[UILabel alloc] init];
    memberLabel.text = familyInfor.memberCount;
    CGSize size = [self sizeWithText:familyInfor.memberCount font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth,CGFLOAT_MAX)];
    memberLabel.textColor = UIColorRGBAlpha(0xffffff, 0.7);
    memberLabel.bounds = CGRectMake(0, 0, size.width +2, size.height);
    memberLabel.font = [UIFont systemFontOfSize:12];
    memberLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *memberLabelmageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:memberLabel contentMode:UIViewContentModeScaleAspectFill attachmentSize:memberLabel.bounds.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
    [attributing appendAttributedString:memberLabelmageAtt];
    return attributing;
}

+ (NSMutableAttributedString *)createFamilyPersonSectionViewAttributstring:(TTFamilyPersonSctionViewType)type{
    NSMutableAttributedString * attributing = [[NSMutableAttributedString alloc] init];
    if (type == TTFamilyPersonSctionView_more) {
        UILabel * memberLabel = [[UILabel alloc] init];
        NSString * title = @"查看更多";
        memberLabel.text = title;
        CGSize size = [self sizeWithText:title font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(KScreenWidth,CGFLOAT_MAX)];
        memberLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        memberLabel.bounds = CGRectMake(0, 0, size.width +2, size.height);
        memberLabel.font = [UIFont systemFontOfSize:13];
        memberLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *memberLabelmageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:memberLabel contentMode:UIViewContentModeScaleAspectFill attachmentSize:memberLabel.bounds.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
        [attributing appendAttributedString:memberLabelmageAtt];
        [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
        
        UIImageView * idImageView = [[UIImageView alloc] init];
        idImageView.image = [UIImage imageNamed:@"discover_family_arrow"];
        idImageView.bounds = CGRectMake(0, 0, 7, 11);
        NSMutableAttributedString *idImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:idImageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:idImageView.bounds.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
        [attributing appendAttributedString:idImageAtt];
    }else{
        UIImageView * idImageView = [[UIImageView alloc] init];
        idImageView.image = [UIImage imageNamed:@"family_person_creategroup"];
        idImageView.bounds = CGRectMake(0, 0, 11, 11);
        NSMutableAttributedString *idImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:idImageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:idImageView.bounds.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
        [attributing appendAttributedString:idImageAtt];
        [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
        
        UILabel * memberLabel = [[UILabel alloc] init];
        NSString * title = @"创建家族群";
        memberLabel.text = title;
        CGSize size = [self sizeWithText:title font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KScreenWidth,CGFLOAT_MAX)];
        memberLabel.textColor = UIColorFromRGB(0xFF3852);
        memberLabel.bounds = CGRectMake(0, 0, size.width +2, size.height);
        memberLabel.font = [UIFont systemFontOfSize:15];
        memberLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *memberLabelmageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:memberLabel contentMode:UIViewContentModeScaleAspectFill attachmentSize:memberLabel.bounds.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
        [attributing appendAttributedString:memberLabelmageAtt];
        
    }
    return attributing;
}

+(NSMutableAttributedString*)createFamilyCreateGroupChooseMemberWith:(NSMutableDictionary *)members{
    if (members.allKeys.count ==0) {
        return nil;
    }
    NSMutableAttributedString * attributing = [[NSMutableAttributedString alloc] init];
    //如果大于6个的话 就要显示一行文字
    int  count;
    if (members.allKeys.count > 6) {
        count = 6;
    }else{
        count = members.allKeys.count;
    }
    CGFloat scale = (KScreenWidth- 30 -40 * 6) / 5;
    for (int i = 0; i < count; i++) {
        UIImageView * idImageView = [[UIImageView alloc] init];
        NSString * key = [members.allKeys safeObjectAtIndex:i];
        XCFamilyModel * member = [members objectForKey:key];
        idImageView.bounds = CGRectMake(0, 0, 40, 40);
        idImageView.layer.masksToBounds= YES;
        idImageView.layer.cornerRadius = 20;
        [idImageView qn_setImageImageWithUrl:member.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        NSMutableAttributedString *idImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:idImageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:idImageView.bounds.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
        [attributing appendAttributedString:idImageAtt];
        if (i != 5) {
            UIView * memberLabel = [[UIView alloc] init];
            memberLabel.bounds = CGRectMake(0, 0, scale, 40);
            NSMutableAttributedString *memberLabelmageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:memberLabel contentMode:UIViewContentModeScaleAspectFill attachmentSize:memberLabel.bounds.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
            [attributing appendAttributedString:memberLabelmageAtt];
        }
    }
    return attributing;
}

+(NSMutableAttributedString *)createFamilySearchAttributedString{
    NSMutableAttributedString * attributing = [[NSMutableAttributedString alloc] init];
    UIImageView * idImageView = [[UIImageView alloc] init];
    idImageView.image = [UIImage imageNamed:@"family_mon_search"];
    idImageView.bounds = CGRectMake(0, 0, 11, 11);
    NSMutableAttributedString *idImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:idImageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:idImageView.bounds.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
    [attributing appendAttributedString:idImageAtt];
    [attributing appendAttributedString:[self creatStrAttrByStr:@" "]];
    
    UILabel * memberLabel = [[UILabel alloc] init];
    NSString * title = @"搜索家族成员";
    memberLabel.text = title;
    CGSize size = [self sizeWithText:title font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(KScreenWidth,CGFLOAT_MAX)];
    memberLabel.textColor = UIColorFromRGB(0x1a1a1a);
    memberLabel.bounds = CGRectMake(0, 0, size.width +2, size.height);
    memberLabel.font = [UIFont systemFontOfSize:13];
    memberLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *memberLabelmageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:memberLabel contentMode:UIViewContentModeScaleAspectFill attachmentSize:memberLabel.bounds.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
    [attributing appendAttributedString:memberLabelmageAtt];
    return attributing;
}

/** 创建一个 名字 性别 等级 魅力等级*/
+ (NSMutableAttributedString *)createNameGenderLevelCharmWiht:(NSString *)nick gender:(UserGender)usergender level:(LevelInfo *)levelInfor{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] init];
    
    if (nick.length > 0) {
        NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15.f],
                                    k_NickLabel_Color:UIColorFromRGB(0x333333),
                                    k_NickLabel_MaxWidth:@(KScreenWidth -250),
                                    k_NickLabel_LabelHeight:@(22)
                                    };
        NSMutableAttributedString *nickAttri = [self makeLabelNick:nick labelAttribute:attribute];
        [attributedString appendAttributedString:nickAttri];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    
    
    BaseAttributedUserGender gender;
    if (usergender == UserInfo_Male) {
        gender = BaseAttributedUserGender_Male;
    }else{
        gender = BaseAttributedUserGender_Female;
    }
    NSMutableAttributedString * genderAttributString = [self makeGender:gender];
    [attributedString appendAttributedString:genderAttributString];
    [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    
    //userLevel
    if (levelInfor.experUrl) {
        NSMutableAttributedString * experImageString = [self makeExperImage:levelInfor.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[self creatPlaceholderAttributedStringByWidth:5]];
    }
    //charmLevel
    if (levelInfor.charmUrl) {
        NSMutableAttributedString * charmImageString = [self makeCharmImage:levelInfor.charmUrl];
        [attributedString appendAttributedString:charmImageString];
    }
    return attributedString;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
