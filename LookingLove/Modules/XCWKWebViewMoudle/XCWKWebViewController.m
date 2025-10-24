//
//  XCWKWebViewController.m
//  XChat
//
//  Created by gzlx on 2017/7/18.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCWKWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LTVibrationTool.h"


#import "TYAlertController.h"
#import "Masonry.h"
#import "XCHtmlUrl.h"
#import "YYUtility.h"
#import "UIView+XCToast.h"
//#import "XCTheme.h"
#import "TTWeakScriptMessageDelegate.h"
//#import "NSArray+JSON.h"
#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "VersionCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "ImRoomCoreV2.h"
#import "ShareCoreClient.h"
#import "HostUrlManager.h"

#import "DESEncrypt.h"
#import "AFHTTPSessionManager+Config.h"
#import "P2PInteractiveAttachment.h"
#import "NSDictionary+JSON.h"
#import "NSString+JsonToDic.h"
#import <BaiduMobStatCodeless/BaiduMobStat.h>
#import "TTStatisticsService.h"
#import "ChatRoomMicSequence.h"
#import "NSArray+JSON.h"


@interface XCWKWebViewController ()<
WKNavigationDelegate,
WKScriptMessageHandler,
ShareCoreClient
>

@end

@implementation XCWKWebViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//
//    if ([[self.webview.URL absoluteString] containsString:HtmlUrlKey(kTurntableURL)]) {
//        if (!self.banRefresh) {
//            NSString *js = [NSString stringWithFormat:@"refreshWeb()"];
//            [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
//                NSLog(@"%@",error);
//            }];
//        }
//        self.banRefresh = NO;
//    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
    AddCoreClient(ShareCoreClient, self);
    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (projectType() != ProjectType_VKiss) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.view addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
    
- (void)setCustomUserAgentWith:(NSString *)agent{
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *userAgent = result;
        if (![userAgent containsString:agent]){
            NSString *newUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@" %@", agent]];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.webview setCustomUserAgent:newUserAgent];
        }
    }];
}
    

- (void)initWebView {
    if (self.navigationController.viewControllers.count>1){
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_bar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
        
        leftBarButtonItem.tintColor = (projectType() == ProjectType_VKiss) ? [UIColor colorWithRed:164.0/255.0 green:158.0/255.0 blue:254.0/255.0 alpha:1] : [UIColor blackColor];
      
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    if (@available(iOS 11.0, *)) {
        self.webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.webview];
//    self.webview.frame = self.view.bounds;
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}



- (void)setUrl:(NSURL *)url{
    _url = url;
    if (_url == nil) {
        return;
    }
    NSString *urlString = [url absoluteString];
    if (![urlString containsString:@"?"]) {
        urlString = [NSString stringWithFormat:@"%@?platform=%@",urlString,[YYUtility appName]];
    } else {
        urlString = [NSString stringWithFormat:@"%@&platform=%@",urlString,[YYUtility appName]];
    }
    NSURL *newUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl];
    [self.webview loadRequest:request];
}
    
- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    if (_urlString == nil) {
        return;
    }
    if (![_urlString hasPrefix:@"http"]&&![_urlString hasPrefix:@"https"]){
        _urlString = [NSString stringWithFormat:@"%@/%@",(projectType() == ProjectType_VKiss)? [HostUrlManager shareInstance].hostH5Url : [HostUrlManager shareInstance].hostUrl,_urlString];
    }
    
    if (![_urlString containsString:@"?"]) {
        _urlString = [NSString stringWithFormat:@"%@?platform=%@",_urlString,[YYUtility appName]];
    } else {
        _urlString = [NSString stringWithFormat:@"%@&platform=%@",_urlString,[YYUtility appName]];
    }
    
    // 去掉 urlString 中的空格。
    NSString *noSpaceTextUrl = [_urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:noSpaceTextUrl]];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods
// h5跳钱包页面
- (void)h5OpenPurseAction:(WKScriptMessage *)message {
    
}

// h5跳充值页
- (void)h5OpenChargePageAction:(WKScriptMessage *)message {
    
}

// h5跳去个人页
- (void)h5OpenPersonPageAction:(long long)uid message:(WKScriptMessage *)message {
    
}

