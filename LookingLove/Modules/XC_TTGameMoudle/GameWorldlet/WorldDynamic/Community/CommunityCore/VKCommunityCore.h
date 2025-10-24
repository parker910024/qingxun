//
//  CPBindCore.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCore.h"
@class CTDynamicModel;
@class LTUnreadModel;

NS_ASSUME_NONNULL_BEGIN

@interface VKCommunityCore : BaseCore

//发布动态是否有先拍照 在拍摄视频
@property (nonatomic, assign) BOOL isPutDynamicPhoto;

/**
 请求我的动态列表
 
 @param uid 用户uid
 @param pageNum 页数
 */
- (void)requestMyDynamicListWithUid:(NSString *)uid pageNum:(NSInteger)pageNum sender:(id)sender;

/**
 请求动态列表  (社区动态)

 @param start 用于上拉避免重复数据
 @param pageNum 页数
 */
- (void)requestDynamicListWithStart:(NSString *)start
                          pageNum:(NSInteger)pageNum;

- (void)requestDynamicListWithWorldID:(NSString *)worldID pageNum:(NSInteger)pageNum;
/**
 发布动态
 uid 、content 、imageUrl、topicId 四个参数
 @param model 动态模型
 */
- (void)requestDynamicAddWithDynamicModel:(CTDynamicModel *)model;

/**
 删除动态

 @param dynamicId 动态id
 @param uid uid
 */
- (void)requestDynamicDeleteWitDynamicId:(long)dynamicId uid:(NSString *)uid;


/**
 点赞/取消点赞
 
 @param dynamicId 动态id
 @param uid 用户uid
 @param isLike true 点赞 false 取消
 @param dynamicUid 动态发布者的uid
 */
- (void)requestDynamicLikeWitDynamicId:(long)dynamicId
                               uid:(NSString *)uid
                               isLike:(BOOL)isLike
                               dynamicUid:(NSString *)dynamicUid;


/**
 请求动态详情

 @param dynamicId 动态id
 @param uid uid
 */
- (void)requestDynamicDetailsWitDynamicId:(long)dynamicId uid:(NSString *)uid;

/**
 tab列表  包含首页的 和 话题的

 @param uid uid
 */
- (void)requestTabListWitUid:(NSString *)uid sender:(id)sender;

/**
 首页话题列表

 @param uid uid
 */
- (void)requestHomeTopicsWitUid:(NSString *)uid;

/**
 获取推荐话题（用在发布动态）

 @param uid uid
 */
- (void)requestTopicsRecommendWitUid:(NSString *)uid;

/**
 获取全部的话题  (全部话题展示)
 
 @param uid uid
 @param pageNum 页数
 */
- (void)requestTopicListWitUid:(NSString *)uid pageNum:(NSInteger)pageNum;


/*******************************红包相关********************************/

/**
 点击勾搭他发送消息
 
 @param uid uid 谁点击填谁
 @param dynamicId 动态id
 */
- (void)requestDynamicSeduceWitUid:(NSString *)uid dynamicId:(long)dynamicId sender:(id)sender;

/**
 领取红包

 @param uid 发帖人的uid
 @param dynamicId 动态id
 @param receiveUid 领红包人的ui
 */
//- (void)requestRedpacketReceiveWitUid:(NSString *)uid dynamicId:(long)dynamicId receiveUid:(NSString *)receiveUid sender:(id)sender;

/**
 判断是否领取过红包
 
 @param uid 发帖人的uid
 @param dynamicId 动态id
 @param receiveUid 领红包人的ui
 */
- (void)requestRedpacketIsReceiveWitUid:(NSString *)uid dynamicId:(long)dynamicId receiveUid:(NSString *)receiveUid sender:(id)sender;

/**
 验证动态红包是否领取完了
 
 @param uid 发帖人的uid
 @param dynamicId 动态id
 */
- (void)requestRedpacketEffectiveWitUid:(NSString *)uid dynamicId:(long)dynamicId sender:(id)sender;


/**
  查询动态房间

 @param uid 发帖人的uid
 */
- (void)requestFindDynamicRoomWitUid:(NSString *)uid sender:(id)sender;


/**
 把动态重置为过期
 
 @param uid 发帖人uid
 @param dynamicId 动态id
 */
- (void)requestDynamicExpireWitUid:(NSString *)uid dynamicId:(long)dynamicId sender:(id)sender;



/**
 获取未读列表 点赞列表
 
 @param type 类型 0, 评论 1，点赞
 */
- (void) requestUnReadListType:(int)type;

/**
 清除消息
 
 @param type 类型 0, 评论 1，点赞
 */
- (void)requestUnReadClearListTpye:(int)type;
- (void)getUnReadCountSuccess:(void (^)(LTUnreadModel *model))success;

/**
 获取未读数量
 */
- (void)requestUnReadCount;

/**
 查询评论历史消息
 
 @param type 类型 0, 评论 1，点赞
 @param page 页数
 */
- (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate;


/**
 请求广场数据
 */
- (void)requestDynamicGetSquareData;



/**
 根据自己id和他人id查询两人是否拉黑状态
 
 @param myUid 自己的uid
 @param toUid 他人的uid
 @param userVc 记录的个人主页控制器
 */
- (void)requestGetBlackListStatusWithMyUid:(long)myUid toUid:(long)toUid userVc:(UIViewController *)userVc;

@end

NS_ASSUME_NONNULL_END
