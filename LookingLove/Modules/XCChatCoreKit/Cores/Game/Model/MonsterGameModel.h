//
//  MonsterGameModel.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/22.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseGameModel.h"

typedef enum {
    MonsterStatus_WillAppear = 1, //未开始 (即将出现)
    MonsterStatus_DidAppear = 2, //开始 （已出现）
    MonsterStatus_DidDead = 3, //怪兽死亡 （怪兽被打败）
    MonsterStatus_DidLeave = 4,//离开 （怪兽已逃走）
}MonsterStatus;

@interface MonsterGameModel : BaseGameModel

@property (nonatomic,copy) NSString *monsterId;//怪兽id
@property (nonatomic,assign) NSInteger totalBlood;//总血量
@property (nonatomic,assign) NSInteger remainBlood;//残血余量

@property (nonatomic,copy) NSString *monsterName;//怪兽名
@property (nonatomic,copy) NSString *monsterImg;//怪兽图片

@property (nonatomic,copy) NSString *appearSvg;//进场动画
@property (nonatomic,copy) NSString *normalSvg;//正常动画
@property (nonatomic,copy) NSString *attackSvg;//打击动画
@property (nonatomic,copy) NSString *defeatSvg;//打爆动画
@property (nonatomic,copy) NSString *escapeSvg;//逃走动画
@property (nonatomic,copy) NSString *hallNotifyBg;//大厅出现背景
@property (nonatomic,copy) NSString *hallNotifyClockImg;//大厅Lock背景
@property (nonatomic,copy) NSString *roomNotifyBg;//房间出现背景
@property (nonatomic,copy) NSString *roomNotifyClockImg;//房间Lock背景

@property (nonatomic, copy) NSString *notifyMessage;//通知文案

@property (nonatomic,copy) NSString *appearTime;//出现时间
@property (nonatomic,copy) NSString *appearDuration;//出现时长
@property (nonatomic,copy) NSString *disaperTime;//消失时间
@property (nonatomic,copy) NSString *appearRoomUid;//房主uid
@property (nonatomic, copy) NSString *serverTime;//系统时间
@property (nonatomic,assign) NSInteger remainMillis;//剩余时间

@property (nonatomic, assign) int beforeAppearSeconds;//将要出现的剩余秒数
@property (nonatomic, assign) int beforeDisappearSeconds;//距离怪兽逃跑时间

@property (nonatomic,assign) MonsterStatus monsterStatus;//怪兽状态

@property (nonatomic,assign) NSInteger sequence;//消息序号 用来判断是否是顺序，忽略不按顺序的消息



@end