// h5打开分享面板
- (void)h5OpenSharePageAction:(WKScriptMessage *)message {
    
}

// h5跳房间
- (void)h5OpenRoomAction:(long long)uid message:(WKScriptMessage *)message {
    
}

// h5跳贵族订单列表
- (void)h5OrderNobleAction:(WKScriptMessage *)message {
    
}

// h5开始录制音频
- (void)h5StartRecodeAction:(WKScriptMessage *)message {
    
}

// h5停止录制音频
- (void)h5StopRecodeAction:(WKScriptMessage *)message {
    
}

// h5跳私信页面
- (void)h5ContactSomeOneAction:(long long)uid message:(WKScriptMessage *)message {
    
}

// h5跳开家族页面
- (void)h5OpenFamilyPageAction:(long long)familyId message:(WKScriptMessage *)message {
    
}

// h5跳openDecorateMallPage装扮商城 index:1.头饰  2 座驾 3背景
- (void)h5OpenDecorateMallPageAction:(NSInteger)index message:(WKScriptMessage *)message {
    
}

// 根据h5设置导航栏
- (void)h5InitNav:(WKScriptMessage *)message {
    
}

// 根据h5跳绑定xcz, type: 0编辑状态：已绑定，进行编辑 1普通状态：第一次绑定
- (void)h5JumpXCZAction:(NSInteger)type message:(WKScriptMessage *)message {
    
}

// 根据h5跳绑定手机号
- (void)h5JumpBindingPhoneNumAction:(WKScriptMessage *)message {
    
}

// 根据h5跳设置支付密码
- (void)h5JumpSettingPayPwdAction:(WKScriptMessage *)message {
    
}

// 根据h5跳公聊大厅
- (void)h5JumpPublicChatAction:(WKScriptMessage *)message {
    
}

// 根据h5跳系统消息
- (void)h5JumpSystemMessageAction:(WKScriptMessage *)message {
    
}

// 根据h5跳群组聊天
- (void)h5JumpGroupAction:(long long)uid message:(WKScriptMessage *)message {
    
}

// 根据h5跳Red页
- (void)h5JumpRedColorAction:(WKScriptMessage *)message {
    
}

// 根据h5跳BillList页
- (void)h5JumpBillListAction:(WKScriptMessage *)message {
    
}

// 根据h5跳Invite_Friend页
- (void)h5JumpInvite_FriendAction:(WKScriptMessage *)message {
    
}

// 根据h5跳新秀玩友页
- (void)h5JumpNewFriendAction:(WKScriptMessage *)message {
    
}
/** 跳转师徒*/
- (void)h5JumpMentoringShipAction:(WKScriptMessage *)message{
    
}

//  根据h5返回 CP房游戏结束信息
-(void)h5ReturnGameShows:(WKScriptMessage *)message{
    
}

//  游戏开始时。回调游戏Start
-(void)gameStarth5ReturnGameShows:(WKScriptMessage *)message{
    
}

//  游戏异常结束时，回调 异常处理
- (void)gameAbnormalOverReturnGameShows:(WKScriptMessage *)message{
    
}

// 游戏开始之后，是否显示切换观战按钮
- (void)gameStartAndWhetherShowWatchBtn:(WKScriptMessage *)message{
    
}

//  跳转draw
- (void)h5JumpWithDrawAction:(WKScriptMessage *)message{
    
}

//跳转到话题详情页
- (void)h5JumpWithOpenTopicDetailAction:(WKScriptMessage *)message{
    
}
// 跳转到推荐卡仓库
- (void)H5JumpRecommendCardAction:(WKScriptMessage *)message {
    
}


//实人认证 后台认证成功 vkiss使用
- (void)H5JumpFaceCertificationSuccessAction:(WKScriptMessage *)message {

}

- (void)H5NotifyAppActionStatus:(WKScriptMessage *)message {
    
}

- (void)H5NotifyUserAccpetChallenge:(WKScriptMessage *)message{

    
}

//跳转小世界客态页
- (void)h5JumpLittleWorldHomePageAction:(WKScriptMessage *)message {
}

/// 请求关闭webView
- (void)h5CloseDialogWebViewAction:(WKScriptMessage *)message {
    
}

