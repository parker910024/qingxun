//
//  GiftAllMicroSendInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftReceiveInfo.h"
#import "GiftInfo.h"
#import "UserInfo.h"
#import "RoomOnMicGiftValue.h"

@interface GiftAllMicroSendInfo : GiftReceiveInfo<NSCopying,NSMutableCopying>

@property (nonatomic, copy) NSArray *targetUids;
//@property (nonatomic, strong) GiftInfo  *gift;
/** 非全麦 多人送礼时 */
@property (nonatomic, copy) NSArray<UserInfo *> *targetUsers;
/** 是否是 非全麦 多人送礼 (自定义字段, 不是后台返回) */
@property (nonatomic, assign) BOOL isBatch;

//福袋礼物本地添加属性，与服务端无关
@property (nonatomic, assign) BOOL isLuckyBagGift;//是否福袋礼物
@property (nonatomic, assign) double totalPrice;//全麦福袋：礼物总价格，判断是否显示礼物横幅
@property (nonatomic, strong) NSDictionary *giftInfoMap;//全麦福袋：uid:福袋的礼物模型
@property (nonatomic, assign) NSInteger receiveGiftId; // 收到的礼物

@property (nonatomic, strong) NSString *msg; // 喊话文字

/**
 当前礼物时间，用于判断接收礼物先后
 */
@property (nonatomic, copy) NSString *currentTime;
/**
 礼物值信息
 */
@property (nonatomic, strong) NSArray<RoomOnMicGiftValueDetail *> *giftValueVos;

@end
