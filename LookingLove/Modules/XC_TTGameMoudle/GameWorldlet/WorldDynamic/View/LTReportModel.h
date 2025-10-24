//
//  LTReportTypeModel.h
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//  举报分类模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTReportModel : BaseObject
///举报分类字符串
@property (nonatomic, copy) NSString *name;
///举报分类标识
@property (nonatomic, assign) long long value;

/******************举报参数*******************/
/// 被举报人id
@property (nonatomic, assign) long long toUid;
///举报内容
@property (nonatomic, copy) NSString *reportContent;
///举报图片
@property (nonatomic, copy) NSString *reportImage;
///举报内容类型
@property (nonatomic, assign) long long reportContentType;
///被举报的评论
@property (nonatomic, assign) long long toCommentId;
///动态id
@property (nonatomic, assign) long long dynamicId;
///barrageId    弹幕id
@property (nonatomic, copy) NSString *barrageId;
///0.用户举报 1.动态举报 2.评论举报 3.弹幕举报   
@property (nonatomic, assign) NSInteger reportType;

@end

NS_ASSUME_NONNULL_END
