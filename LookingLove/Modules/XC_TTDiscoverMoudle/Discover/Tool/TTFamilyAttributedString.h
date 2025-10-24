//
//  TTFamilyAttributedString.h
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
#import "XCFamily.h"
#import "XCTheme.h"
#import "TTFamilyPersonSctionView.h"
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyAttributedString : BaseAttrbutedStringHandler
/** 创建一个 名字 性别 等级 魅力等级*/
+ (NSMutableAttributedString *)createNameGenderLevelCharmWiht:(NSString *)nick gender:(UserGender)usergender level:(LevelInfo *)levelInfor;

/** 家族的头 ID 人数*/
+ (NSMutableAttributedString *)createFamilyPersonHeaderAttributstring:(XCFamily *)familyInfor;

/** 查看更多 或者创建家族*/
+ (NSMutableAttributedString *)createFamilyPersonSectionViewAttributstring:(TTFamilyPersonSctionViewType)type;
/** 创建群的时候显示选择的家族成员*/
+(NSMutableAttributedString*)createFamilyCreateGroupChooseMemberWith:(NSMutableDictionary *)members;
/** 家族搜索*/
+(NSMutableAttributedString *)createFamilySearchAttributedString;
@end

NS_ASSUME_NONNULL_END
