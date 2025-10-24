//
//  UserInfo.h
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//


#import "BaseObject.h"
#import "UserPhoto.h"
#import "UserGift.h"
#import "SingleNobleInfo.h"
#import "LevelInfo.h"
#import "UserCar.h"
#import "UserHeadWear.h"
#import "CertificationModel.h"
#import "BlindDateInfo.h"

#import "XCFamily.h"
#import "WeChatUserInfo.h"
#import "QQUserInfo.h"
#import "GuildHallInfo.h"
#import "LocationExpand.h"
#import "UserLittleWorld.h"
#import "UserOfficialAnchorCertification.h"

static NSString * const RankHideAvatarUrl = @"https://img.erbanyy.com/secretGay.png";

typedef enum {
    GroupType_default = 0,//默认
    GroupType_Blue = 1,//蓝队
    GroupTyp_red = 2, //红队
   
}GroupType;

typedef enum {
    UserInfo_Male = 1,
    UserInfo_Female = 2
}UserGender;

typedef enum {
    BindType_WC = 1,//1 微信。
    BindType_QQ = 2, //2 qq
    BindType_Phone = 3, //3 phone
    BindType_AppleID = 5, // Apple ID
}BindType;

typedef enum {
    XCUserInfoPlatformRoleNormal = 0,//普通用户
    XCUserInfoPlatformRoleSuperAdmin = 1//超级管理员
} XCUserInfoPlatformRole;//平台角色

static inline NSString * XCUserInfoGenderName(UserGender gender) {
    switch (gender) {
        case UserInfo_Male: return @"男";
        case UserInfo_Female: return @"女";
        default: return @"未知";
    }
}

@interface UserInfo : BaseObject
//基础信息
@property(nonatomic, assign) UserID uid;
/** 公会模厅信息 */
@property (nonatomic, strong) GuildHallInfo *hallInfo;

- (NSString *)newUserIcon;

/** 模厅ID */
/**
 角色类型： 1：厅主，2：高管，3：普通成员，为空表示不属于这个模厅成员
 */
@property (nonatomic, copy) NSString *roleType;
@property (nonatomic, assign) long long hallId;
/** 禁言状态，false:未被禁言,true:已被禁言）  */
@property (nonatomic, assign) BOOL bannedStatus;
@property(nonatomic, copy) NSString *erbanNo;
@property(nonatomic, assign) XCUserInfoPlatformRole platformRole;//平台角色
@property (nonatomic, copy) NSString *appleFullName; // 苹果账号昵称
@property(nonatomic, copy) NSString *nick;
@property(nonatomic, assign) long birth;
@property(nonatomic, copy) NSString *star;
@property(nonatomic, copy) NSString *signture;
@property(nonatomic, copy) NSString *userVoice;
@property(nonatomic, assign) NSInteger voiceDura;
@property(nonatomic, assign) UserGender gender;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *region;
@property(nonatomic, copy) NSString *userDesc;
@property(nonatomic, assign) long followNum;
@property(nonatomic, assign) long fansNum;
@property(nonatomic, assign) long fortune;

@property (nonatomic, assign) BOOL newUser;
@property (nonatomic,copy) NSString *newUserIcon;
@property (strong , nonatomic) NSArray *userTagList;//用户标签 @["tag_url"]

@property (nonatomic, strong) NSArray<UserPhoto *> *privatePhoto;//相册
@property (nonatomic, strong) NSArray<UserLittleWorld *> *joinWorlds;//加入的小世界

@property (nonatomic, assign) AccountType defUser; //账号类型

@property (nonatomic, assign) BOOL hasPrettyErbanNo;//是否靓号
@property (nonatomic, assign) int remainDay;
@property (nonatomic,copy) NSString *newsUserIcon;//！！！在getter里面写死了一个url
@property (nonatomic, copy) NSString *phone;//手机号码
@property (nonatomic, assign) BOOL isBindPhone;//是否绑定手机
@property (nonatomic, assign) BOOL isBindXCZAccount;//是否绑定 xczAccount
@property (nonatomic, assign) BOOL isBindPasswd;//是否 设置 密码
@property (nonatomic, assign) BOOL isBindPaymentPwd;//是否 设置 2级密码
@property (nonatomic, copy) NSString *expireDate;
@property (nonatomic, assign) BindType bindType; //账号绑定
@property (nonatomic, assign) BOOL isCertified;//是否已经完成实名认证
@property (nonatomic, assign) BOOL parentMode; // 家长模式是否开启

