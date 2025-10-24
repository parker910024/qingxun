
//
//  XCWKWebViewController.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BaseUIViewController.h"
#import "UserID.h"
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    /** 跳转H5界面 */
    WebViewRightNavigationItemTypePushWebPage = 1,
    /** 显示原生分享界面 */
    WebViewRightNavigationItemTypeShare = 2,
    /** h5 跳转 App 原生页面 */
    WebViewRightNavigationItemH5PushAppPage = 3,
    /** 分享图片 */
    WebViewRightNavigationItemTypeSharePicture = 5,
} WebViewRightNavigationItemType;


/**
 H5 通知客户端的 JS，一般用于一些操作成功后，告知客户端进行刷新数据，或者一些操作

 - WebViewNotifyAppActionStatusTypeRecommedRefresh: 推荐卡使用成功，刷新仓库
 */
typedef NS_ENUM(NSUInteger, WebViewNotifyAppActionStatusType) {
    /** 推荐卡使用成功，刷新仓库 */
    WebViewNotifyAppActionStatusTypeRecommedRefresh = 1,
};

@interface XCWKWebViewController : BaseUIViewController

/// URL加载完成回调，result:加载结果成功/失败，error:失败原因
@property (nonatomic, copy) void (^urlLoadCompletedHandler)(BOOL result, NSError *error);

@property (strong, nonatomic) UIProgressView *progressView;

/**
 自动拼接全路径 urlString url 二选一
 */
@property (copy, nonatomic) NSString *urlString;
/**
 传入NSURl 全路径 urlString url 二选一
 */
@property (strong, nonatomic) NSURL *url;

@property (nonatomic, copy) NSString *callBackJS;
@property (strong, nonatomic) WKWebView *webview;
@property (nonatomic, strong) WKUserContentController *userContentController;

@property (nonatomic, copy) NSString *jumpLink;

@property (nonatomic, assign) BOOL webViewHadReload;
/**
 xcRedColor分享  RedShareInfo 类
 */
@property (nonatomic, strong) NSDictionary *redShareDict;


/**
 禁用显示刷新，如果需要viewwillapprear的时候不刷新界面，例如上一级是webview，并且poptoview的时候需要加载另外一个界面，这样子就需要提前设置这个值，但是这个值只会生效一次
 */
@property (nonatomic, assign) BOOL banRefresh;
/**
 对应的用户id
 */
@property (nonatomic, assign) UserID  uid;


- (void)setCustomUserAgentWith:(NSString *)userAgent;

//根据shareInfo的response来判断是否显示share
- (void)initNav:(NSDictionary *)response;

/**
 子类实现 拦截父类  需要调用父类
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

/**
 返回按钮
 */
- (void)backButtonClick;


// ****************h5与原生的交互, 子类根据需要, 覆盖此方法, 覆盖时最好调用父类方法********************
// h5跳钱包页面
- (void)h5OpenPurseAction:(WKScriptMessage *)message;

// h5跳充值页
- (void)h5OpenChargePageAction:(WKScriptMessage *)message;

// h5跳去个人页
- (void)h5OpenPersonPageAction:(long long)uid message:(WKScriptMessage *)message;

// h5打开分享面板
- (void)h5OpenSharePageAction:(WKScriptMessage *)message;

// h5跳房间
- (void)h5OpenRoomAction:(long long)uid message:(WKScriptMessage *)message;

// h5跳贵族订单列表
- (void)h5OrderNobleAction:(WKScriptMessage *)message;

// h5开始录制音频
- (void)h5StartRecodeAction:(WKScriptMessage *)message;

// h5停止录制音频
- (void)h5StopRecodeAction:(WKScriptMessage *)message;

// h5跳私信页面
- (void)h5ContactSomeOneAction:(long long)uid message:(WKScriptMessage *)message;

// h5跳开家族页面
- (void)h5OpenFamilyPageAction:(long long)familyId message:(WKScriptMessage *)message;

// h5跳openDecorateMallPage装扮商城 index:1.头饰  2 座驾 3背景
- (void)h5OpenDecorateMallPageAction:(NSInteger)index message:(WKScriptMessage *)message;

// 根据h5设置导航栏
- (void)h5InitNav:(WKScriptMessage *)message;

// 根据h5跳绑定xcz, type: 0编辑状态：已绑定，进行编辑 1普通状态：第一次绑定
- (void)h5JumpXCZAction:(NSInteger)type message:(WKScriptMessage *)message;

// 根据h5跳绑定手机号
- (void)h5JumpBindingPhoneNumAction:(WKScriptMessage *)message;

// 根据h5跳设置支付密码
- (void)h5JumpSettingPayPwdAction:(WKScriptMessage *)message;

// 根据h5跳公聊大厅
- (void)h5JumpPublicChatAction:(WKScriptMessage *)message;

// 根据h5跳系统消息
- (void)h5JumpSystemMessageAction:(WKScriptMessage *)message;

// 根据h5跳群组聊天
- (void)h5JumpGroupAction:(long long)uid message:(WKScriptMessage *)message;

// 根据h5跳Red页
- (void)h5JumpRedColorAction:(WKScriptMessage *)message;

// 根据h5跳BillList页
- (void)h5JumpBillListAction:(WKScriptMessage *)message;

// 根据h5跳Invite_Friend页
- (void)h5JumpInvite_FriendAction:(WKScriptMessage *)message;

// 根据h5跳新秀玩友页
- (void)h5JumpNewFriendAction:(WKScriptMessage *)message;

//  根据h5返回 CP房游戏结束信息
- (void)h5ReturnGameShows:(WKScriptMessage *)message;

//  游戏开始时。回调游戏Start
- (void)gameStarth5ReturnGameShows:(WKScriptMessage *)message;

//  游戏异常结束时，回调 异常处理
- (void)gameAbnormalOverReturnGameShows:(WKScriptMessage *)message;

// 游戏开始之后，是否显示切换观战按钮
- (void)gameStartAndWhetherShowWatchBtn:(WKScriptMessage *)message;

// H5调起原生实人认证: 打开原生人脸认证
- (void)h5OpenFaceLivenessAction:(WKScriptMessage *)message;

//  跳转draw
- (void)h5JumpWithDrawAction:(WKScriptMessage *)message;

//跳转到话题详情页
- (void)h5JumpWithOpenTopicDetailAction:(WKScriptMessage *)message;

// 跳转推荐卡仓库
- (void)H5JumpRecommendCardAction:(WKScriptMessage *)message;

//实人认证 后台认证成功 vkiss使用
- (void)H5JumpFaceCertificationSuccessAction:(WKScriptMessage *)message;

/** 跳转师徒的主页*/
- (void)h5JumpMentoringShipAction:(WKScriptMessage *)message;
/** H5 告知客户端事件操作状态（进行刷新，回调，返回等操作) */
- (void)H5NotifyAppActionStatus:(WKScriptMessage *)message;

//
- (void)H5NotifyUserAccpetChallenge:(WKScriptMessage *)message;

//跳转小世界客态页
- (void)h5JumpLittleWorldHomePageAction:(WKScriptMessage *)message;

/// 请求关闭webView
- (void)h5CloseDialogWebViewAction:(WKScriptMessage *)message;

/// 跳转意见反馈页面
- (void)H5JumpFeedBackPageAction:(WKScriptMessage *)message;
@end
