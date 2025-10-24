//
//  GiftChannelNotifyInfo.h
//  BberryCore
//

//  Created by KevinWang on 2018/3/29.

//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

typedef enum : NSUInteger {
    GiftChannelNotifyType_Normal = 1,
    GiftChannelNotifyType_Middle = 2,
    GiftChannelNotifyType_Full = 3,
    GiftChannelNotifyType_NamePlate = 4,
    GiftChannelNotifyType_Annual = 5,//年度全服公告
} GiftChannelNotifyType;

@interface GiftChannelNotifyInfo : BaseObject


@property (nonatomic, assign)int roomErbanNo;
@property (nonatomic, assign)int giftNum;
@property (nonatomic, assign) CGFloat notifyStaySecond;
@property (nonatomic, strong) NSString *giftUrl;
@property (nonatomic, assign) UserID sendUserUid;
@property (nonatomic, copy) NSString *sendUserAvatar;
@property (nonatomic, copy) NSString *sendUserNick;
@property (nonatomic, assign) UserID recvUserUid;
@property (nonatomic, copy) NSString *recvUserAvatar;
@property (nonatomic, copy) NSString *recvUserNick;


@property (nonatomic,assign) UserID roomUid;//房主uid
@property (nonatomic,assign) GiftChannelNotifyType levelNum;//全服礼物通知等级编号
@property (nonatomic,strong) NSString *msg;//全服喊话内容
@property (nonatomic,assign) BOOL isSkipRoom;//是否可跳转房间
@property (nonatomic,strong) NSString *roomTitle;
@property (nonatomic,assign) BOOL isSendMsg;//是否需要发送全服消息
/* 三级全服可配置UI **/
@property (nonatomic, copy) NSString *baseImg;//全服底图
@property (nonatomic, copy) NSString *gotoImg;//前往围观底图
@property (nonatomic, copy) NSString *closeImg;//关闭按钮底图
@property (nonatomic, copy) NSString *floatImg;//浮动文字底图
@property (nonatomic, copy) NSString *giveImg;//赠送底图

@property (nonatomic, assign) BOOL mp4Gift; // 当前礼物是否是MP4礼物
@property (nonatomic, assign) BOOL  confessStatus;  //是否表白礼物
@end
