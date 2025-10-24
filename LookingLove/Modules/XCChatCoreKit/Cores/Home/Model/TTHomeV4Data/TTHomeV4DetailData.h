//
//  TTHomeV4DetailData.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/2/15.
//  兔兔首页请求返回数据模型 v4接口

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTHomeV4RoomGameDetailData: NSObject
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger startUid;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString *gameId;
@end

@interface TTHomeV4DetailData : BaseObject
//房间数据
@property (nonatomic, assign) BOOL isOpenGame;
@property (nonatomic, assign) NSInteger operatorStatus;
@property (nonatomic, assign) NSInteger calcSumDataIndex;
@property (nonatomic, copy) NSString *roomTag;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger isPermitRoom;
@property (nonatomic, copy) NSString *roomDesc;
@property (nonatomic, assign) BOOL hasKTVPriv;
@property (nonatomic, assign) NSInteger onlineNum;
@property (nonatomic, copy) NSString *tagPict;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isCloseScreen;
@property (nonatomic, assign) BOOL exceptionClose;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, strong) TTHomeV4RoomGameDetailData *roomGame;
@property (nonatomic, assign) NSInteger officeUser;
@property (nonatomic, assign) BOOL hasDragonGame;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, assign) BOOL isOpenKTV;
@property (nonatomic, assign) NSInteger audioQuality;
@property (nonatomic, assign) NSInteger abChannelType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger isRecom;
@property (nonatomic, assign) NSInteger roomModeType;
@property (nonatomic, copy) NSString *backPic;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) BOOL isExceptionClose;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *roomPwd;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) NSInteger openTime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL hasAnimationEffect;

//banner数据
@property (nonatomic, assign) NSInteger seqNo;
@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, copy) NSString *bannerPic;
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, assign) NSInteger skipType;
@property (nonatomic, copy) NSString *skipUri;
@property (nonatomic, copy) NSString *bannerName;

@end

NS_ASSUME_NONNULL_END
