//
//  UserMoment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  用户动态

#import "BaseObject.h"
#import "AnchorOrderStatus.h"

NS_ASSUME_NONNULL_BEGIN

//类型 0：纯文本，1:语音，2图片，3视频，4声音匹配，5没动态固定数据（世界那么大，这一天TA和轻寻相遇啦！）
typedef NS_ENUM(NSInteger, UserMomentType) {
    UserMomentTypeText = 0,
    UserMomentTypeVoice = 1,
    UserMomentTypePic = 2,
    UserMomentTypeVideo = 3,
    UserMomentTypeVoicePair = 4,
    UserMomentTypeGreeting = 5,
};

@class UserMomentRes;

@interface UserMoment : BaseObject
@property (nonatomic, copy) NSString *worldId;//世界id
@property (nonatomic, copy) NSString *voiceId;//声音id
@property (nonatomic, copy) NSString *dynamicId;//动态id
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, copy) NSString *publishTime;//发布时间
@property (nonatomic, copy) NSString *tag;//标签
@property (nonatomic, assign) NSInteger likeCount;//点赞数
@property (nonatomic, assign) NSInteger commentCount;//评论数
@property (nonatomic, assign) NSInteger playCount;//声音瓶子播放次数
@property (nonatomic, assign) BOOL isLike;//是否点赞
@property (nonatomic, assign) UserMomentType type;//类型
@property (nonatomic, strong) NSArray <UserMomentRes *> *dynamicResList;//动态资源列表

@property (nonatomic, strong) AnchorOrderInfo *workOrder;//认证主播的派单

@property (nonatomic, assign) BOOL fold;//是否展开文本，默认NO，客户端自用字段

@end

/// 资源属性
@interface UserMomentRes : BaseObject
@property (nonatomic, copy) NSString *resUrl;//资源url
@property (nonatomic, copy) NSString *cover;//封面,视频专有
@property (nonatomic, copy) NSString *format;//格式，image,jpg等
@property (nonatomic, assign) float resDuration;//资源时长，语音/视频专有
@property (nonatomic, assign) float width;//宽度
@property (nonatomic, assign) float height;//高度
@end

NS_ASSUME_NONNULL_END
