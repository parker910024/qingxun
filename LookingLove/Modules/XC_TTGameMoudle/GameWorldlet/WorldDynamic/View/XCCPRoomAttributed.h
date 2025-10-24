//
//  XCCPRoomAttributed.h
//  UKiss
//
//  Created by apple on 2018/10/14.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

static NSString *k_NickLabel_Font = @"font";
static NSString *k_NickLabel_Color = @"color";
static NSString *k_NickLabel_MaxWidth = @"maxWidth";

NS_ASSUME_NONNULL_BEGIN

@interface XCCPRoomAttributed : NSObject

/**性别 用户昵称 是否编辑 */
+ (NSMutableAttributedString *)creatSexUserNameEidtByUserInfo:(UserInfo *)userInfo attribute:(NSDictionary *)attribute;



/**用户马甲名 性别 年龄 */
+ (NSMutableAttributedString *)creatUserNameSexAgeByUserInfo:(UserInfo *)userInfo;

/**用户马甲名 性别 年龄 */
+ (NSMutableAttributedString *)creatCommunityUserName:(NSString *)commentNick withSex:(UserGender)gender withAge:(NSString *)age;


/**用户名 性别 年龄 */

+ (NSMutableAttributedString *)creatUserNickNameSexAgeByUserInfo:(UserInfo *)userInfo nickAttribute:(NSDictionary *)nickAttribute ageAttribute:(NSDictionary *)ageAttribute;


@end

NS_ASSUME_NONNULL_END
