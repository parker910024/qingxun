//
//  TTRoomUIClient.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankCore.h"

@protocol TTRoomUIClient <NSObject>
@optional

- (void)roomVCWillDisappear;
- (void)scrollToContributionView;
- (void)dismissFaceView;
//礼物特效状态变更
- (void)updateGiftEffectState;
//房间榜变更
- (void)roomRankingsTypeUpdate:(RankType)rankingType dataType:(RankDataType)dataType;
//获取房主信息成功
- (void)roomUIClientOnGetUserInfoByUidSuccess;


@end