- (void)H5JumpFeedBackPageAction:(WKScriptMessage *)message {
    
}

// h5通知客户端刷新用户信息
- (void)h5NotifyUserUpdateUserDataAction:(WKScriptMessage *)message {
    [[GetCore(UserCore) getUserInfoByUid:GetCore(AuthCore).getUid.userIDValue refresh:YES] subscribeNext:^(id  _Nullable x) {
        UserInfo *info = (UserInfo *)x;
        [GetCore(UserCore) cacheUserInfo:info complete:^{
        }];
    }];
}

#pragma mark - ShareCoreClient
- (void)postShareSuccessNetworkSuccessDataShareType:(NSInteger)shareType sharePageId:(SharePageId)sharePageId targetUid:(NSInteger)targetUid {
    if ([[self.webview.URL absoluteString] containsString:HtmlUrlKey(kTurntableURL)]) {
        NSString *js = [NSString stringWithFormat:@"refreshWeb()"];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - WKWebViewDelegate

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"开始加载网页");
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

//捕抓打电话事件
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        decisionHandler(WKNavigationActionPolicyCancel);

        return;
    }
   

    //如果是 兑吧 页面 就不能操作cookie
    if (![URL.absoluteString containsString:@"duiba.com.cn"] && ![URL.absoluteString containsString:@"care60.live800.com"]) {
        //你所保存的cookie

        if(self.uid == 0) {
            self.uid = [GetCore(AuthCore)getUid].longLongValue;
        }

        NSString *realCookie = [NSString stringWithFormat:@"%@=%lld",@"uid",self.uid];

        // 如果请求头部不包含cookie值则需要我们去传cookie
        if ([navigationAction.request allHTTPHeaderFields][@"Cookie"] && [[navigationAction.request allHTTPHeaderFields][@"Cookie"] rangeOfString:realCookie].length > 0) {
            
            decisionHandler(WKNavigationActionPolicyAllow);
            
        } else {
            if (![URL.absoluteString containsString:@"about:blank"]) {
                NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:navigationAction.request.URL];
                [request setValue:realCookie forHTTPHeaderField:@"Cookie"];
                [webView loadRequest:request];
            }
            
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}



//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    
    if (self.urlLoadCompletedHandler) {
        self.urlLoadCompletedHandler(YES, nil);
    }
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    [UIView showToastInKeyWindow:@"网络加载失败，请稍后重试" duration:2.0];
    
    if (self.urlLoadCompletedHandler) {
        self.urlLoadCompletedHandler(NO, error);
    }
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}


