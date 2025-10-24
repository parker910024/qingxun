//
//  AppDelegate+TTSDKConfig.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "AppDelegate+TTSDKConfig.h"

#import "XCTheme.h"

#import <AFNetworkReachabilityManager.h>

//bugly
#import <Bugly/Bugly.h>

#import <RPSDK/RPSDK.h>

//baidu
#import <BaiduMobStatCodeless/BaiduMobStat.h>

//IQKeyboard
#import <IQKeyboardManager/IQKeyboardManager.h>

/// 云信依赖
#import "NIMKit.h"
#import "TTSessionCellLayoutConfig.h"
#import "XCCustomAttachmentDecoder.h"
#import "AppDelegate+Config.h"

//core
#import "AuthCore.h"

#import "WMAdImageTool.h"

#import <LinkedME_iOS/LinkedME.h>
// 云盾
#import <RPSDK/RPSDK.h>
#import "XCCurrentVCStackManager.h"

//#import <QYSDK.h>

//易盾注册保护
#import <Guardian/NTESCSGuardian.h>
//数美天网
#import "SmAntiFraud.h"
// 友盟推送
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>

#import <UMCommon/UMCommon.h>

#if DEBUG
//高德地图
static NSString *const kAMLocationSDKApiKey = @"8692a5550010fc7124c4ddff387f8ab1";
#else
static NSString *const kAMLocationSDKApiKey = @"7f6e945d150a32827418a2ba295a396c";
#endif

// 七鱼客服
//static NSString *const kQYSDKApiKey = @"411661bd233f0805626044b6d65fa74a";
static NSString *const kTuTuCommond_Debug = @"TuTuPlay_Dev";
static NSString *const kTuTuCommond_Release = @"TuTuPlay";
// 百度统计
static NSString *const kBaiduMobStatSDKApiKey = @"c5a8a632cf";
// Bugly
static NSString *const kBuglySDKApiKey_Debug = @"f80a6c7ccc";
static NSString *const kBuglySDKApiKey_Release = @"bf08dfb921";

//易盾
static NSString *const kYiDunProduceID = @"YD00865198132682";
//数美
static NSString *const kShuMeiOrganizationID = @"2qjgWI5tyNipa08YPjOt";

//友盟统计
static NSString *const kUMengAppkey = @"5d3ac8123fc195468b000b11";
// 友盟推送
static NSString *const kUMengPushKey = @"";

@implementation AppDelegate (TTSDKConfig)

#pragma mark - public method

#pragma mark -
#pragma mark 需要第一时间注册的 SDK
- (void)initSDKConfigOnTime {
    // need load on time
    [self configNIMKit];    // 云信 SDK
    [self configLinkMe];    // LinkMe
    [self configBugly];     // 崩溃统计
    [self configBaiduAny];  // 百度统计
    [self configUMengSDK];  // 友盟统计
    [self configRegisterProtect]; //注册保护
}
#pragma mark -
#pragma mark 可以稍后注册的 SDK
- (void)initSDKConfigLater {
    // can load later
    [self configPublicChatroom];
    [self configNetworkingMonitor];
    [self configIQKeyboard];        // 键盘管理
    [self configCloudShield];       // 云盾
//    [self registerQYSDK];           // 个人页客服
    [self configAMapLocationSDK];   // 定位
    
    AddCoreClient(AdCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);
}

#pragma mark -
#pragma mark - 注册保护
//注册保护
- (void)configRegisterProtect {
    //易盾注册保护
    [NTESCSGuardian startWithProductNumber:kYiDunProduceID];
    
    //数美天网
    SmOption *option = [[SmOption alloc] init];
    option.organization = kShuMeiOrganizationID;
    option.channel = @"App Store";
    [[SmAntiFraud shareInstance] create:option];
}

#pragma mark 云盾 SDK
/** 云盾 */
- (void)configCloudShield {
//    RPSDK 不再需要初始化操作，请删除此方法调用。
    [RPSDK setup];
}

#pragma mark -
#pragma mark 深度链接 LinkMe
- (void)configLinkMe {
    [LinkedME getInstance];
}

#pragma mark -
#pragma mark 崩溃收集 Bugly
- (void)configBugly {
    
    BuglyConfig *buglyConfig = [[BuglyConfig alloc]init];
    buglyConfig.reportLogLevel = BuglyLogLevelWarn;
    buglyConfig.delegate = self;
#ifdef DEBUG
    [Bugly startWithAppId:kBuglySDKApiKey_Debug config:buglyConfig];
#else
    [Bugly startWithAppId:kBuglySDKApiKey_Release config:buglyConfig];
#endif
    
}

