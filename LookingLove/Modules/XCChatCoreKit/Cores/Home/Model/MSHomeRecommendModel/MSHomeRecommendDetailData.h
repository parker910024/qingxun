//
//  MSHomeRecommendDetailData.h
//  AFNetworking
//
//  Created by lvjunhang on 2018/12/21.
//  萌声首页推荐数据模型里子模型（具体数据）

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTHeadlineTipType) {
    TTHeadlineTipTypeNone = 0,//没有？
    TTHeadlineTipTypeATme = 1,//@wo
    TTHeadlineTipTypeNewest = 2,//最新
    TTHeadlineTipTypeMonster = 3,//打怪
};

@class MSHomeRecommendDetailBannerScroll, MSHomeRecommendDetailBannerPanel;

@interface MSHomeRecommendDetailData : BaseObject

/// 顶部列表Banner模块数据（滚动+固定）
@property (nonatomic, strong) NSArray<MSHomeRecommendDetailBannerScroll *> *topBannerList;
@property (nonatomic, strong) NSArray<MSHomeRecommendDetailBannerPanel *> *panelList;

/// 通用房间组信息
@property (nonatomic, copy) NSString *singingMusicName;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger isRecom;
@property (nonatomic, copy) NSString *tagPict;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *backPic;
@property (nonatomic, assign) NSInteger recomSeq;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString *roomDesc;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger onlineNum;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, assign) NSInteger calcSumDataIndex;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *roomTag;
@property (nonatomic, assign) BOOL isOpenKTV;
@property (nonatomic, assign) NSInteger operatorStatus;
@property (nonatomic, assign) NSInteger isPermitRoom;
@property (nonatomic, assign) BOOL isFlowTop;


/// 热门K歌房
@property (nonatomic, assign) BOOL exceptionClose;
@property (nonatomic, assign) NSInteger audioQuality;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) BOOL hasKTVPriv;
@property (nonatomic, assign) BOOL hasAnimationEffect;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, assign) NSInteger officeUser;
@property (nonatomic, assign) BOOL isCloseScreen;
@property (nonatomic, assign) NSInteger openTime;
@property (nonatomic, assign) BOOL hasWholeMicroGift;
@property (nonatomic, assign) BOOL isExceptionClose;
@property (nonatomic, assign) NSInteger abChannelType;
@property (nonatomic, copy) NSString *roomPwd;
@property (nonatomic, assign) BOOL hasDragonGame;
@property (nonatomic, copy) NSString *introduction;
///热门K歌房重复部分
//@property (nonatomic, assign) NSInteger operatorStatus;
//@property (nonatomic, assign) NSInteger roomId;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, assign) NSInteger count;
//@property (nonatomic, assign) NSInteger uid;
//@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, assign) NSInteger isPermitRoom;
//@property (nonatomic, assign) NSInteger isRecom;
//@property (nonatomic, assign) NSInteger calcSumDataIndex;
//@property (nonatomic, copy) NSString *backPic;
//@property (nonatomic, copy) NSString *roomDesc;
//@property (nonatomic, copy) NSString *roomTag;
//@property (nonatomic, assign) BOOL isOpenKTV;
//@property (nonatomic, assign) NSInteger tagId;
//@property (nonatomic, copy) NSString *tagPict;

@property (nonatomic, copy) NSString *badge;

///底部导航(banner)
@property (nonatomic, assign) NSInteger seqNo;
@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, copy) NSString *bannerPic;
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, assign) NSInteger skipType;
@property (nonatomic, copy) NSString *skipUri;
@property (nonatomic, copy) NSString *bannerName;

@end

/**
 首页 banner （滚动）
 */
@interface MSHomeRecommendDetailBannerScroll: NSObject
@property (nonatomic, assign) NSInteger seqNo;
@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, copy) NSString *bannerPic;
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, assign) NSInteger skipType;
@property (nonatomic, copy) NSString *skipUri;
@property (nonatomic, copy) NSString *bannerName;
@end

/**
 首页 banner （固定）
 */
@interface MSHomeRecommendDetailBannerPanel: NSObject
@property (nonatomic, copy) NSString *skipUrl;
@property (nonatomic, assign) NSInteger skipType;
@property (nonatomic, assign) NSInteger seqNo;
@property (nonatomic, copy) NSString *panelName;
@property (nonatomic, copy) NSString *panelPic;
@property (nonatomic, assign) NSInteger panelId;
@end

NS_ASSUME_NONNULL_END
