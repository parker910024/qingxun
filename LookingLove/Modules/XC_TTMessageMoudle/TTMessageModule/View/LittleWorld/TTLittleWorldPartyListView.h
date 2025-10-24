//
//  TTLittleWorldPartyListView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserID.h"
NS_ASSUME_NONNULL_BEGIN

@class TTLittleWorldPartyListView;
@protocol TTLittleWorldPartyListViewDelegate <NSObject>

@optional
- (void)ttLittleWorldPartyListView:(TTLittleWorldPartyListView *)listView didClickEnterRoomWithHasParty:(BOOL)hasParty;

/** 请求列表为空的时候 刷新控制器里面的数据*/
- (void)reloadNumberPersonWhenRequestListEmpty;

@end

@interface TTLittleWorldPartyListView : UIView

/** 世界的id */
@property (nonatomic,assign) UserID worldId;

/** 是不是有派对*/
@property (nonatomic,assign) BOOL hasParty;

/**
 代理
 */
@property (nonatomic,assign) id<TTLittleWorldPartyListViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
