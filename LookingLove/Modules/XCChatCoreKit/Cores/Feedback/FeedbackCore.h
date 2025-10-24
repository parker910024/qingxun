//
//  FeedbackCore.h
//  BberryCore
//
//  Created by chenran on 2017/7/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface FeedbackCore : BaseCore
- (void)requestFeedback:(NSString *)content contact:(NSString *)contact;

- (void)requestFeedback:(NSString *)content contact:(NSString *)contact image:(NSString *)image;

/// 用户反馈
/// @param content 内容
/// @param contact 联系方式
/// @param source 反馈来源(SET_UP_PAGE -- 设置页, DRAW -- 转盘活动, ROOM_RED -- 房间红包)
/// @param imageURLs 图片url,用逗号隔开
- (void)requestFeedback:(NSString *)content
                contact:(NSString *)contact
                 source:(NSString *)source
              imageURLs:(NSString *)imageURLs;

@end