//贵族信息
@property(nonatomic, strong) SingleNobleInfo *nobleUsers;

//用户等级
@property(nonatomic, strong) LevelInfo *userLevelVo;

//座驾信息
@property (nonatomic, strong) UserCar *carport;

//头饰信息
@property (nonatomic, strong) UserHeadWear *userHeadwear;

// 101 认证信息
@property (nonatomic, strong) CertificationModel *userInfoSkillVo;

// 官方主播认证
@property (nonatomic, strong) UserOfficialAnchorCertification *nameplate;
// 官方主播背景图片，个人主页的主页背景优先级：官方主播>贵族＞普通用户
@property (nonatomic, copy) NSString *attestationBackPic;
//主播认证标签
@property (nonatomic, strong) NSArray<NSString *> *tagList;

//家族信息
@property (strong, nonatomic) XCFamily *family;
@property (nonatomic,assign) NSInteger familyId;
/** 是否已关注 */
@property (nonatomic, assign) BOOL isLike;
/** 用户信息拓展(地理位置) */
@property (nonatomic, strong) LocationExpand *userExpand;

///是否存在有效视频
@property (assign , nonatomic) BOOL uploadFlag;
//UKiss

/**cp匹配吗*/
@property (nonatomic, copy) NSString *uniqueCode;
/**cp匹配后房间Uid*/
@property (nonatomic, copy) NSString *roomOwnerId;
/**是否是cp*/
@property (nonatomic, assign) BOOL isCouple;
/**cpUid*/
@property(nonatomic, assign) UserID cpUid;
/**绑定cp天数*/
@property(nonatomic, assign) NSInteger days;
/**相恋天数*/
@property(nonatomic, assign) NSInteger lovedays;

/**恋爱日期 格式  yyyy-mm-dd*/
@property (nonatomic, copy) NSString *lovedate;

@property(nonatomic, assign) UserID roomId;
/**cp昵称*/
@property (nonatomic, copy) NSString *cpNick;
/**陪伴值*/
@property(nonatomic, assign) NSInteger accompanyValue;

/**马甲昵称*/
@property (nonatomic, copy) NSString *communityNick;
/**马甲头像*/
@property (nonatomic, copy) NSString *communityAvatar;

/**用户年龄*/
@property (nonatomic, copy) NSString *age;

/**xczAccount*/
@property (nonatomic, copy) NSString *account;

/**xczAccountname*/
@property (nonatomic, copy) NSString *accountName;

/**是否加入社区*/
@property (nonatomic, assign) BOOL isJoinCommunity;

/** 是不是选择 在兔兔公聊大厅中使用*/
@property (nonatomic, assign) BOOL isSelected;


/// Allo
@property (nonatomic, copy) NSString *operType;
@property (nonatomic, assign) BOOL hasRegPacket;

//roompk
@property (nonatomic, assign) GroupType groupType;

@property (nonatomic, assign) BOOL openDistance;//是否 开启距离显示
@property (nonatomic, assign) BOOL openAutoMatch;//是否 开启字段匹配cp

/** 师徒关系中的type 用户类型（1：我的师傅，2：我的徒弟） */
@property (nonatomic, assign) NSInteger type;


/** 萌声 社区版本 用户获赞数 */
@property (assign , nonatomic) long long  likedCount;

/** 萌声 社区版本 用户 是否活跃 */
@property (assign , nonatomic) BOOL  isActive;

#pragma mark - 礼物相关
// 收到的礼物盲盒礼物id
@property (nonatomic, assign) NSInteger receiveGiftId;

#pragma mark --- 相亲房使用 ---
@property (nonatomic, strong) BlindDateInfo *blindDate; // 相亲房对象
/*   --------------   */

@end

