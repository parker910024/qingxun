//
//  TTSendGiftView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserID.h"
#import "GiftInfo.h"

NS_ASSUME_NONNULL_BEGIN
@class TTSendGiftView, UserInfo;

typedef NS_ENUM(NSUInteger, SelectGiftType) {
    SelectGiftType_gift = 0,//礼物
    SelectGiftType_giftPackage = 1,//背包礼物
    SelectGiftType_nobleGift = 2,//贵族礼物
    SelectGiftType_magic = 3,//魔法
};

typedef enum : NSUInteger {
    XCSendGiftViewUsingPlace_Room,//房间
    XCSendGiftViewUsingPlace_Message,//私聊
    XCSendGiftViewUsingPlace_PublcChat,//公聊
    XCSendGiftViewUsingPlace_Team,//群聊
} XCSendGiftViewUsingPlace;

@protocol TTSendGiftViewDelegate<NSObject>
@optional
- (void)sendGiftView:(TTSendGiftView *)sendGiftView showUserInfoCardWithUid:(UserID)userid;//查看资料
- (void)sendGiftViewDidClose:(TTSendGiftView *)sendGiftView;//关闭
- (void)sendGiftViewDidClickReport:(TTSendGiftView *)sendGiftView;//举报
- (void)sendGiftViewDidClickRecharge:(TTSendGiftView *)sendGiftView type:(GiftConsumeType)type;//充值
- (void)sendGiftViewDidClickBecomeNobe:(TTSendGiftView *)sendGiftView;//开通贵族
- (void)sendGiftView:(TTSendGiftView *)sendGiftView currentNobleLevel:(NSInteger)currentLevel needNobelLevel:(NSInteger)needLevel;//tip
- (void)sendGiftView:(TTSendGiftView *)sendGiftView notEnoughtCarrot:(NSString *)errorMsg; // 萝卜不足提示
@end

@interface TTSendGiftView : UIView
@property (weak, nonatomic) id<TTSendGiftViewDelegate> delegate;
/** 送礼组件使用的地方 */
@property (nonatomic, assign) XCSendGiftViewUsingPlace usingPlace;
/** 当前选择的礼物类型 */
@property (nonatomic, assign) SelectGiftType currentType;
/** 礼物接受方信息 */
@property (nonatomic, strong) UserInfo *targetInfo;

/** 群聊送礼物的 群聊的id*/
@property (nonatomic,strong) NSString *sessionId;
/// 是否有首次充值资格
@property (nonatomic, assign) BOOL isFirstRecharge;
/**
 礼物view初始化方法
 
 @param frame frame
 @param usingPlace  使用场景枚举
 @param roomUid  房间uid
 @return TTSendGiftView
 */
- (instancetype)initWithFrame:(CGRect)frame
                   usingPlace:(XCSendGiftViewUsingPlace)usingPlace
                      roomUid:(NSInteger)roomUid;
@end

NS_ASSUME_NONNULL_END
