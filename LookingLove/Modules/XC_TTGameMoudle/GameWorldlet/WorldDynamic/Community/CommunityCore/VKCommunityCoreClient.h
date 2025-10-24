//
//  CPBindCoreClient.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTUnreadModel.h"
@class CTDynamicModel;
@class CTTabTopicModel;
@class VKDynamicRedPackageModel;
@class XCRedPckageModel;
@protocol VKCommunityCoreClient <NSObject>

@optional

/**请求动态列表成功*/
- (void)requestDynamicListSuccess:(NSArray <CTDynamicModel *>*)modelList;
- (void)requestDynamicListFailth:(NSString *)message;

/**请求我的动态列表成功(个人中心)*/
- (void)requestMyDynamicListSuccess:(NSArray <CTDynamicModel *>*)modelList sender:(id)sender;
- (void)requestMyDynamicListFailth:(NSString *)message;

/**发布动态成功*/
- (void)requestDynamicAddSuccess:(CTDynamicModel *)dynamicModel;
- (void)requestDynamicAddFailth:(NSString *)message;

/**删除动态成功*/
- (void)requestDynamicDeleteSuccess;
- (void)requestDynamicDeleteFailth:(NSString *)message;

/**点赞成功*/
- (void)requestDynamicLikeSuccess;
- (void)requestDynamicLikeFailth:(NSString *)message dynamicId:(long)dynamicId;

/**请求动态详情成功*/
- (void)requestDynamicDetailsSuccess:(CTDynamicModel *)dynamicModel;
- (void)requestDynamicDetailsFailth:(NSNumber *)resCode;

/**社区获取tab列表*/
- (void)requestCommunityTabListSuccessTabModelList:(NSArray <CTTabTopicModel *>*)homeTabModelList topicTabModelList:(NSArray <CTTabTopicModel *>*)topicTabModelList sender:(id)sender;
- (void)requestCommunityTabListFailth:(NSString *)message;

/**首页话题列表*/
- (void)requestHomeTopicsSuccess:(NSArray <CTTabTopicModel *>*)topicsModelList;
- (void)requestHomeTopicsFailth:(NSString *)message;

/**获取推荐话题（用在发布动态）*/
- (void)requestTopicsRecommendSuccess:(NSArray <CTTabTopicModel *>*)topicsModelList;
- (void)requestTopicsRecommendFailth:(NSString *)message;

/**获取全部的话题  (全部话题展示)*/
- (void)requestTopicListSuccess:(NSArray <CTTabTopicModel *>*)topicsModelList;
- (void)requestTopicListFailth:(NSString *)message;

/*******************************红包相关********************************/

/**点击勾搭他发送消息*/
- (void)requestDynamicSeduceSuccessWithSender:(id)sender;
- (void)requestDynamicSeduceFailth:(NSString *)message sender:(id)sender;


/** 判断是否领取过红包*/
- (void)requestRedpacketIsReceiveSuccessWithSender:(id)sender;
- (void)requestRedpacketIsReceiveFailth:(NSString *)message sender:(id)sender;

/**验证动态红包是否领取完了*/
- (void)requestRedpacketEffectiveSuccess:(BOOL)isEffective sender:(id)sender;
- (void)requestRedpacketEffectiveFailth:(NSString *)message sender:(id)sender;

/**查询动态房间*/
- (void)requestFindDynamicSuccess:(long long)roomId sender:(id)sender;
- (void)requestFindDynamicFailth:(NSString *)message sender:(id)sender;

/** 把动态重置为过期*/
- (void)requestDynamicExpireSuccessWithSender:(id)sender;
- (void)requestDynamicExpireFailth:(NSString *)message sender:(id)sender;


// 未读评论 1，点赞列表
- (void) onRequestUnReadListSuccess:(NSArray *)lists;
- (void) onRequestUnReadListFailth:(NSString *)msg;

//清空评论点赞列表
- (void) requestUnReadClearListSuccess;
- (void) requestUnReadClearListFailth:(NSString *)msg;

//获取未读消息总数
- (void) requestUnReadCountTpyeSuccess:(LTUnreadModel *)model;
- (void) requestUnReadCountFailth:(NSString *)msg;


// 历史消息评论 1，点赞列表
- (void) onRequestHistoryListSuccess:(NSArray *)lists;
- (void) onRequestHistoryListFailth:(NSString *)msg;


// 获取广场数据
- (void)requestDynamicGetSquareSuccess:(NSArray <CTDynamicModel *>*)modelList;
- (void)requestDynamicGetSquareFailth:(NSString *)msg;


// 根据自己id和他人id查询两人是否拉黑状态
- (void)requestGetBlackListStatusSuccess:(NSInteger)likeStatus userVc:(UIViewController *)userVc;
- (void)requestGetBlackListStatusFailth:(NSString *)msg;


@end
