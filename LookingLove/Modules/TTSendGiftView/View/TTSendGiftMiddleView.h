//
//  TTSendGiftMiddleView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTSendGiftView.h"

NS_ASSUME_NONNULL_BEGIN
@class TTSendGiftMiddleView, GiftInfo, RoomMagicInfo;

@protocol TTSendGiftMiddleViewDelegate<NSObject>
@optional

/**
 赠送贵族礼物 tip

 @param sendGiftMiddleView self
 @param currentLevel 当前用户的贵族等级
 @param needLevel 当前赠送礼物所需的贵族等级
 */
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView currentNobleLevel:(NSInteger)currentLevel needNobelLevel:(NSInteger)needLevel;

/**
 展示和隐藏喊话的输入框 时的回调, 外界更新高度

 @param sendGiftMiddleView self
 @param isShow yes:展示 no:隐藏
 */
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView layoutMsgTextField:(BOOL)isShow;

/**
 选中了礼物 时的回调

 @param sendGiftMiddleView self
 @param gift 礼物模型 可能是魔法模型 or 礼物模型
 */
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView didSelectGift:(id)gift;

/**
 萝卜币不足

 @param sendGiftMiddleView self
 @param errorMsg 错误提示
 */
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView notEnoughtCarrot:(NSString *)errorMsg;
@end

@interface TTSendGiftMiddleView : UIView
@property (nonatomic, weak) id<TTSendGiftMiddleViewDelegate> delegate;
/** 礼物面板，魔法，礼物背包公用collectionView */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, assign) SelectGiftType currentType;//当前选择的礼物类型
@property (nonatomic, assign) XCSendGiftViewUsingPlace usingPlace;//送礼组件使用的地方
@property (nonatomic, strong, readonly) GiftInfo *lastSelectGiftInfo;//上次选择的礼物
@property (nonatomic, strong, readonly) RoomMagicInfo *lastSelectMagicInfo;//上次选择的魔法
@property (nonatomic, strong, readonly) GiftInfo *lastSelectNobleInfo;//上次选择的贵族礼物
@property (nonatomic, strong, readonly) GiftInfo *lastSelectPackInfo;//上次选择的礼物背包
/** 礼物喊话 */
@property (nonatomic, strong, readonly) UITextField *msgTextField;

/**
 初始化方法

 @param roomUid 房间礼物面板时, 房间uid
 @return self
 */
- (instancetype)initWithRoomUid:(NSInteger)roomUid;
@end

NS_ASSUME_NONNULL_END