#pragma mark - WKScriptMessageHandler
//子类实现 需要调用父类
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"initShowNav"]) {
        if ([message.body boolValue]) {
            [self.navigationController setNavigationBarHidden:NO];
        } else {
            [self.navigationController setNavigationBarHidden:YES];
        }
    } else if ([message.name isEqualToString:@"initNav"]) {
        NSDictionary *response = message.body;
        [self initNav:response];
        [self h5InitNav:message];
    }else if ([message.name isEqualToString:@"getDeviceId"]){//获取设备id
        NSString *js = [NSString stringWithFormat:@"getMessage(\"deviceId\",\"%@\")",[YYUtility deviceUniqueIdentification]];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
        
    }else if ([message.name isEqualToString:@"getRoomUid"]) { //获取getRoomUid
        NSString *roomUid = [NSString stringWithFormat:@"%lld",GetCore(ImRoomCoreV2).currentRoomInfo.uid];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"roomUid\",\"%@\")",roomUid];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else if ([message.name isEqualToString:@"getUid"]){//获取uid
        NSString *uid = [GetCore(AuthCore)getUid];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"uid\",%@)",uid];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else if ([message.name isEqualToString:@"getTicket"]) { //获取ticket
        NSString *ticket = [GetCore(AuthCore)getTicket];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"ticket\",\"%@\")",ticket];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else if ([message.name isEqualToString:@"clipboardToPhone"]) {
        NSString *clipboardToPhone = [NSString stringWithFormat:@"%@",message.body];
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = clipboardToPhone;
        NSString *js = [NSString stringWithFormat:@"showCopySuccess()"];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else if ([message.name isEqualToString:@"loadingStatus"]) {
        BOOL loadingStatus = GetCore(VersionCore).loadingData;
        NSString *js = [NSString stringWithFormat:@"getMessage(\"loadingStatus\",\"%d\")",loadingStatus];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else if ([message.name isEqualToString:@"getAppVersion"]) { //获取getAppVersion
        NSString *appVersion = [YYUtility appVersion];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"appVersion\",\"%@\")",appVersion];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else if ([message.name isEqualToString:@"getChannel"]) { //获取app渠道
        NSString *channel = [YYUtility getAppSource];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"channel\",\"%@\")",channel];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    } else if ([message.name isEqualToString:@"openPurse"]) { // 跳钱包页面
        [self h5OpenPurseAction:message];
    } else if ([message.name isEqualToString:@"openChargePage"]) { // 跳充值页
        [self h5OpenChargePageAction:message];
    } else if ([message.name isEqualToString:@"openPersonPage"]) { //排行榜去个人页
        NSString *uid = [NSString stringWithFormat:@"%@",message.body];
        if (uid.length > 0) {
            [self h5OpenPersonPageAction:uid.userIDValue message:message];
        }
    } else if ([message.name isEqualToString:@"openSharePage"]){ //弹出分享界面
        [self h5OpenSharePageAction:message];
    } else if ([message.name isEqualToString:@"openRoom"]) {
        NSString *uid = [NSString stringWithFormat:@"%@",message.body];
        if (uid.length > 0) {
            [self h5OpenRoomAction:uid.userIDValue message:message];
        }
    } else if ([message.name isEqualToString:@"getPosition"]){ //ranking
        // ?? 现在还用吗?
        NSString *js = self.callBackJS;
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    } else if ([message.name isEqualToString:@"orderNoble"]) { // 贵族订单
        [self h5OrderNobleAction:message];
    } else if ([message.name isEqualToString:@"startRecode"]) {
        //开始录音
        [self h5StartRecodeAction:message];
    } else if ([message.name isEqualToString:@"stopRecode"]) {
        //停止录音
        [self h5StopRecodeAction:message];
    } else if ([message.name isEqualToString:@"contactSomeOne"]) { // 私聊
        NSString *uid = [NSString stringWithFormat:@"%@",message.body];
        if (uid.length > 0) {
            [self h5ContactSomeOneAction:uid.userIDValue message:message];
        }
    } else if ([message.name isEqualToString:@"openFamilyPage"]) {
        NSString *familyId = [NSString stringWithFormat:@"%@",message.body];
        if (familyId.length > 0) {
            [self h5OpenFamilyPageAction:[familyId longLongValue] message:message];
        }
    } else if ([message.name isEqualToString:@"openDecorateMallPage"]) { // 装扮商城
        NSInteger type = [message.body integerValue];
        [self h5OpenDecorateMallPageAction:type message:message];
    }else if ([message.name isEqualToString:@"encryptPwd"]) {
        NSString *pwd = (NSString *)message.body;
        if (pwd.length > 0) {
            NSString *encodePwd = [self encodePwd:pwd];
            NSString *js = [NSString stringWithFormat:@"getMessage(\"encodePwd\",\"%@\")", encodePwd];
            [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
                NSLog(@"%@",error);
            }];
        }
    } else if ([message.name isEqualToString:@"getDeviceInfo"]) {
        NSDictionary *basicParmars = [AFHTTPSessionManager basicParameters];
        NSString *json = [basicParmars toJSONWithPrettyPrint:NO];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"deviceInfo\",%@)", json];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable ohter, NSError * _Nullable error) {
            NSLog(@"%@", error);
        }];
    } else if ([message.name isEqualToString:@"jumpAppointPage"]) {
        // h5与原生交互新协议
        NSDictionary *bodyDict;
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            bodyDict = message.body;
        } else if ([message.body isKindOfClass:[NSString class]]) {
            bodyDict = [NSString dictionaryWithJsonString:message.body];
        }
        
        P2PInteractive_SkipType skyType = (P2PInteractive_SkipType)[bodyDict[@"routerType"] integerValue];
        [self handleRouterType:skyType message:message];
    }else if ([message.name isEqualToString:@"onPKFinish"]){
        
        [self h5ReturnGameShows:message];
    }else if ([message.name isEqualToString:@"onPKStart"]){
        
        [self gameStarth5ReturnGameShows:message];
    }else if ([message.name isEqualToString:@"onPKExceptionFinish"]){
        
        [self gameAbnormalOverReturnGameShows:message];
    }else if ([message.name isEqualToString:@"haveChangeWatch"]){
        
        [self gameStartAndWhetherShowWatchBtn:message];
    }else if ([message.name isEqualToString:@"openFaceLiveness"]){
        
        [self h5OpenFaceLivenessAction:message];
    }else if ([message.name isEqualToString:@"openWithDraw"]){
        
        [self h5JumpWithDrawAction:message];
    }else if ([message.name isEqualToString:@"openBillPassage"]){
        
        [self h5JumpBillListAction:message];
    }else if ([message.name isEqualToString:@"openTopicDetail"]){
        [self h5JumpWithOpenTopicDetailAction:message];
        
    }else if ([message.name isEqualToString:@"faceCertificationSuccess"]){
        [self H5JumpFaceCertificationSuccessAction:message];
    } else if ([message.name isEqualToString:@"onNotifyClient"]) {
        // H5 通知客户端进行一系列的操作
        [self H5NotifyAppActionStatus:message];
    }else if ([message.name isEqualToString:@"challenge"]){
        [self H5NotifyUserAccpetChallenge:message];
    } else if ([message.name isEqualToString:@"h5CallAppStatistics"]) {
        NSDictionary *dict = message.body;
        // 测一测操作统计
        [TTStatisticsService trackEvent:dict[@"funcName"] eventDescribe:dict[@"title"]];
    } else if ([message.name isEqualToString:@"closeWebView"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([message.name isEqualToString:@"closeDialogWebView"]) {
        [self h5CloseDialogWebViewAction:message];
    } else if ([message.name isEqualToString:@"updateCurrentUserInfo"]) {
        [self h5NotifyUserUpdateUserDataAction:message];
    } else if ([message.name isEqualToString:@"getRoomMicNumberInfoForPartyGame"]) {
        
        NSDictionary *basicParmars = GetCore(ImRoomCoreV2).micQueue;
        int currentPositionNum = basicParmars.allKeys.count == 9 ? 1 : 2;
        NSMutableArray *micUserArray = [NSMutableArray array];
        for (int i = 0; i < basicParmars.allKeys.count; i++) {
            ChatRoomMicSequence *micro = [basicParmars objectForKey:[NSString stringWithFormat:@"%d",i - currentPositionNum]];
            NIMChatroomMember *member = micro.chatRoomMember;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if (!member) {
                [dict setValue:@(false) forKey:@"haveNum"];
                [dict setValue:@(0) forKey:@"uid"];
            } else {
                [dict setValue:member.roomAvatar forKey:@"avatar"];
                [dict setValue:@(true) forKey:@"haveNum"];
                [dict setValue:member.roomNickname forKey:@"nick"];
                [dict setValue:@(member.userId.userIDValue) forKey:@"uid"];
            }
            [micUserArray addObject:dict];
        }
        NSString *json = [NSArray gs_jsonStringCompactFormatForNSArray:micUserArray];
        NSString *js = [NSString stringWithFormat:@"getMessage(\"data\",%@)", json];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable ohter, NSError * _Nullable error) {
            NSLog(@"%@", error);
        }];
    } else if ([message.name isEqualToString:@"roomPartyGameOver"]) {
       // [self h5NotifyUserCloseRoomGamePanel:message]; // 关闭游戏面板
    } else if ([message.name isEqualToString:@"h5CtrlPhoneVibrate"]) {
        //震动
        [LTVibrationTool showVibrationAction];
      
    } else if ([message.name isEqualToString:@"userLoginOut"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [GetCore(AuthCore) logout];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"deleteSuperAdmin"];
      
    }
}

