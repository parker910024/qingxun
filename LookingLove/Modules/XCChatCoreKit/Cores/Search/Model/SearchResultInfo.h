//
//  SearchReusltInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/10.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"
#import "RoomInfo.h"

@interface SearchResultInfo : BaseObject


@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *erbanNo;
@property (copy, nonatomic) NSString *fansNum;
@property (assign, nonatomic) UserGender gender;
@property (copy, nonatomic) NSString *nick;
@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) RoomType type;
@property (assign, nonatomic) BOOL valid;
@property (assign, nonatomic) NSInteger roomId;

@property (nonatomic, assign) BOOL hasPrettyErbanNo;
@property (nonatomic, assign) BOOL newUser;
@property (strong, nonatomic) SingleNobleInfo *nobleUsers;
@property(nonatomic, strong)  LevelInfo *userLevelVo;

@property(nonatomic, assign) AccountType defUser;

/// 用户所在房间的房主uid
@property (nonatomic, copy) NSString *userInRoomUid;

@end
