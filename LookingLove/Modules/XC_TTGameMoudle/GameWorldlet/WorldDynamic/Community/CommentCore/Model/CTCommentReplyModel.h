//
//  CTDynamicModel.h
//  UKiss
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018 yizhuan. All rights reserved.
// 评论、回复模型

#import <Foundation/Foundation.h>
#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTReplyModel : BaseObject
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 用户uid
@property (nonatomic, copy) NSString *uid;
/// 用户昵称
@property (nonatomic, copy) NSString *nick;
/// 回复评论的评论id
@property (nonatomic, copy) NSString *toCommentId;
/// 回复评论的uid
@property (nonatomic, copy) NSString *toUid;
/// 回复评论的昵称
@property (nonatomic, copy) NSString *toNick;
/// 评论内容
@property (nonatomic, copy) NSString *content;
/// 发布时间
@property (nonatomic, copy) NSString *publishTime;
/// 是否是楼主
@property (nonatomic, assign) BOOL landLordFlag;
/// 回复评论的评论id
@property (nonatomic, copy) NSString *replyId;

@end

@interface CTReplyInfoModel : BaseObject

@property (nonatomic, strong) NSMutableArray<CTReplyModel *> *replyList;// 剩余数量

@property (nonatomic, assign) NSInteger leftCount;
@property (nonatomic, copy) NSString *nextTimestamp;

@end
 
@interface CTCommentReplyModel : BaseObject

///缓存的评论高度
@property (nonatomic, assign) CGFloat cacheHeaderHeight;

///得到评论的高度
- (CGFloat)getCommentHeight;

#pragma mark -
#pragma mark littleWorld 2.0
// 昵称
@property (nonatomic, copy) NSString *nick;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 是否是楼主
@property (nonatomic, assign) BOOL landLordFlag;

@property (nonatomic, strong) CTReplyInfoModel *replyInfo;
// 用户 uid
@property (nonatomic, copy) NSString *uid;
///评论内容
@property (nonatomic, copy) NSString *content;
///时间
@property (nonatomic, copy) NSString *publishTime;
/// 当前评论id
@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, assign) BOOL isShowMoreReply;
@end

NS_ASSUME_NONNULL_END
