//
//  UserInfo+WCTTableCoding.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "UserInfo.h"
#import "WCDBObjc.h"

@interface UserInfo () <WCTTableCoding>

WCDB_PROPERTY(uid)
WCDB_PROPERTY(erbanNo)
WCDB_PROPERTY(nick)
WCDB_PROPERTY(birth)
WCDB_PROPERTY(star)
WCDB_PROPERTY(signture)
WCDB_PROPERTY(userVoice)
WCDB_PROPERTY(voiceDura)
WCDB_PROPERTY(gender)
WCDB_PROPERTY(avatar)
WCDB_PROPERTY(region)
WCDB_PROPERTY(userDesc)
WCDB_PROPERTY(followNum)
WCDB_PROPERTY(fansNum)
WCDB_PROPERTY(fortune)
WCDB_PROPERTY(defUser)
WCDB_PROPERTY(privatePhoto)
WCDB_PROPERTY(userTagList)
WCDB_PROPERTY(nobleUsers)
WCDB_PROPERTY(hasPrettyErbanNo)
WCDB_PROPERTY(expireDate)
WCDB_PROPERTY(remainDay)
WCDB_PROPERTY(userLevelVo)
WCDB_PROPERTY(carport)
WCDB_PROPERTY(newUser);
WCDB_PROPERTY(newUserIcon);
WCDB_PROPERTY(userHeadwear);
WCDB_PROPERTY(family);
WCDB_PROPERTY(familyId);
WCDB_PROPERTY(hallId);
WCDB_PROPERTY(hallInfo);
WCDB_PROPERTY(isCertified);
WCDB_PROPERTY(likedCount);
WCDB_PROPERTY(userInfoSkillVo);
WCDB_PROPERTY(blindDate);

@end
