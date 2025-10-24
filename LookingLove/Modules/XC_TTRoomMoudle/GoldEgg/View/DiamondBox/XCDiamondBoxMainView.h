//
//  XCBoxView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>
#import <YYText.h>
#import "BoxCore.h"
#import "XCBoxSelecteView.h"
#import "BoxCirtData.h"

@class XCDiamondBoxBuyLabel;

typedef enum : NSUInteger {
    XCDiamondBoxMainViewEventTypeClose,//关闭
    XCDiamondBoxMainViewEventTypeRecode,//中奖纪录
    XCDiamondBoxMainViewEventTypeHelp,//帮助
    XCDiamondBoxMainViewEventTypeJackpot,//奖池
    XCDiamondBoxMainViewEventTypeBuyKey,//购买
    XCDiamondBoxMainViewEventTypeRecharge,//充值
    XCDiamondBoxMainViewEventTypeEnergyQuestion,// 能量值帮助
} XCDiamondBoxMainViewEventType;

typedef enum : NSUInteger {
    XCDiamondBoxMainViewMessageTipStateClose,//关闭提示
    XCDiamondBoxMainViewMessageTipStateOpen,//打开提示
} XCDiamondBoxMainViewMessageTipState;

typedef enum : NSUInteger {
    XCDiamondBoxMainViewAutoOpenBoxStateStart,//自动抽奖
    XCDiamondBoxMainViewAutoOpenBoxStatePause,//关闭自动抽奖
} XCDiamondBoxMainViewAutoOpenBoxState;

@class XCDiamondBoxMainView;

@protocol XCDiamondBoxMainViewDelegate

@required
- (void)diamondBoxMainView:(XCDiamondBoxMainView *)diamondBoxMainView eventType:(XCDiamondBoxMainViewEventType)eventType;
- (void)diamondBoxMainView:(XCDiamondBoxMainView *)diamondBoxMainView didChangeAutoOpenState:(XCDiamondBoxMainViewAutoOpenBoxState)state;
- (void)diamondBoxMainView:(XCDiamondBoxMainView *)diamondBoxMainView didChangeMessageTipState:(BOOL)sendMessage;
- (void)diamondBoxMainViewOpenBox:(XCDiamondBoxMainView *)diamondBoxMainView openCountType:(XCBoxSelectOpenCountType)openCountType sendMessage:(BOOL)sendMessage;

@end

@interface XCDiamondBoxMainView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong, readonly) XCDiamondBoxBuyLabel *buyLabel;// 购买
//@property (nonatomic, strong) YYLabel *boxTips; // boxTips

- (void)updateKey:(int)count;//更新🔑
- (void)updateTimeLeft:(int)timeLeft;//更新 timeleft
- (void)stopCountdown; // 活动结束，停止计时
- (void)updateProgress:(CGFloat)value;// 更新 progress value
- (void)updateProgressWithRanges:(NSArray <NSNumber *> *)ranges; // 更新能量值区间段
- (void)cleanProgressBoxView; // 清除进度条上的 box
- (void)updateLuckyValueExpireDays:(int )days;//更新 LuckyValueExpireDays
- (void)updateGold:(NSString *)gold;//更新金币
- (void)resetBox;//关闭箱子
- (void)updateBoxState:(NSArray *)boxPrizes type:(XCBoxOpenBoxType)type;//开箱子礼物动画
- (void)updateBg:(NSString *)bgUrl;//更新背景
- (void)resetAutoOpenBoxStatue;//回复自动开宝箱按钮状态

/**
 暴击活动开始
 
 @param cirtData 暴击活动模型
 */
- (void)beginCirtActivity:(BoxCirtData *)cirtData;

/**
 暴击活动结束
 */
- (void)endCirtActivity;
@end
