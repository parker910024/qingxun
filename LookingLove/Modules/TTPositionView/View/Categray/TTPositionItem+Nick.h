//
//  TTPositionItem+Nick.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionItem.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionItem (Nick)

/** 给麦位上的lable赋值*/
- (void)setNickContent:(UserInfo *)userInfo position:(int)position;

//  如果我在-2麦 或者不在麦上。返回YES
- (BOOL)isMeOnMicOrNoMic;
//  如果我在-2麦 返回YES
- (BOOL)isMeOnHostMic;
//  如果我在-2麦 并且我是（房主或者管理员，有操作权限） 返回YES
- (BOOL)isMeOnHostMicAndMeIsActorOrManager;
@end

NS_ASSUME_NONNULL_END
