//
//  LogTag.h
//  XChatFramework
//
//  Created by 卫明何 on 2018/3/15.
//  Copyright © 2018年 chenran. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCLogLevelVerbose = 1,
    XCLogLevelDebug = 2,
    XCLogLevelInfo = 3,
    XCLogLevelWarn = 4,
    XCLogLevelError = 5
} XCLogLevel;

@interface LogTag : NSObject

@end
#define EVENT_ID @"event_id"

#define SystemLog @"SystemLog"
static NSString * const CAPNS                = @"APNS"; //APNS
static NSString * const CLinkME              = @"LinkMe";//LinkMe
static NSString * const CMemoryWarning       = @"MemoryWarning"; //内存警告
static NSString * const CNullCrash          = @"NullCrash";//空指针崩溃

#define IMLog @"IMLog"
static NSString * const CImLogin            = @"ImLogin"; //IM登录
static NSString * const CImMessage          = @"ImMessage"; //IM消息(当前只记录礼物与表情的自定义消息发送与接收)
static NSString * const CImChannel          = @"ImChannel"; //IM聊天室
static NSString * const CImKick             = @"ImKick"; //聊天室踢人
static NSString * const CImKicked             = @"ImKick"; //聊天室被踢

#define AudioLog @"AudioLog"
static NSString * const CAudioLog           = @"AudioSDK"; //音频SDK问题（声网）
static NSString * const CAudioChannel       = @"AudioChannel"; //音频频道（声网）

#define SocializationLog @"SocializationLog"
static NSString * const CShareLog   = @"Share"; //分享

#define OtherSDKLog @"OtherSDKLog"
static NSString * const CRealm              = @"Realm"; //Realm数据库
static NSString * const CWCDB               = @"WCDB"; //WCDB

#define BussinessLog @"BussinessLog"
static NSString * const CGift_P2P           = @"Gift_P2P"; //单聊送礼物
static NSString * const CGift_channel       = @"Gift_channel"; //聊天室送礼物
static NSString * const CPurse              = @"Purse";//钱包
static NSString * const CNoble              = @"Noble";//贵族
static NSString * const CRegister           = @"Register"; //注册
static NSString * const CLogin              = @"Login";//登录
static NSString * const CVerifyCode         = @"VerifyCode"; //验证码
static NSString * const CFillUserData       = @"FillUserData"; //补全资料

static NSString * const Monster_willAppear      = @"Monster_willAppear"; //怪兽将出现
static NSString * const Monster_gameResult      = @"Monster_gameResult"; //怪兽结果
static NSString * const Monster_onGoingMonster  = @"Monster_onGoingMonster"; //正在攻击中的怪兽信息
static NSString * const SVGA_LoadState          = @"SVGA_LoadState"; //SVGA加载状态
static NSString * const User_get                = @"User_get"; //用户信息获取失败
static NSString * const Room_get                = @"Room_get"; //房间信息获取失败
