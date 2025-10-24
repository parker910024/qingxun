//
//  TTMusicListController.h
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

#import "UserInfo.h"
#import "MusicInfo.h"

#import "ZJScrollPageView.h"

@class TTMusicListController;

typedef void(^DidClickAddShareMusicAction)(void);

@protocol TTMusicListControllerDelegate<NSObject>

/**
 更新正在播放的歌曲
 
 @param listController 音乐列表 self
 @param musicName 歌曲名
 */
- (void)musicListController:(TTMusicListController *)listController updateSongName:(NSString *)musicName;

/**
 更新播放音乐音量
 
 @param listController 音乐列表 self
 @param value 音量的值
 */
- (void)musicListController:(TTMusicListController *)listController updateVolValue:(float)value;

/**
 更新播放器状态，更新的时候直接去MeetingCore里面拿到当前的播放信息 GetCore（MeetingCore）
 
 @param listController 音乐列表 self
 */
- (void)onUpdatePlayingStateMusicListController:(TTMusicListController *)listController;
@end

@interface TTMusicListController : BaseUIViewController<ZJScrollPageViewChildVcDelegate>
/**
 背景图
 */
@property (strong, nonatomic) UIImageView * bgImageView;

/**
 音乐数组
 */
@property (strong, nonatomic) NSMutableArray<MusicInfo *> *musicLists;

/**
 音量
 */
@property (assign, nonatomic) NSInteger volValue;

/**
 用户信息
 */
@property (strong, nonatomic) UserInfo *currentUserInfo;

/**
 delegate：TTMusicListControllerDelegate
 */
@property (weak, nonatomic) id<TTMusicListControllerDelegate> delegate;

// 添加共享音乐点击的block
@property (nonatomic, copy) DidClickAddShareMusicAction didClickAddShareMusicAction;
@end
