//
//  strangerLisInfo.h
//  UKiss
//
//  Created by apple on 2018/10/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    strangerRoomStatus_wait = 1,//等待陪伴
    strangerRoomStatus_waitIng = 2,//陪伴中
    strangerRoomStatus_cpIng = 3//已奔现
}StrangerRoomStatus;

@interface StrangerRoomInfo : BaseObject

/**房间id*/
@property(nonatomic, assign) UserID roomId;

@property(nonatomic, assign) UserID roomUid;
/**房间状态描述*///陪伴状态：3种，等待陪伴/陪伴中/已奔现
@property(nonatomic, copy) NSString *statusDesc;

/**房间描述*/
@property(nonatomic, copy) NSString *desc;
/**昵称*/
@property(nonatomic, copy) NSString *nick;

@property(nonatomic, copy) NSString *avatar;

/**性别*/
@property(nonatomic, assign) UserGender gender;

/**状态*/
@property(nonatomic, assign) StrangerRoomStatus status;


/**是否是音乐播放*/
@property(nonatomic, assign) BOOL roomState;
@end

NS_ASSUME_NONNULL_END
