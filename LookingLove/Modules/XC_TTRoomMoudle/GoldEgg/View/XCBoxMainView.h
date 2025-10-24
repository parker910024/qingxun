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

typedef enum : NSUInteger {
    XCBoxMainViewEventTypeClose,//关闭
    XCBoxMainViewEventTypeRecode,//中奖纪录
    XCBoxMainViewEventTypeHelp,//帮助
    XCBoxMainViewEventTypeJackpot,//奖池
    XCBoxMainViewEventTypeBuyKey,//购买
    XCBoxMainViewEventTypeRecharge,//充值
    XCBoxMainViewEventTypeEnergyQuestion, // 能量值？
} XCBoxMainViewEventType;

typedef enum : NSUInteger {
    XCBoxMainViewMessageTipStateClose,//关闭提示
    XCBoxMainViewMessageTipStateOpen,//打开提示
} XCBoxMainViewMessageTipState;

typedef enum : NSUInteger {
    XCBoxMainViewAutoOpenBoxStateStart,//自动抽奖
    XCBoxMainViewAutoOpenBoxStatePause,//关闭自动抽奖
} XCBoxMainViewAutoOpenBoxState;

@class XCBoxMainView;

@protocol XCBoxMainViewDelegate

@required
- (void)boxMainView:(XCBoxMainView *)boxMainView eventType:(XCBoxMainViewEventType)eventType;
- (void)boxMainView:(XCBoxMainView *)boxMainView didChangeAutoOpenState:(XCBoxMainViewAutoOpenBoxState)state;
- (void)boxMainView:(XCBoxMainView *)boxMainView didChangeMessageTipState:(BOOL)sendMessage;
- (void)boxMainViewOpenBox:(XCBoxMainView *)boxMainView openCountType:(XCBoxSelectOpenCountType)openCountType sendMessage:(BOOL)sendMessage;

@end

@interface XCBoxMainView : UIView

@property (nonatomic, weak) id<XCBoxMainViewDelegate> delegate;
@property (nonatomic, strong,readonly) YYLabel *buyLabel;// 购买
//@property (nonatomic, strong) YYLabel *boxTips; // boxTips
- (void)updateTimeLeft:(int)timeLeft;//更新 timeleft
- (void)stopCountdown; // 活动结束，停止计时
- (void)updateProgress:(CGFloat)value;// 更新 progress value
- (void)updateProgressWithRanges:(NSArray <NSNumber *> *)ranges; // 更新能量值区间段
- (void)cleanProgressBoxView; // 清除进度条上的 box
- (void)updateLuckyValueExpireDays:(int )days;//更新 LuckyValueExpireDays
- (void)updateKey:(int)count;//更新🔑
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
