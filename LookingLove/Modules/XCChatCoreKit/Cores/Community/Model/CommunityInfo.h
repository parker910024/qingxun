//
//  CommunityInfo.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

/** 社区首页推荐模型*/

#import "BaseObject.h"



//状态(1: 未提交、2: 审核中、3: 审核成功、4: 审核失败、5: 已删除)
typedef NS_ENUM(NSUInteger, CommnuityProductStatus) {
    CommnuityProductStatus_Draft = 1,//未提交
    CommnuityProductStatus_Check,//审核中
    CommnuityProductStatus_OK,//成功
    CommnuityProductStatus_CheckFailure,//审核失败
    CommnuityProductStatus_Delete,//删除
};


NS_ASSUME_NONNULL_BEGIN

@interface CommunityInfo : BaseObject

/** 作品id*/
@property (nonatomic, copy) NSString *ID;
/** 作者uid*/
@property (nonatomic, assign) long uid;
/** 作品封面*/
@property (nonatomic, copy) NSString *cover;
/** 作品时长*/
@property (nonatomic, assign) int duration;
/** 作品地址*/
@property (nonatomic, copy) NSString *url;
/** 作品话题*/
@property (nonatomic, copy) NSString *topic;
/** 作品内容*/
@property (nonatomic, copy) NSString *content;
/** 用户地址*/
@property (nonatomic, copy) NSString *address;
/** 作者头像*/
@property (nonatomic, copy) NSString *avatar;
/** 作者昵称*/
@property (nonatomic, copy) NSString *nick;

/** 作品点赞数*/
@property (nonatomic, assign) int likeCount;
/** 作品评论数*/
@property (nonatomic, assign) int commentCount;
/** 作品分享数*/
@property (nonatomic, assign) int shareCount;
/** 是否关注了作者*/
@property (nonatomic, assign) BOOL isFollow;
/** 用户所在房间的房主uid*/
@property (nonatomic, assign) long userInRoomUid;
/** 作品创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** 该用户是否点赞了该作品 */
@property (nonatomic, assign) BOOL isLike;

//状态
@property (assign , nonatomic) CommnuityProductStatus status;

/** 本地 是否正在播放 */
@property (assign , nonatomic) BOOL isPlaying;

@end

NS_ASSUME_NONNULL_END
