//
//  TTWKWebViewViewController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTWKWebViewViewController.h"

//core
#import "VersionCore.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "FileCore.h"
#import "ShareCore.h"
#import "UserCore.h"
#import "TTGameStaticTypeCore.h"
#import "HostUrlManager.h"
#import "AFHTTPSessionManager+Config.h"
//client
#import "FileCoreClient.h"
#import "AuthCoreClient.h"
//model
#import "RedShareInfo.h"

//tool
#import "YYUtility.h"
#import "DESEncrypt.h"
#import "XCTheme.h"
#import "XCHtmlUrl.h"
#import "XCAlertControllerCenter.h"
#import "XCCurrentVCStackManager.h"
#import <RPSDK/RPSDK.h>
//center
#import "TTWebViewDisposeCenter.h"

//view
#import "XCShareView.h"

//mediator
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"

//const
#import "XCConst.h"
#import <YYModel/YYModel.h>

NS_ENUM(NSInteger, TTDecorateMallPage){
    TTDecorateMallPage_HeadWear =1,
    TTDecorateMallPage_Car =2,
    TTDecorateMallPage_RoomBack =3,
};


@interface TTWKWebViewViewController ()
<
    AuthCoreClient,
    FileCoreClient,
    XCShareViewDelegate
>

@property (nonatomic, strong) AVAudioRecorder  *recorder;
@property (nonatomic, strong) AVAudioSession  *session;
@property (nonatomic, strong) NSURL  *recordFileUrl;
@property (nonatomic, strong) AVAudioPlayer  *player;
@property (nonatomic, strong) UIButton  *recodeBtn;
@property (nonatomic, strong) NSString  *filePath;
@end

@implementation TTWKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(FileCoreClient, self);
    self.progressView.progressTintColor = [XCTheme getTTMainColor];
    // Do any additional setup after loading the view.

    [self addNavigationItemWithImageNames:@[@"nav_bar_back", @"icon_tab_close2"] isLeft:YES target:self action:@selector(backBtnHandler:) tags:@[@1001, @1002]];
    
}

- (void)backBtnHandler:(UIButton *)btn {
    if (btn.tag == 1001) {
        [self backButtonClick];
    } else if (btn.tag == 1002) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    RemoveCoreClientAll(self);
    self.session = nil;
    self.recorder = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *mapURL = HtmlUrlKey(kTuTuCodeRedURL);
    if (mapURL != nil && mapURL.length > 0 && [[self.webview.URL absoluteString] containsString:mapURL]) {
        NSString *js = [NSString stringWithFormat:@"refreshWeb()"];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 解决WKScriptMessageHandler的@"initShowNav"导致导航栏被隐藏问题
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)initNav:(NSDictionary *)response{
    if(!response || ![response isKindOfClass:[NSDictionary class]])return;
    if ([response[@"type"] intValue]== WebViewRightNavigationItemTypePushWebPage) {
        [self addNavigationItemWithTitles:@[response[@"data"][@"title"]] titleColor:UIColorFromRGB(0x333333) isLeft:NO target:self action:@selector(gotoNobleFAQ) tags:nil];
        self.jumpLink = response[@"data"][@"link"];
    }else if ([response[@"type"] intValue]== WebViewRightNavigationItemTypeShare || [response[@"type"] intValue]== WebViewRightNavigationItemTypeSharePicture){
        [self addNavigationItemWithImageNames:@[@"family_person_share"] isLeft:NO
                                       target:self action:@selector(showSharePanel) tags:nil];
        self.redShareDict = response[@"data"];
    } else if ([response[@"type"] intValue] == WebViewRightNavigationItemH5PushAppPage) {
        if ((P2PInteractive_SkipType)[response[@"data"][@"routerType"] integerValue] == P2PInteractive_SkipType_WithdrawBillList) {
            [self addNavigationItemWithTitles:@[response[@"data"][@"title"]] titleColor:UIColorFromRGB(0x333333) isLeft:NO target:self action:@selector(gotoOutputsList) tags:nil];
        }
    }
}

- (void)gotoNobleFAQ{
    TTWKWebViewViewController * controller = [[TTWKWebViewViewController alloc] init];
    controller.url = [NSURL URLWithString:self.jumpLink];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:controller animated:YES];
}

- (void)gotoOutputsList {
 UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_billListViewController:2];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark H5JumpAppPage Methods
