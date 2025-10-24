//
//  StrangerAgreeCoupleInfo.h
//  AFNetworking
//
//  Created by apple on 2018/12/11.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface StrangerAgreeCoupleInfo : BaseObject

/**房间id*/
@property(nonatomic, assign) UserID roomId;

/**cp头像*/
@property(nonatomic, copy) NSString *cpAvatar;

/**头像*/
@property(nonatomic, copy) NSString *avatar;
/**
 "你们已经是CP啦" &&  “若最终和 XXX 成功绑定后，你将和 YYY 解绑CP（所有记录&奖励清零）。确定向 XXX 发起CP申请？”，
 */
@property(nonatomic, copy) NSString *title;

/**是否有CP*/
@property(nonatomic, assign) BOOL couple;

/**
 CPUid
 */
@property(nonatomic, assign) UserID cpUid;

/**天数*/
@property(nonatomic, copy) NSString *duration;

/**金额*/
@property(nonatomic, copy) NSString *reward;

@end

NS_ASSUME_NONNULL_END
