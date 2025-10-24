//
//  TTGuildGroupNoticeEditViewController.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/11.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//  群聊-群公告

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NoticeEditCompletion)(NSString *notice);

@class GuildHallGroupInfo;

@interface TTGuildGroupNoticeEditViewController : BaseUIViewController

/**
 群信息
 */
@property (nonatomic, strong) GuildHallGroupInfo *groupInfo;

/**
 编辑完成回调
 */
@property (nonatomic, copy) NoticeEditCompletion editCompletion;

@end

NS_ASSUME_NONNULL_END
