//
//  StrangerCoupleInfo.h
//  AFNetworking
//
//  Created by apple on 2018/12/10.
//

#import "BaseObject.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface StrangerCoupleInfo : BaseObject

/**房间id*/
@property(nonatomic, assign) UserID roomId;

/**"这样我们就可以用1000块买2000包辣条了"*/
@property(nonatomic, copy) NSString *desc;

/**
 "你们已经是CP啦" &&  “若最终和 XXX 成功绑定后，你将和 YYY 解绑CP（所有记录&奖励清零）。确定向 XXX 发起CP申请？”，
 */
@property(nonatomic, copy) NSString *title;

/**是否有CP*/
@property(nonatomic, assign) BOOL couple;

/**
 CPUid
 */
@property(nonatomic, assign) UserID coupleUid;
// 1-17 
@property(nonatomic, assign) UserID newCoupleUid;

//1的话表示become后可以组成cp // 新增 type为2 表示该消息已经失效
@property(nonatomic, assign) int type;
// 对方点组cp 我w点c组cp 就组cp成功 直接显示动画

/**cp头像*/
@property(nonatomic, copy) NSString *cpAvatar;

/**头像*/
@property(nonatomic, copy) NSString *avatar;
/**
 CPUid 动画
 */
@property(nonatomic, assign) UserID cpUid;

/**天数*/
@property(nonatomic, copy) NSString *duration;

/**金额*/
@property(nonatomic, copy) NSString *reward;

@end

NS_ASSUME_NONNULL_END
