//
//  TTSessionViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "NIMSessionViewController.h"
#import "TTCPGameListView.h"
#import "TTSelectGameView.h"
#import "TTCPGamePrivateChatClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTSessionViewController : NIMSessionViewController

@property (nonatomic, strong) NSMutableArray *gameListArray;
@property (nonatomic, strong) UIButton *selectGameButton;
@property (nonatomic, strong) TTCPGameListView *listView;
@property (nonatomic, strong) NSString *acceptMessageID;
@property (nonatomic, strong) TTSelectGameView *gameView;
@property (nonatomic, assign) BOOL isMatchMessage;

/// 抛点数操作回调
@property (nonatomic, copy) void(^chatterboxGamePointHandler)(void);

/// 话匣子的时候 先打个招呼
- (void)chatterBoxHello;

/// 撩一下，进入私聊时，自动给对方发送一句打招呼
- (void)flirtSayHi;

@end

NS_ASSUME_NONNULL_END