/** 分享 */
- (void)h5OpenSharePageAction:(WKScriptMessage *)message {
    
    if (message.body && message.body != [NSNull null]) {
        
        NSDictionary *body;    
        //不知道是哪个蓝精灵弄的，变成了个dic，所以我们要判断类型
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            body = message.body;
        } else if ([message.body isKindOfClass:[NSString class]]) {
            body = [self dictionaryWithJsonString:message.body];
        }
        WebViewRightNavigationItemType type = (WebViewRightNavigationItemType)[body[@"type"] intValue];
        self.redShareDict = body[@"data"];
    }
    [self showSharePanel];
    
}
/** 开始录音 */
- (void)h5StartRecodeAction:(WKScriptMessage *)message {
    [self startRecode];
}
/** 停止录音 */
- (void)h5StopRecodeAction:(WKScriptMessage *)message {
    [self stopRecord];
}
/** 设置导航栏 */
- (void)h5InitNav:(WKScriptMessage *)message {
    NSDictionary *response = message.body;
    [self initNav:response];
}
/** 绑定手机号 */
- (void)h5JumpBindingPhoneNumAction:(WKScriptMessage *)message {
    UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_BindingPhoneController:0 userInfo:@{}];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:controller animated:YES];
}

// 根据h5跳绑定xcz, type: 0编辑状态：已绑定，进行编辑 1普通状态：第一次绑定
- (void)h5JumpXCZAction:(NSInteger)type message:(WKScriptMessage *)message {
    NSInteger bindXCZAccountType;
    if (type == 1) {
        bindXCZAccountType = 1;
    } else if (type == 0) {
        bindXCZAccountType = 0;
    }
    UIViewController * xczVc = [[XCMediator sharedInstance] ttPersonalModule_bindingXCZViewController:bindXCZAccountType userInfo:@{} zxcInfo:@{}];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:xczVc animated:YES];
}

/** 设置二级密码 */
- (void)h5JumpSettingPayPwdAction:(WKScriptMessage *)message {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_setPWViewController:NO isPayment:YES userInfo:@{}];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

/** 跳转公聊大厅 */
- (void)h5JumpPublicChatAction:(WKScriptMessage *)message {
    UIViewController *currentVc = [[XCCurrentVCStackManager shareManager] getCurrentVC];
    if ([currentVc isKindOfClass:[NSClassFromString(@"TTHeadLineContainerController") class]]) {
        [currentVc setValue:@(1) forKey:@"currentPage"];
    } else {
        UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:1];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    }
}

/** 跳转个人主页 */
- (void)h5OpenPersonPageAction:(long long)uid message:(WKScriptMessage *)message {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

/** 跳转家族 */
- (void)h5OpenFamilyPageAction:(long long)familyId message:(WKScriptMessage *)message {
    UIViewController *familyVC = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:familyId];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:familyVC animated:YES];
}

- (void)h5JumpMentoringShipAction:(WKScriptMessage *)message{
    UIViewController * master = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMasterViewController];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:master animated:YES];
}

/** 跳转充值页面 */
- (void)h5OpenChargePageAction:(WKScriptMessage *)message {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

/** 跳转房间页面 */
- (void)h5OpenRoomAction:(long long)uid message:(WKScriptMessage *)message {
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:uid];
}

/** 贵族 */
- (void)h5OrderNobleAction:(WKScriptMessage *)message {
    [[TTWebViewDisposeCenter defaultCenter] disposeNobleOrder:message.body];
    [TTWebViewDisposeCenter defaultCenter].webView = self.webview;
}

/** 私聊 */
- (void)h5ContactSomeOneAction:(long long)uid message:(WKScriptMessage *)message {
    UIViewController *sessionVC = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:uid sessectionType:NIMSessionTypeP2P];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:sessionVC animated:YES];
}

/** 跳转装扮商城 */
- (void)h5OpenDecorateMallPageAction:(NSInteger)index message:(WKScriptMessage *)message {
    UIViewController *dressupVC = nil;
    if (index == TTDecorateMallPage_HeadWear) {
        dressupVC = [[XCMediator sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:[GetCore(AuthCore)getUid].userIDValue index:0];
    }else if(index == TTDecorateMallPage_Car){
        dressupVC = [[XCMediator sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:[GetCore(AuthCore)getUid].userIDValue index:1];
    }
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:dressupVC animated:YES];
}

// H5调起原生实人认证: 打开原生人脸认证
- (void)h5OpenFaceLivenessAction:(WKScriptMessage *)message {
#if TARGET_IPHONE_SIMULATOR//模拟器
    
#elif TARGET_OS_IPHONE//真机
    NSString *verifyToken = message.body;
    [RPSDK startWithVerifyToken:verifyToken viewController:self.navigationController completion:^(RPResult * _Nonnull result) {
        NSInteger status = result.state;
        if (result.state == RPStatePass) {
            status += 1;
        } else if (result.state == RPStateFail) {
            status -= 1;
        }
        NSString *js = [NSString stringWithFormat:@"renderByStatus(\"%zd\")",status];
        
        if (result.state == RPStatePass) {
            __block UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
            info.isCertified = YES;
            [GetCore(UserCore) cacheUserInfo:info complete:^{
                info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
            }];
            info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
        }
        
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }];
#endif
}

// 跳转推荐卡
- (void)H5JumpRecommendCardAction:(WKScriptMessage *)message {
    
    __block BOOL isFromRecommedVc = NO;
    
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSClassFromString(@"TTRecommendContainViewController") class]]) {
            isFromRecommedVc = YES;
            *stop = YES;
        }
    }];
    
    // 如果是从上级页面过来的
    if (isFromRecommedVc) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIViewController  *vc = [[XCMediator sharedInstance] ttPersonalModule_openMyRecommendCardViewController];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    }
}

