//
//  BackgroundCore.h
//  BberryCore
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface BackgroundCore : BaseCore


/**
 请求背景商城列表
 
 @param page 页码
 @param pageSize 每页数量
 */
- (void)requestBackgroundListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state uid:(UserID)uid;



/**
 请求已购买背景列表
 */
- (void)requestUserBackgroundWithUid:(NSString *)uid;

/**
 请求可用背景列表
 */
- (void)requestUserAvailableBackgroundWithUid:(NSString *)uid;

/**
 购买背景
 
 @param backgroundId 背景Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyBackgroundByBackgroundId:(NSString *)backgroundId;




/**
 赠送背景
 
 @param backgroundId 背景Id
 @param targetUid  被赠送Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentBackgroundByBackgroundId:(NSString *)backgroundId toTargetUid:(UserID)targetUid;



/**
 使用背景（backgroundId传0则不适用头饰）
 
 @param backgroundId 背景Id
 @param roomUid 房主Id
 */
- (RACSignal *)useBackgroundByBackgroundId:(NSString *)backgroundId roomUid:(NSString *)roomUid;

/**
 取消使用背景
 @param roomUid 房主Id
 */
- (RACSignal *)cancelBackgroundRoomUid:(NSString *)roomUid;

/**
 获取背景详情
 
 @param backgroundId 头饰Id
 @return 包含背景详情模型的signal
 */
//- (RACSignal *)getBackgroundDetailByBackgroundId:(NSString *)backgroundId;


@end
