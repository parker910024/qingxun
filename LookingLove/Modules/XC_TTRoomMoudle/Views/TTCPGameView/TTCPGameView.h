//
//  TTCPGameView.h
//  TuTu
//
//  Created by new on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGameCoreClient.h"
#import "CPGameListModel.h"
#import "TTCPGameCustomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTCPGameView : UIView<CPGameCoreClient>

+ (instancetype)sharedGameView; // 创建单例

+ (void)attempDealloc; // 销毁单例

@property (nonatomic, strong) UIButton *selectGameBtn;
@property (nonatomic, strong) UIButton *cancelPrepareBtn;


@property (nonatomic, strong) UIButton *acceptGameBtn;
@property (nonatomic, strong) UIButton *refuseBtn; // 拒绝

@property (nonatomic, strong) NSMutableArray<CPGameListModel *> *datasourceArray; // 数据源
@property (nonatomic, assign) NSInteger index; // 选择第几个

@property (nonatomic, strong) UIButton *inviteFriendBtn;
@property (nonatomic, strong) UIButton *closeButton;

/*
    点击了选择游戏 游戏进入准备中
 */
- (void)selectGameAciton:(TTCPGameCustomModel *)returnModel;



/*
  对方拒绝了游戏 或者自己取消准备
 */
- (void)refuseAction;


/*
 
  对方接受了游戏
 
 */
- (void)acceptGameBeginActionWithModel:(TTCPGameCustomModel *)model;

- (void)HaveChoiceGameAndOtherPartyAcceptUI;

/*
 
 胜利一方的方法
 
 */
- (void)gameVictoryAction;

/*
 
 失败一方的方法
 
 */
- (void)gamefailerAction:(TTCPGameCustomModel *)customModel;



/*
 
 麦下观众的视角
 
 */
- (void)audienceCanSeeGameAction:(nullable TTCPGameCustomModel *)returnModel;

- (void)audienceCanReadyGameAction:(nullable TTCPGameCustomModel *)returnModel;

/*
 
 游戏开始麦下观众的视角
 
 */
- (void)gameBeginAudienceCanSeeGameAction;


/*
 
 游戏结束时 麦下观众的视角
 
 */
- (void)gameOverAudienceCanSeeGameAction:(TTCPGameCustomModel *)customModel;



/*
 
 游戏结束时 麦下观众平局的视角
 
 */
- (void)gameOverAndICanNotWatchWhoWin:(TTCPGameCustomModel *)customModel;



/*
 
 两个麦上都有人了移出匹配池
 
 */

- (void)RemovedFromMatchPool;



/*
   最小化的时候要把游戏状态置位初始装态
 */
- (void)cancelPrepareAction;


- (void)downMicWithGameSeleter;
@end

NS_ASSUME_NONNULL_END
