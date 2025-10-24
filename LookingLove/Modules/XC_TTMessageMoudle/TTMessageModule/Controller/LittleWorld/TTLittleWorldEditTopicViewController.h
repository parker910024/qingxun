//
//  TTEditTopicViewController.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UserID.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTLittleWorldEditTopicViewController : BaseUIViewController

/** 聊天话题*/
@property (nonatomic,strong) NSString *teamTopicStr;

/** 当前回话的id*/
@property (nonatomic,assign) UserID chatId;

@end

NS_ASSUME_NONNULL_END