#pragma mark - private method
#pragma mark -
#pragma mark 键盘弹出管理
- (void)configIQKeyboard {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"取消";
}

#pragma mark -
#pragma mark 百度统计
- (void)configBaiduAny {
    //配置百度统计
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    statTracker.enableExceptionLog = NO;
    [statTracker startWithAppId:kBaiduMobStatSDKApiKey]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

#pragma mark -
#pragma mark 网络状态
- (void)configNetworkingMonitor {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark -
#pragma mark 网易云信 SDK
/**
 配置网易云信
 */
- (void)configNIMKit {
    [[NIMKit sharedKit] registerLayoutConfig:[TTSessionCellLayoutConfig new]];
    [NIMCustomObject registerCustomDecoder:[XCCustomAttachmentDecoder new]];
    

    /// 文字背景设置
    [NIMKit sharedKit].config.leftBubbleSettings.textSetting.font = [UIFont systemFontOfSize:14];
    [NIMKit sharedKit].config.leftBubbleSettings.textSetting.textColor = [XCTheme getTTMainTextColor];
    [NIMKit sharedKit].config.leftBubbleSettings.textSetting.normalBackgroundImage = [[UIImage imageNamed:@"message_public_chat_bubble_white"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];


    [NIMKit sharedKit].config.rightBubbleSettings.textSetting.font = [UIFont systemFontOfSize:14];
    [NIMKit sharedKit].config.rightBubbleSettings.textSetting.textColor = UIColor.whiteColor;
    [NIMKit sharedKit].config.rightBubbleSettings.textSetting.normalBackgroundImage = [[UIImage imageNamed:@"message_public_chat_bubble_orange"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];
    
    /// 语音背景设置
    [NIMKit sharedKit].config.leftBubbleSettings.audioSetting.font = [UIFont systemFontOfSize:14];
    [NIMKit sharedKit].config.leftBubbleSettings.audioSetting.textColor = [XCTheme getTTMainTextColor];
    [NIMKit sharedKit].config.leftBubbleSettings.audioSetting.normalBackgroundImage = [[UIImage imageNamed:@"message_public_chat_bubble_white"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];
    
    [NIMKit sharedKit].config.rightBubbleSettings.audioSetting.font = [UIFont systemFontOfSize:14];
    [NIMKit sharedKit].config.rightBubbleSettings.audioSetting.textColor = UIColor.whiteColor;
    [NIMKit sharedKit].config.rightBubbleSettings.audioSetting.normalBackgroundImage = [[UIImage imageNamed:@"message_public_chat_bubble_orange"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];
 
   
    
    /// 无法识别的消息的背景设置
    [NIMKit sharedKit].config.leftBubbleSettings.unsupportSetting.normalBackgroundImage = [[UIImage imageNamed:@"message_public_chat_bubble_white"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];
    
    [NIMKit sharedKit].config.rightBubbleSettings.unsupportSetting.normalBackgroundImage = [[UIImage imageNamed:@"message_public_chat_bubble_orange"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];
    
    
}

#pragma mark - AddCoreClient(AppInitClient, self);
- (void)onGetAdSuucess {
    static dispatch_once_t disOnce;
    
    dispatch_once(&disOnce,^ {
        [WMAdImageTool getAdvertisingImage];
    });
}

#pragma mark - BuglyDelegate

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    return [GetCore(AuthCore)getUid];
}

#pragma mark - 注册网易七鱼
//- (void)registerQYSDK {
//#if DEBUG
//    [[QYSDK sharedSDK] registerAppId:kQYSDKApiKey appName:kTuTuCommond_Debug];
//#else
//    [[QYSDK sharedSDK] registerAppId:kQYSDKApiKey appName:kTuTuCommond_Release];
//#endif
//
//}

#pragma mark - 高德地图
- (void)configAMapLocationSDK {
    [AMapServices sharedServices].apiKey = kAMLocationSDKApiKey;
}

#pragma mark - 友盟SDK
- (void)configUMengSDK {
    [UMConfigure initWithAppkey:kUMengAppkey channel:@"App Store"];
}

#pragma mark -
#pragma mark 友盟推送
- (void)configUmengPushSDK {
//    [UMConfigure initWithAppkey:kUMengPushKey channel:@"App Store"];
//    [UMConfigure setLogEnabled:YES];
}
@end
