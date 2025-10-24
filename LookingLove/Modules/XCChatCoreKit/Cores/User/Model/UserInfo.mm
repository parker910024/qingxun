//
//  UserInfo.mm
//  BberryCore
//
//  Created by 卫明何 on 2017/11/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "UserInfo+WCTTableCoding.h"
#import "UserInfo.h"
#import "WCDBObjc.h"
#import "UserID.h"
#import "NSObject+YYModel.h"
#import "UserPhoto.h"
#import "NobleCore.h"
#import "NSString+SpecialClean.h"
#import "AuthCore.h"
#import "CarCore.h"


@implementation UserInfo

WCDB_IMPLEMENTATION(UserInfo);

WCDB_SYNTHESIZE(uid);
WCDB_SYNTHESIZE(erbanNo);
WCDB_SYNTHESIZE(platformRole);
WCDB_SYNTHESIZE(nick);
WCDB_SYNTHESIZE(birth);
WCDB_SYNTHESIZE(star);
WCDB_SYNTHESIZE(signture);
WCDB_SYNTHESIZE(userVoice);
WCDB_SYNTHESIZE(voiceDura);
WCDB_SYNTHESIZE(gender);
WCDB_SYNTHESIZE(avatar);
WCDB_SYNTHESIZE(region);
WCDB_SYNTHESIZE(userDesc);
WCDB_SYNTHESIZE(followNum);
WCDB_SYNTHESIZE(fansNum);
WCDB_SYNTHESIZE(fortune);
WCDB_SYNTHESIZE(defUser);
WCDB_SYNTHESIZE(privatePhoto);
WCDB_SYNTHESIZE(joinWorlds);
WCDB_SYNTHESIZE(nobleUsers);
WCDB_SYNTHESIZE(hasPrettyErbanNo);
WCDB_SYNTHESIZE(expireDate);
WCDB_SYNTHESIZE(remainDay);
WCDB_SYNTHESIZE(userLevelVo);
WCDB_SYNTHESIZE(carport);
WCDB_SYNTHESIZE(userInfoSkillVo);
WCDB_SYNTHESIZE(nameplate);
WCDB_SYNTHESIZE(attestationBackPic);
WCDB_SYNTHESIZE(tagList);
WCDB_SYNTHESIZE(userExpand);

WCDB_SYNTHESIZE(newUser);
WCDB_SYNTHESIZE(family);
WCDB_SYNTHESIZE(familyId);
WCDB_SYNTHESIZE(hallId);
WCDB_SYNTHESIZE(hallInfo);

WCDB_SYNTHESIZE(newsUserIcon);
WCDB_SYNTHESIZE(userTagList);

WCDB_SYNTHESIZE(userHeadwear);
WCDB_SYNTHESIZE(phone);
WCDB_SYNTHESIZE(isBindPhone);
WCDB_SYNTHESIZE(isBindXCZAccount);
WCDB_SYNTHESIZE(isBindPasswd);
WCDB_SYNTHESIZE(isBindPaymentPwd);
WCDB_SYNTHESIZE(bindType);
WCDB_SYNTHESIZE(isCertified);
WCDB_SYNTHESIZE(parentMode);

WCDB_SYNTHESIZE(uniqueCode);
WCDB_SYNTHESIZE(roomOwnerId);
WCDB_SYNTHESIZE(isCouple);
WCDB_SYNTHESIZE(cpUid);
WCDB_SYNTHESIZE(days);
WCDB_SYNTHESIZE(lovedays);
WCDB_SYNTHESIZE(lovedate);
WCDB_SYNTHESIZE(roomId);
WCDB_SYNTHESIZE(cpNick);
WCDB_SYNTHESIZE(accompanyValue);
WCDB_SYNTHESIZE(communityNick);
WCDB_SYNTHESIZE(communityAvatar);
WCDB_SYNTHESIZE(age);
WCDB_SYNTHESIZE(account);
WCDB_SYNTHESIZE(accountName);
WCDB_SYNTHESIZE(isJoinCommunity);
WCDB_SYNTHESIZE(openDistance);
WCDB_SYNTHESIZE(openAutoMatch);
WCDB_SYNTHESIZE(likedCount);

WCDB_SYNTHESIZE(blindDate);

WCDB_PRIMARY(uid)
WCDB_INDEX("_index", uid)



+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
            @"privatePhoto":UserPhoto.class,
            @"joinWorlds":UserLittleWorld.class,
             };
}

- (void)setNobleUsers:(SingleNobleInfo *)nobleUsers {
    _nobleUsers = nobleUsers;
    NobleInfo *nobleInfo = [GetCore(NobleCore).privilegeDict objectForKey:[NSString stringWithFormat:@"%ld",(long)nobleUsers.level]];
    _nobleUsers.banner = nobleInfo.banner.values.firstObject;
    _nobleUsers.open_effect = nobleInfo.open_effect.values.firstObject;
    _nobleUsers.wingBadge = nobleInfo.badge.values.firstObject;
}


- (NSString *)newUserIcon {

    return @"https://img.erbanyy.com/newUserIcon.png";
}


- (NSString *)nick {
    return [_nick cleanSpecialText];
}



- (NSString *)expireDate{
    return [NSString stringWithFormat:@"剩余%d天到期",self.remainDay];
}

- (int)calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate{
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    int days=((int)time)/(3600*24);
    return days;
}


@end
