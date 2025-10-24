//
//  TTHomeRecommendDetailData.h
//  AFNetworking
//
//  Created by lvjunhang on 2018/11/13.
//  兔兔首页推荐数据模型里子模型（具体数据）

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTHeadlineTipType) {
    TTHeadlineTipTypeNone = 0,//没有？
    TTHeadlineTipTypeATme = 1,//@wo
    TTHeadlineTipTypeNewest = 2,//最新
    TTHeadlineTipTypeMonster = 3,//打怪
};

@class TTHomeRecommendDetailBannerScroll, TTHomeRecommendDetailBannerPanel;

@interface TTHomeRecommendDetailData : BaseObject

/// 顶部列表Banner模块数据（滚动+固定）
@property (nonatomic, strong) NSArray<TTHomeRecommendDetailBannerScroll *> *topBannerList;
@property (nonatomic, strong) NSArray<TTHomeRecommendDetailBannerPanel *> *panelList;

/// Headline头条模块-8 数据
@property (nonatomic, assign) NSInteger _id;//Convert from id
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *param;
@property (nonatomic, assign) TTHeadlineTipType tipType;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger paramType;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger topLineType;

/// 佛系交友模块-7 数据
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *roomTag;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger recomSeq;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, copy) NSString *roomDesc;
@property (nonatomic, copy) NSString *backPic;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger onlineNum;
@property (nonatomic, assign) BOOL isRecom;
@property (nonatomic, assign) NSInteger isPermitRoom;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger operatorStatus;
@property (nonatomic, assign) NSInteger calcSumDataIndex;
@property (nonatomic, copy) NSString *tagPict;
//下面有共用字段
//@property (nonatomic, copy) NSString *title;

/// 为你推荐（星发现）
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, assign) BOOL hasAnimationEffect;
@property (nonatomic, copy) NSString *roomPwd;
@property (nonatomic, assign) BOOL hasKTVPriv;
@property (nonatomic, assign) NSInteger abChannelType;
@property (nonatomic, assign) BOOL isExceptionClose;
@property (nonatomic, assign) BOOL isCloseScreen;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, assign) NSInteger audioQuality;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) BOOL isOpenKTV;
@property (nonatomic, assign) NSInteger officeUser;
@property (nonatomic, copy) NSString *badge;//flag角标：hot new etc
//下面有共用字段
//@property (nonatomic, assign) NSInteger isPermitRoom;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, assign) NSInteger gender;
//@property (nonatomic, assign) NSInteger calcSumDataIndex;
//@property (nonatomic, assign) NSInteger isRecom;
//@property (nonatomic, copy) NSString *nick;
//@property (nonatomic, assign) NSInteger roomId;
//@property (nonatomic, copy) NSString *avatar;
//@property (nonatomic, assign) NSInteger count;
//@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, copy) NSString *roomTag;
//@property (nonatomic, assign) NSInteger operatorStatus;
//@property (nonatomic, assign) NSInteger onlineNum;
//@property (nonatomic, copy) NSString *tagPict;
//@property (nonatomic, assign) NSInteger tagId;
//@property (nonatomic, assign) NSInteger uid;

/// KTV（和我一起嗨）
@property (nonatomic, assign) NSInteger roomUid;
@property (nonatomic, copy) NSString *singingMusicName;
//下面有共用字段
//@property (nonatomic, copy) NSString *roomDesc;
//@property (nonatomic, assign) NSInteger onlineNum;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, assign) NSInteger roomId;
//@property (nonatomic, copy) NSString *avatar;

@end


/**
 首页 banner （滚动）
 */
@interface TTHomeRecommendDetailBannerScroll: NSObject
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
@interface TTHomeRecommendDetailBannerPanel: NSObject
@property (nonatomic, copy) NSString *skipUrl;
@property (nonatomic, assign) NSInteger skipType;
@property (nonatomic, assign) NSInteger seqNo;
@property (nonatomic, copy) NSString *panelName;
@property (nonatomic, copy) NSString *panelPic;
@property (nonatomic, assign) NSInteger panelId;
@end

NS_ASSUME_NONNULL_END
