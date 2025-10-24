//
//  CPGameListModel.h
//  XCChatCoreKit
//
//  Created by new on 2019/1/11.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"
typedef enum {
    CPGameListSourceTypeThreePart = 1,//1.第三方游戏
    CPGameListSourceTypeRoomGame = 2//2.派对游戏
} CPGameListSourceType;

NS_ASSUME_NONNULL_BEGIN

@interface CPGameListModel : BaseObject

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *gameChannel;
@property (nonatomic, strong) NSString *gameIcon;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *tagIcon;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *gamePicture;

@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) BOOL checkSelf;    //是否需要区分用户的消息内容，false就默认使用otherMsg
@property (nonatomic, assign) BOOL openSkip;//是否可以跳转
@property (nonatomic, copy) NSString *gameUrl;//游戏url
@property (nonatomic, copy) NSString *selfMsg;
@property (nonatomic, copy) NSString *otherMsg;
@property (nonatomic, assign) NSInteger gameStatus;//1：游戏开始 2：进行中 3：游戏结束
@property (nonatomic, assign) NSInteger endGameType;//结束游戏类型 1：结束游戏 2：再玩一局
@property (nonatomic, assign) BOOL needDisplay;//是否需要判断弹出游戏窗口
@property (nonatomic, strong) NSArray *memberList;//成员uid列表
@property (nonatomic, assign) CPGameListSourceType sourceType;//1.第三方游戏 2.派对游戏

@property (nonatomic, copy) NSString *status;//1 上架中 2 未上架 3 下架    是    [string]
@property (nonatomic, copy) NSString *joinUrl;//游戏h5链接
@property (nonatomic, copy) NSString *roomGameStatus;// 1：未开始游戏 2：游戏中
@property (nonatomic, copy) NSString *roomGameId;//房间正在进行的游戏，如果roomGameStatus=2，roomGameId就会有值
@end

NS_ASSUME_NONNULL_END
