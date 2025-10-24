//
//  RoomOnMicGiftValue.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/23.
//  房间所有麦序用户礼物值

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class RoomOnMicGiftValueDetail;

@interface RoomOnMicGiftValue : BaseObject<YYModel>
@property (nonatomic, copy) NSString *currentTime;//系统时间戳
@property (nonatomic, strong) NSArray<RoomOnMicGiftValueDetail *> *giftValueVos;
@end

@interface RoomOnMicGiftValueDetail : BaseObject
@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) long long giftValue;//礼物值
@end

NS_ASSUME_NONNULL_END
