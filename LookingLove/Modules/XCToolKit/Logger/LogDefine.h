//
//  LogDefine.h
//  YYMobileFramework
//
//  Created by leo on 15-3-23.
//  Copyright (c) 2015年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYLogger.h"

@interface LogDefine : NSObject

@end

/*
//Log使用例子，以下几个均为合法Log
[YYLogger info:TGift message:...];
LogInfo(TGift,...);
LoginfoGift(...);
[YYLogger info:TAG(TGift,TNavigate) message:...];
 
//日志规范说明
1、使用Log必须要使用Tag，公用Tag定义在LogDefine.h中
2、Tag可以多个拼接使用，如TAG(TChannel,TNavigate)即为@"Channel|Navigate"；功能独立也可以拼接上自己的Tag，如TAG(TChannel,@"MyTag")
3、如果新功能Log较多，且Tag不适用已有Tag，可以讨论增加Tag
4、关于TNavigate、TNetSend等公用Tag，请尽量拼接使用，拼接上对应的模块Tag
5、增加了开发中使用Log，关键字LogInfoDev，在内部测试版会打Log，但对外发布不会在用户端打Log，由于Log较多，一些重复性较高的Log应该使用LogInfoDev或者LogVerbose
 
 公用Tag说明：
 1、	TNavigate为用户点击跳转和切换Activity是需要使用，如JoinChannel；是一个重要的共用Tag，可以判断用户行为，跳转是务必添加
 2、	TDataReport是数据上报相关，快速筛选数据上报
 3、	TNetSend和TNetReceive是网络收发包相关，请在网络请求和响应时加上。
*/

//Log相关的Tag分类
//Tag分类说明，以下每几行为一组Tag，TChannel、TIM...TBase为大类Tag，TGift为TChannel的子Tag

static NSString * const TAPNs           = @"APNs";          //APNs
static NSString * const TLocalNotify    = @"LocalNotify";    //本地通知
static NSString * const TLive           = @"Live";          //信令
static NSString * const TRoom           = @"Room";          //房间
static NSString * const TPushMessage    = @"PushMessage";   //Push协议
static NSString * const TProtoMsg       = @"ProtoMsg";      //协议层
static NSString * const TImLogin        = @"ImLogin";       //Im登录
static NSString * const TImFriend       = @"ImFriend";      //Im好友
static NSString * const TImMessage      = @"ImMessage";     //Im消息
static NSString * const TYCSDK          = @"YCSDK";         //云SDK
static NSString * const TCIMSDK         = @"CIMSDK";        //IM SDK
static NSString * const TRealm          = @"Realm";         //Realm相关
static NSString * const TWCDB          = @"WCDB";         //WCDB相关
static NSString * const TTinyVideo      = @"TinyVideo";     //短视频相关
static NSString * const TVODSDK         = @"VODSDK";        //点播系统
static NSString * const THiidoSDK       = @"HiidoSDK";      //海度统计
static NSString * const TYYFaceAuth     = @"YYFaceAuth";    //YYFaceAuth模块


static NSString* const TChannel     = @"Channel";
static NSString* const TSubChannel  = @"SubChannel";    //子频道
static NSString* const TGift        = @"Gift";          //礼物
static NSString* const TWhisper     = @"Whisper";
static NSString* const TVote        = @"Vote";          //投票
static NSString* const TArtistName  = @"ArtistName";    //主播艺名
static NSString* const TChanelChatList      = @"ChanelChatList";
static NSString* const TCheckIn      = @"CheckIn";      //打卡功能
static NSString* const TFreeMode     = @"FreeMode";      //打卡功能

static NSString* const TIM          = @"IM";
static NSString* const TConversation    = @"Conversation";  //IM和群消息相关
static NSString* const TAddFriend   = @"AddFriend";     //添加好友
static NSString* const TAddGroup    = @"AddGroup";      //添加群
static NSString* const TFriendInfo  = @"FriendInfo";    //好友信息
static NSString* const TGroupInfo   = @"GroupInfo";     //群信息
static NSString* const TFriendList  = @"FriendList";    //好友列表
static NSString* const TGroupList   = @"GroupList";     //群列表

static NSString* const TShenqu      = @"Shenqu";
static NSString* const TSQDownload  = @"SQDownload";    //神曲下载相关
static NSString* const TSQFollow    = @"SQFollow";
static NSString* const TSQBoardsList    = @"SQBoardsList";

