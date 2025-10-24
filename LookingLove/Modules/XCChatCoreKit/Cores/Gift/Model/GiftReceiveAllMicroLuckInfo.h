//
//  GiftReceiveAllMicroLuckInfo.h
//  XCChatCoreKit
//
//  Created by Macx on 2018/10/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseObject.h"
#import "GiftReceiveLuckInfo.h"
#import "RoomOnMicGiftValue.h"

@interface GiftReceiveAllMicroLuckInfo : BaseObject
@property(nonatomic, assign)UserID uid;
@property(nonatomic, assign)UserID targetUid;
@property(nonatomic, assign)NSInteger giftId;
@property(nonatomic, strong)NSString *nick;
@property (assign, nonatomic) NSInteger giftNum;
@property (copy, nonatomic) NSString *targetNick;
@property (nonatomic, strong) GiftReceiveLuckInfo  *gift;//

/**
 当前礼物时间，用于判断接收礼物先后
 */
@property (nonatomic, copy) NSString *currentTime;
/**
 礼物值信息
 */
@property (nonatomic, strong) NSArray<RoomOnMicGiftValueDetail *> *giftValueVos;

@end