- (void)onShareH5Failth:(NSString *)message {
    [UIView showToastInKeyWindow:message duration:2.0];
}

#pragma mark - private method

- (void)handleRouterType:(P2PInteractive_SkipType)skyType message:(WKScriptMessage *)message {
    NSDictionary *bodyDict = (NSDictionary *)message.body;
    switch (skyType) {
            case P2PInteractive_SkipType_BindingXCZAccount:
        {
            // 绑定支付宝账号
            NSInteger routerVal = (NSInteger)bodyDict[@"routerVal"];
            [self h5JumpXCZAction:routerVal message:message];
        }
            break;
            case P2PInteractive_SkipType_BindingPhoneNum:
        {
            // 绑定手机号码
            [self h5JumpBindingPhoneNumAction:message];
        }
            break;
            case P2PInteractive_SkipType_SettingPayPwd:
        {
            // 设置支付密码
            [self h5JumpSettingPayPwdAction:message];
        }
            break;
            case P2PInteractive_SkipType_PublicChat:
        {
            // 公聊大厅
            [self h5JumpPublicChatAction:message];
        }
            break;
            case P2PInteractive_SkipType_Room:
        {
            //房间页 传参：uid
            NSString *uid = [NSString stringWithFormat:@"%@", bodyDict[@"routerVal"]];
            if (uid.length) {
                [self h5OpenRoomAction:uid.userIDValue message:message];
            }
        }
            break;
            case P2PInteractive_SkipType_H5:
        {
            //H5
            NSString *urlString = [NSString stringWithFormat:@"%@", bodyDict[@"routerVal"]];
            if (urlString.length) {
                XCWKWebViewController *vc = [[[self class] alloc] init];
                vc.urlString = urlString;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            case P2PInteractive_SkipType_Purse:
        {
            //钱包页
            [self h5OpenPurseAction:message];
        }
            break;
            case P2PInteractive_SkipType_Red:
        {
            //xcRedColor
            [self h5JumpRedColorAction:message];
        }
            break;
            case P2PInteractive_SkipType_Recharge:
        {
            //充值页
            [self h5OpenChargePageAction:message];
        }
            break;
            case P2PInteractive_SkipType_Person:
        {
            //个人页 传参：uid
            NSString *uid = [NSString stringWithFormat:@"%@", bodyDict[@"routerVal"]];
            if (uid.length) {
                [self h5OpenPersonPageAction:uid.userIDValue message:message];
            }
        }
            break;
            case P2PInteractive_SkipType_Car:
        {
            //座驾 传参：2
            [self h5OpenDecorateMallPageAction:2 message:message];
        }
            break;
            case P2PInteractive_SkipType_Headwear:
        {
            //头饰 传参：1
            [self h5OpenDecorateMallPageAction:1 message:message];
        }
            break;
            case P2PInteractive_SkipType_SystemMessage:
        {
            //系统消息
            [self h5JumpSystemMessageAction:message];
        }
            break;
            case P2PInteractive_SkipType_Family:
        {
            //家族
            NSString *familyId = [NSString stringWithFormat:@"%@", bodyDict[@"routerVal"]];
            if (familyId.length > 0) {
                [self h5OpenFamilyPageAction:[familyId longLongValue] message:message];
            }
        }
            break;
            case P2PInteractive_SkipType_Group:
        {
            //群组
            NSString *uid = [NSString stringWithFormat:@"%@", bodyDict[@"routerVal"]];
            if (uid.length) {
                [self h5JumpGroupAction:uid.userIDValue message:message];
            }
        }
            break;
            case P2PInteractive_SkipType_Background:
        {
            //背景 传参：3
            [self h5OpenDecorateMallPageAction:3 message:message];
        }
            break;
            case P2PInteractive_SkipType_New_User:
        {
            //新秀玩友
            [self h5JumpNewFriendAction:message];
        }
            break;
            case P2PInteractive_SkipType_Invite_Friend:
        {
            //邀请好友
            [self h5JumpInvite_FriendAction:message];
        }
            break;
            case P2PInteractive_SkipType_WithdrawBillList:
        {
            // 跳转账单记录
            [self h5JumpBillListAction:message];
        }
            break;
        case P2PInteractive_SkipType_Recommend:
        {
            // 跳转推荐卡仓库
            [self H5JumpRecommendCardAction:message];
        }
            break;
        case  P2PInteractive_SkipType_Mentoring_Ship:
        {
            // 跳转师徒主页
            [self h5JumpMentoringShipAction:message];
        }
            break;
        case P2PInteractive_SkipType_LittleWorldGuestPage:
        {
            // 跳转小世界客态页
            [self h5JumpLittleWorldHomePageAction:message];
        }
            break;
        case P2PInteractive_SkipType_FeedbackPage:
        {
            [self H5JumpFeedBackPageAction:message];
        }
            break;
        default:
            break;
    }
}

/**
 密码加密
 
 @param pwd 密码明文
 @return 加密后的密码
 */
- (NSString *)encodePwd:(NSString *)pwd {
    NSString *encodePwd = [DESEncrypt encryptUseDES:pwd key:keyWithType(KeyType_PwdEncode, NO)];
    return encodePwd;
}

//根据shareInfo的response来判断是否显示share
- (void)initNav:(NSDictionary *)response {
    if (!response || ![response isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([response[@"type"] intValue]== WebViewRightNavigationItemTypePushWebPage) {
        self.jumpLink = response[@"data"][@"link"];
    }else if ([response[@"type"] intValue]== WebViewRightNavigationItemTypeShare){
        self.redShareDict = response[@"data"];
    }
}

// 返回按钮
- (void)backButtonClick {
    
    BOOL canGoBack = YES;
    if (self.webview.backForwardList.backList.count <= 1) {
        canGoBack = NO;
    }
    
    if ([self.webview canGoBack]) {
      
        if (![self.webview.URL.absoluteString containsString:@"nobles/paySuccess"]) {
            if ([self.webview.URL.absoluteString containsString:@"nobles/homepage"] || [self.webview.URL.absoluteString containsString:HtmlUrlKey(kTuTuCodeRedURL)]) { // 暂时用这种方法
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [self.webview goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [self removeScriptMessageHandler];
            return;
        }
        //refresh
        if ([[self.webview.URL absoluteString] containsString:HtmlUrlKey(kTurntableURL)]) {
            NSString *js = [NSString stringWithFormat:@"refreshWeb()"];
            [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
                NSLog(@"%@",error);
            }];
        }
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        [self removeScriptMessageHandler];
    }
}

- (void)removeScriptMessageHandler {
    [self.userContentController removeAllUserScripts];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webview.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webview) {
            self.navigationItem.title = self.webview.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark - Getter


- (WKWebView *)webview {
    if (_webview == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        
        if (@available(iOS 10.0, *)) {
            configuration.mediaTypesRequiringUserActionForPlayback = NO;
        } else {
            // Fallback on earlier versions
        }
        configuration.allowsInlineMediaPlayback = YES;
        
        NSString *uid = [GetCore(AuthCore)getUid];
        NSString *realCookie = [NSString stringWithFormat:@"%@=%@",@"uid",uid];
        
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource: [NSString stringWithFormat:@"document.cookie = '%@';", realCookie] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [self.userContentController addUserScript:cookieScript];
        //根据生成的WKUserScript对象，初始化WKWebViewConfiguration
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences.minimumFontSize = 10;
        configuration.selectionGranularity = WKSelectionGranularityCharacter;
        configuration.userContentController = self.userContentController;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, size.width,size.height) configuration:configuration];
        
        _webview.navigationDelegate = self;
        //添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        //添加KVO，监听title属性
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
        UISwipeGestureRecognizer *swiftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backButtonClick)];
        [_webview addGestureRecognizer:swiftGesture];
        
        //set useragent
        __weak typeof(self) weakSelf = self;
        [_webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *userAgent = result;
            switch (projectType()) {
                case ProjectType_TuTu:
                case ProjectType_Pudding:{
                    if (![userAgent containsString:@"tutuAppIos erbanAppIos"]){
                        NSString *newUserAgent = [userAgent stringByAppendingString:@" tutuAppIos erbanAppIos"];
                        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [weakSelf.webview setCustomUserAgent:newUserAgent];
                    }
                    break;
                }
                case ProjectType_Planet: {
                    if (![userAgent containsString:@"tutuAppIos erbanAppIos"]){
                        NSString *newUserAgent = [userAgent stringByAppendingString:@" tutuAppIos erbanAppIos"];
                        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [weakSelf.webview setCustomUserAgent:newUserAgent];
                    }
                    break;
                }
                    case ProjectType_BB:
                case ProjectType_MengSheng:{
                    if (![userAgent containsString:@"mengshengAppIos"]){
                        NSString *newUserAgent = [userAgent stringByAppendingString:@" mengshengAppIos"];
                        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [weakSelf.webview setCustomUserAgent:newUserAgent];
                    }
                    break;
                }
                case ProjectType_Haha:{
                    if (![userAgent containsString:@"hahayyAppIos"]){
                        NSString *newUserAgent = [userAgent stringByAppendingString:@"hahayyAppIos"];
                        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [weakSelf.webview setCustomUserAgent:newUserAgent];
                    }
                    break;
                }
                case ProjectType_VKiss:{
                    if (![userAgent containsString:@"VKissAppiOS"]){
                        NSString *newUserAgent = [userAgent stringByAppendingString:@"VKissAppiOS"];
                        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [weakSelf.webview setCustomUserAgent:newUserAgent];
                    }
                    break;
                }
                
                default:
                break;
            }
            
            
            
        }];
        
    }
    return _webview;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
        _progressView.progressTintColor = [UIColor colorWithRed:254 green:215 blue:0 alpha:1];//RGBACOLOR(254, 215, 0, 1);
        _progressView.trackTintColor = [UIColor clearColor];
        
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}
//h5交互方法
- (WKUserContentController *)userContentController{
    if (!_userContentController) {
        
        _userContentController = [[WKUserContentController alloc] init];
        // 停止录制音频
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"stopRecode"];
        // 开始录制音频
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"startRecode"];
        // 贵族订单
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"orderNoble"];
        // 消息聊天(私信)
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"contactSomeOne"];
        // 开通家族
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openFamilyPage"];
        // 钱包页面
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openPurse"];
        // 充值页面
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openChargePage"];
        // 个人主页(客态)
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openPersonPage"];
        // 分享面板
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openSharePage"];
        // 打开房间
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openRoom"];
        // ??
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getPosition"];
        // 获取uid
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getUid"];
        // 获取房间uid
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getRoomUid"];
        // 获取设备id
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getDeviceId"];
        // 获取Ticket
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getTicket"];
        // 刷新webview
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"refreshWeb"];
        // 获取app版本
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getAppVersion"];
        // 将内容粘贴到手机粘贴板
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"clipboardToPhone"];
        // 审核状态
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"loadingStatus"];
        // 是否需要显示导航栏
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"initShowNav"];
        // 根据shareInfo的response来判断是否显示share
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"initNav"];
        // 关闭webView
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"closeWebView"];
        // 跳转到装扮商城
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openDecorateMallPage"];
        // xcz，bindingPhone , setPayPwd 跳转
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"jumpAppointPage"];
        // 支付密码加密
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"encryptPwd"];
        // 获取app渠道
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getChannel"];
        // 获取设备info
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getDeviceInfo"];
        //  获取游戏结束之后的回调
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"onPKFinish"];
        //  CP房游戏开始，用于头想的确定，更加方便
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"onPKStart"];
        //  CP房  有一个人异常退出时
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"onPKExceptionFinish"];
        // 游戏页面是否显示切换视角按钮
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"haveChangeWatch"];
        // 实人认证: 打开原生人脸认证
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openFaceLiveness"];
        //vkissdraw
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openWithDraw"];
        //账单
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openBillPassage"];
        // vikiss话题详情页
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openTopicDetail"];
        //实人认证：后台返回认证成功 Vkiss
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"faceCertificationSuccess"];
        
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"onNotifyClient"];
        
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"challenge"];
        //h5调用原生埋点
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"h5CallAppStatistics"];
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"closeDialogWebView"];
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getRoomMicNumberInfoForPartyGame"];
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"roomPartyGameOver"];
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"h5CtrlPhoneVibrate"];
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"userLoginOut"];
        // h5调用原生，刷新用户信息
        [_userContentController addScriptMessageHandler:[[TTWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"updateCurrentUserInfo"];
    }
    return _userContentController;
}



- (void)dealloc {
    RemoveCoreClientAll(self);
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
//
//    self.webview = nil;
}
@end

