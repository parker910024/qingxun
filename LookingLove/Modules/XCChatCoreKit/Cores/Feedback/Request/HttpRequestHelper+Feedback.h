//
//  HttpRequestHelper+Feedback.h
//  BberryCore
//
//  Created by chenran on 2017/7/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"

@interface HttpRequestHelper (Feedback)
/**
 反馈

 @param content 内容
 @param contact 联系人
 @param success 成功
 @param failure 失败
 */
+ (void)requestFeedback:(NSString *)content contact:(NSString *)contact
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 Allo 反馈
 
 @param content 内容
 @param contact 联系人
 @param imageURL 反馈图片
 @param success 成功
 @param failure 失败
 */
+ (void)requestFeedback:(NSString *)content contact:(NSString *)contact image:(NSString *)imageURL
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 用户反馈
/// @param content 内容
/// @param contact 联系方式
/// @param source 反馈来源(SET_UP_PAGE -- 设置页, DRAW -- 转盘活动, ROOM_RED -- 房间红包)
/// @param imageURLs 图片url,用逗号隔开
+ (void)requestFeedback:(NSString *)content
                contact:(NSString *)contact
                 source:(NSString *)source
              imageURLs:(NSString *)imageURLs
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end
