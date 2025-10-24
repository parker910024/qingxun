//
//  MonsterAttack.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/30.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "MonsterGameModel.h"

@interface MonsterAttack : BaseObject

@property (nonatomic,assign) UserID uid;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,copy) NSString *monsterId;
@property (nonatomic,copy) NSString *monsterName;
@property (nonatomic,copy) NSString *monsterTotalBlood;
@property (nonatomic,copy) NSString *monsterRemainBlood;
@property (nonatomic,assign) MonsterStatus monsterStatus;//怪兽状态
@property (nonatomic,copy) NSString *magicId;
@property (nonatomic, copy) NSString *magicIcon;
@property (nonatomic,assign) NSInteger impactValue;
@property (nonatomic,assign) BOOL playEffect;
@property (nonatomic,assign) NSInteger remainMillis;//剩余时间
@property (nonatomic,assign) NSInteger beforeDisappearSeconds;//还有多少时间消失
@property (nonatomic,assign) NSInteger sequence;//消息序号 用来判断是否是顺序，忽略不按顺序的消息
@end