static NSString* const TTinyVideoMainPage   = @"TinyVideoMainPage";    //短视频主页
static NSString* const TTinyVideoDetailView   = @"TinyVideoDetailView";    //短视频播放页
static NSString* const TTinyVideoAttentionView   = @"TinyVideoAttentionView";    //短视频关注页
static NSString* const TTinyVideoAudienceView   = @"TinyVideoAudienceView";    //短视频点赞页
static NSString* const TTinyVideoCache   = @"TinyVideoCache";    //短视频缓存
static NSString* const TTinyVideoSynthesis   = @"TinyVideoSynthesis";    //短视频合成

static NSString* const TAuth        = @"Auth";          //认证相关
static NSString* const TLogin       = @"Login";         //登录
static NSString* const TRegister    = @"Register";      //注册

static NSString* const TPersonal    = @"Personal";      //个人页面
static NSString* const TTaskCenter  = @"TaskCenter";    //任务中心
static NSString* const TMessageCenter   = @"MessageCenter"; //消息中心
static NSString* const TFavorite    = @"Favorite";      //个人的Favarite页面
static NSString* const TFollowee    = @"Followee";      //个人的Followee页面

static NSString* const TBase        = @"Base";          //公用的基础控件, 如果控件较大可以独立使用一个Tag，如下几个
static NSString* const TCategories  = @"Categories";    //基础控件Categories相关
static NSString* const TLiveNotification    = @"LiveNotification";
static NSString* const TControlers  = @"Controlers";        //公用的基础Controler控件
static NSString* const TJSON        = @"JSON";          //基础JSON相关
static NSString* const THTTP        = @"HTTP";          //基础HTTP下载控件

//以上的Tag为分组Tag，以下Tag为独立Tag（具体见文件头的说明）
static NSString* const TLiveCenter  = @"LiveCenter";    //直播首页
static NSString* const TSearch      = @"Search";        //查找页面
static NSString* const TIMShare     = @"IMShare";
static NSString* const TDiscover    = @"Discover";      //发现页面
static NSString* const TLab         = @"Lab";           //实验室
static NSString* const TStore       = @"Store";         //App Store和xcz相关
static NSString* const TAnchor      = @"Anchor";
static NSString* const TSettings    = @"Settings";      //设置
static NSString* const TMagicRing   = @"MagicRing";
static NSString* const TApp         = @"ErbanApp";           //Appdelegate等
static NSString* const TAVPlayer    = @"AVPlayer";
static NSString* const TShare       = @"Share";         //第三方分享
static NSString* const TDatabase    = @"Database";      //数据库相关
static NSString* const TWebApp      = @"WebApp";        //WebApp相关
static NSString* const TLogUpload   = @"LogUpload";     //日志上传相关，包括Crash Log和反馈系统
static NSString* const TSDK         = @"SDK";           //和SDK交互相关，如sdk调用返回错误等
static NSString* const TMedia       = @"Media";         //流媒体相关
static NSString* const TGameVoice   = @"GameVoice";     //手游语音相关
static NSString* const TLeague      = @"League";        //手游语音公会
static NSString* const TReachability   = @"Reachability";  //网络情况相关

//以下Tag为行为类Tag，和上面的Tag可以同时使用，如@"Gift|Action"，即为TAG(TGift,TAction)
static NSString* const TNavigate    = @"Navigate";    //跳转
static NSString* const TDataReport  = @"DataReport";    //数据上报
static NSString* const TNetSend     = @"NetSend";       //网络请求
static NSString* const TNetReceive  = @"NetReceive";    //网络返回

//拼接多个Log Tag
#define TAG(tag1,tag2) ([[tag1 stringByAppendingString:@"|"]stringByAppendingString:tag2])

//以下为方便使用，把常用几个tag设为函数
#define LogInfoChannel(format, arg...) [YYLogger info:TChannel message:format, ##arg]
#define LogInfoGift(format, arg...) [YYLogger info:TGift message:format, ##arg]
#define LogInfoIM(format, arg...) [YYLogger info:TIM message:format, ##arg]
#define LogInfoShenqu(format, arg...) [YYLogger info:TShenqu message:format, ##arg]
#define LogInfoBase(format, arg...) [YYLogger info:TBase message:format, ##arg]
#define LogInfoStore(format, arg...) [YYLogger info:TStore message:format, ##arg]
#define LogInfoSettings(format, arg...) [YYLogger info:TSettings message:format, ##arg]
#define LogInfoDatabase(format, arg...) [YYLogger info:TDatabase message:format, ##arg]

#define LogInfoNavigate(format, arg...) [YYLogger info:TNavigate message:format, ##arg]
#define LogInfoDataReport(format, arg...) [YYLogger info:TDataReport message:format, ##arg]
