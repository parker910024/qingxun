//
//  TTLittleWorldPartyPersonView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class TTLittleWorldPartyPersonView;
@protocol TTLittleWorldPartyPersonViewDelegate <NSObject>
@optional
/** 查看在群聊里面的派对*/
- (void)ttLittleWorldPartyPersonViewCheckPartyInTeam:(TTLittleWorldPartyPersonView *)view;

@end

@interface TTLittleWorldPartyPersonView : UIView

/** 关闭*/
@property (nonatomic,strong, readonly) UIButton *closeButton;
/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldPartyPersonViewDelegate> delegate;


- (void)updateLittleWorldPartyNumberPersonWithPerson:(NSInteger)person;

@end

NS_ASSUME_NONNULL_END
