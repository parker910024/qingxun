//
//  TTLittleWorldTopicView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTLittleWorldEditTopicView.h"
#import "TTLittleWorldPartyPersonView.h"
#import "LittleWorldTeamModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TTLittleWorldTopicView;

typedef NS_ENUM(NSUInteger){
    TTLittleWorldTopicViewType_OnLineAndTopic = 1,//话题和在线都有
    TTLittleWorldTopicViewType_Topic = 2,//只有话题
  
}TTLittleWorldTopicViewType;

@protocol TTLittleWorldTopicViewDelegate <NSObject>

@optional
/** 关闭显示的派对中的人数*/
- (void)ttLittleWorldTopicView:(TTLittleWorldTopicView *)view closeNumberPerson:(UIButton  *)sender;

/** 查看所有的派对中的人*/
- (void)ttLittleWorldTopicViewCheckNumberPerson:(TTLittleWorldTopicView *)view;

/** 编辑派对话题的*/
- (void)ttLittleWorldTopicView:(TTLittleWorldTopicView *)view managerEditTopicAction:(UIButton *)sender;

@end

@interface TTLittleWorldTopicView : UIView

/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldTopicViewDelegate> delegate;
/** 编辑话题*/
@property (nonatomic,strong) TTLittleWorldEditTopicView *editTopicView;
/** 显示人数*/
@property (nonatomic,strong) TTLittleWorldPartyPersonView *partyView;

/** 给话题的view赋值*/
- (void)updateTTLittleWorldTopicViewFrameWithType:(TTLittleWorldTopicViewType)type teamPartyModel:(LittleWorldTeamModel *)partyModel isCreateEr:(BOOL)isCreate;

@end

NS_ASSUME_NONNULL_END
