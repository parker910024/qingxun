//
//  ClientCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "RoomInfo.h"

//0：不提示，1：强制，2：强引导
typedef enum : NSUInteger {
    FaceLivenessStrategy_Pass = 0,
    FaceLivenessStrategy_Force = 1,
    FaceLivenessStrategy_Guide = 2,
} FaceLivenessStrategy;

/** 青少年弹窗 1：强引导，2：弱引导 */
typedef NS_ENUM(NSUInteger, TeenagerModelAlertType) {
    TeenagerAlertTypeUnDefine = 0, // 未获取到配置的情况，默认强引导
    TeenagerAlertTypeHigh = 1, // 强引导
    TeenagerAlertTypeNormal = 2, // 弱引导
};

@interface ClientCore : BaseCore

@property (nonatomic, assign) BOOL needOpenRoom;
@property (nonatomic, assign) RoomType foreTouchOpenRoomType;
//实人认证策略 0：不提示，1：强制，2：强引导
@property (nonatomic, assign) int certificationType;
@property (nonatomic, assign) FaceLivenessStrategy strategy;
@property (nonatomic, copy) NSString * wechatPublic;
/** 注册图片验证码开关 true 开启，false 关闭 */
@property (nonatomic, assign) BOOL captchaSwitch;
//im消息上报开个
@property (nonatomic, assign) BOOL reportSwitch;
//update地址
@property (nonatomic, copy) NSString *updateUrl;

/** 青少年弹窗 1：强引导，2：弱引导 */
@property (nonatomic, assign) TeenagerModelAlertType teenagerMode; // 青少年模式弹窗效果

//客服第三方类型   1.七鱼  2.live800
@property (nonatomic, assign) int customerType;

#pragma mark - AppLifeCycle

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationDidEnterBackground:(UIApplication *)application;

/**
 上传用户地理位置接口
 
 @param address 地址信息
 @param adcode 城市编码
 @param longitude 经度
 @param latitude 纬度
 */
- (void)uploadUserLocationAddress:(NSString *)address
                           adcode:(NSString *)adcode
                        longitude:(double)longitude
                         latitude:(double)latitude;

// 请求客服配置
- (void)requestCustomerConfig:(void (^)(NSDictionary *dict, NSNumber *errCode, NSString *msg))completion;

- (void)requestYDConfig:(void (^)(NSNumber *dict, NSNumber *errCode, NSString *msg))completion;
@end