- (void)H5NotifyAppActionStatus:(WKScriptMessage *)message {
    
    NSDictionary *dict;
    //不知道是哪个蓝精灵弄的，变成了个dic，所以我们要判断类型
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        dict = message.body;
    } else if ([message.body isKindOfClass:[NSString class]]) {
        dict = [self dictionaryWithJsonString:message.body];
    }

    NSString *str = [NSString stringWithFormat:@"%@", dict[@"type"]];
    WebViewNotifyAppActionStatusType statusType = (WebViewNotifyAppActionStatusType)str.integerValue;
    if (statusType == WebViewNotifyAppActionStatusTypeRecommedRefresh) {
      // 推荐卡
        !_notifyRefreshHandler ? : _notifyRefreshHandler(statusType);
    }
}

// 榜单挑战
- (void)H5NotifyUserAccpetChallenge:(WKScriptMessage *)message{
    [[BaiduMobStat defaultStat]logEvent:@"gamelist_challenge" eventLabel:@"挑战按钮"];
    NSArray *messageArray = message.body;
    GetCore(TTGameStaticTypeCore).gameID = [messageArray safeObjectAtIndex:1];
    UIViewController *sessionVC = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[[messageArray safeObjectAtIndex:0] userIDValue] sessectionType:NIMSessionTypeP2P];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:sessionVC animated:YES];
}

//跳转小世界客态页
- (void)h5JumpLittleWorldHomePageAction:(WKScriptMessage *)message {
    
    NSDictionary *body;
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        body = message.body;
    } else if ([message.body isKindOfClass:[NSString class]]) {
        body = [self dictionaryWithJsonString:message.body];
    }
    NSString *worldId = [NSString stringWithFormat:@"%@",body[@"routerVal"]];
    if (worldId.length) {
        UIViewController *worldVC = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:worldId isFromRoom:NO];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:worldVC animated:YES];
    }
}

/// 请求关闭webView
- (void)h5CloseDialogWebViewAction:(WKScriptMessage *)message {
    !self.dismissRequestHandler ?: self.dismissRequestHandler();
}

/// 跳转意见反馈页面
- (void)H5JumpFeedBackPageAction:(WKScriptMessage *)message {
    
    NSString *val = [message.body objectForKey:@"routerVal"];
    NSInteger source = 0;
    if ([val isEqualToString:@"DRAW"]) {
        source = 2;
    } else if ([val isEqualToString:@"ROOM_RED"]) {
        source = 3;
    }
    
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTFeedbackViewControllerWithSource:source];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark - XCShareViewDelegate

- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag {
    RedShareInfo *shareInfo = [RedShareInfo yy_modelWithJSON:self.redShareDict];
    
    NSString *urlStr = shareInfo.url.length > 0 ? shareInfo.url : shareInfo.showUrl;
    if (urlStr.length) {
        if ([urlStr containsString:@"?"]) {
            urlStr = [NSString stringWithFormat:@"%@&shareUid=%@",urlStr,[GetCore(AuthCore)getUid]];
        } else {
            urlStr = [NSString stringWithFormat:@"%@?shareUid=%@",urlStr,[GetCore(AuthCore)getUid]];
        }
    }
    switch (itemTag) {
        case XCShareItemTagAppFriends:
        {
            [GetCore(ShareCore)shareH5WithTitle:shareInfo.title url:urlStr imgUrl:shareInfo.imgUrl desc:shareInfo.desc callBackLink:shareInfo.link platform:Share_Platfrom_Type_Within_Application];
        }
            break;
        case XCShareItemTagQQ:
        {
            [GetCore(ShareCore)shareH5WithTitle:shareInfo.title url:urlStr imgUrl:shareInfo.imgUrl desc:shareInfo.desc callBackLink:shareInfo.link platform:Share_Platform_Type_QQ];
        }
            break;
        case XCShareItemTagQQZone:
        {
            [GetCore(ShareCore)shareH5WithTitle:shareInfo.title url:urlStr imgUrl:shareInfo.imgUrl desc:shareInfo.desc callBackLink:shareInfo.link platform:Share_Platform_Type_QQ_Zone];
        }
            break;
        case XCShareItemTagWeChat:
        {
            [GetCore(ShareCore)shareH5WithTitle:shareInfo.title url:urlStr imgUrl:shareInfo.imgUrl desc:shareInfo.desc callBackLink:shareInfo.link platform:Share_Platform_Type_Wechat];
        }
            break;
        case XCShareItemTagMoments:{
            [GetCore(ShareCore)shareH5WithTitle:shareInfo.title url:urlStr imgUrl:shareInfo.imgUrl desc:shareInfo.desc callBackLink:shareInfo.link platform:Share_Platform_Type_Wechat_Circle];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - private method

/**
 密码加密

 @param pwd 密码明文
 @return 加密后的密码
 */
- (NSString *)encodePwd:(NSString *)pwd {
    NSString *encodePwd = [DESEncrypt encryptUseDES:pwd key:keyWithType(KeyType_PwdEncode, NO)];
    return encodePwd;
}
- (void)showSharePanel {
    
    XCShareItem *cycle = [[XCShareItem alloc]init];
    cycle.title = @"朋友圈";
    cycle.imageName = @"share_wxcircle";
    cycle.disableImageName = @"share_wxcircle_disable";
    cycle.disable = NO;
    cycle.itemTag = XCShareItemTagMoments;
    
    XCShareItem *wfriend = [[XCShareItem alloc]init];
    wfriend.title = @"微信好友";
    wfriend.imageName = @"share_wx";
    wfriend.disableImageName = @"share_wx_disable";
    wfriend.disable = NO;
    wfriend.itemTag = XCShareItemTagWeChat;
    
    XCShareItem *zone = [[XCShareItem alloc]init];
    zone.title = @"QQ空间";
    zone.imageName = @"share_qqzone";
    zone.disableImageName = @"share_qqzone_disable";
    zone.disable = NO;
    zone.itemTag = XCShareItemTagQQZone;
    
    XCShareItem *qfriend = [[XCShareItem alloc]init];
    qfriend.title = @"QQ好友";
    qfriend.imageName = @"share_qq";
    qfriend.disableImageName = @"share_qq_disable";
    qfriend.disable = NO;
    qfriend.itemTag = XCShareItemTagQQ;

    CGFloat margin = 9;
    CGSize itemSize = CGSizeMake((KScreenWidth-2*margin)/4, 111);
    XCShareView *shareView = [[XCShareView alloc]initWithItemSize:itemSize items:@[cycle,wfriend,zone,qfriend] margin:margin];
    shareView.delegate = self;
    [[XCAlertControllerCenter defaultCenter]presentAlertWith:self view:shareView preferredStyle:TYAlertControllerStyleActionSheet dismissBlock:nil completionBlock:nil];
}

- (void)startRecode {
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [path stringByAppendingString:[NSString stringWithFormat: @"/erban_%f.wav",[NSDate new].timeIntervalSince1970]];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:self.filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (self.recorder) {
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        [self.recorder record];
    }else{
        
    }
}


- (void)stopRecord {
    NSLog(@"停止录音");
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [self uploadRecode];
    }
}

- (void)uploadRecode {
    if (!self.filePath) {
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.filePath]) {
        return;
    }
    NSData *fileData = [NSData dataWithContentsOfURL:self.recordFileUrl];
    [GetCore(FileCore) qiNiuUploadFile:fileData uploadType:UploadImageTypeWKWeb];
    
}

- (void)backButtonClick{
    [super backButtonClick];
    if ([self.webview canGoBack]) {
        if ([[self.webview.URL absoluteString] containsString:@"activity/double12"] ||
            [[self.webview.URL absoluteString] containsString:@"nobles/order"] ||
            [[self.webview.URL absoluteString] containsString:@"nobles/intro"]) {
            
            NSString *js = [NSString stringWithFormat:@"refreshWeb()"];
            [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
                NSLog(@"%@",error);
            }];
        }
        
    }
}

#pragma mark - FileCilent

- (void)onUploadRecodeFileSuccess:(NSString *)url {
    NSString *fileurl = [NSString stringWithFormat:@"%@/%@",keyWithType(KeyType_QiNiuBaseURL, NO),url];
    NSString *js = [NSString stringWithFormat:@"getMessage(\"voice\",\"%@\")",fileurl];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}
- (void)onUploadRecodeFileFailth:(NSString *)message {
    NSString *js = [NSString stringWithFormat:@"getMessage(\"failed\",\"%@\")",message];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark - Getter & Setter
- (AVAudioSession *)session {
    if(!_session) {
        _session =[AVAudioSession sharedInstance];
        NSError *sessionError;
        [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if (_session == nil) {
            
            NSLog(@"Error creating session: %@",[sessionError description]);
            
        }else{
            [_session setActive:YES error:nil];
        }
    }
    return _session;
}

#pragma mark - AuthCoreClient

- (void)onLoginSuccess {
    
    NSString *js = [NSString stringWithFormat:@"refreshWeb()"];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}


@end
