//
//  BaseTabBarViewController.m
//  TuTu
//
//  Created by KevinWang on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTabBarViewController.h"

#import "TabBarConfigManager.h"
#import "TabBarItemModel.h"

#import "XCMediator+TTHomeMoudle.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"

#import "XCDidFinishLaunch.h"
#import "MessageCore.h"
#import "MessageCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "TTServiceCore.h"
#import "TTServiceCoreClient.h"
#import "APNSCoreClient.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIImage+Utils.h"
#import "BaseNavigationController.h"
#import "XCCurrentVCStackManager.h"
#import "TTWKWebViewViewController.h"
#import "TTStatisticsService.h"
#import "UIImage+Resize.h"

#import "SVGA.h"
#import "SVGAParserManager.h"

static CGFloat kTabBarItemSize = 48;

@interface BaseTabBarViewController ()
<
MessageCoreClient,
ImMessageCoreClient,
TTServiceCoreClient,
APNSCoreClient,
CAAnimationDelegate,
UITabBarControllerDelegate
>

@property (nonatomic, strong) TabBarConfig *tabBarConfig;

@property (nonatomic, strong) SVGAImageView *svgImageView;
@property (nonatomic, strong) SVGAParserManager *svgManager;
@end

@implementation BaseTabBarViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(TTServiceCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);
    AddCoreClient(MessageCoreClient, self);
    AddCoreClient(APNSCoreClient, self);

    //初始化加载缓存配置
    self.tabBarConfig = [[TabBarConfigManager shareInstance] config];
    
    [self setupControllers];
    
    self.delegate = self;
    
    self.tabBar.translucent = NO;
    // 去除 TabBar顶部阴影
    
    self.tabBar.backgroundImage = [[UIImage new] imageWithColor:[UIColor whiteColor]];
    self.tabBar.shadowImage = [UIImage imageWithColor:UIColorFromRGB(0xebebeb) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.5)];
    
    [self.tabBar addSubview:self.svgImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:@"giftSwith"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Robot"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"matchType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 程序启动完成后, 初始化需要初始化的core
    [XCDidFinishLaunch didFinishLaunchAction];
}

#pragma mark - ImMessageCoreClient
- (void)onImUnReadCountHandleComplete {
    [self updateBadge];
}

#pragma mark - MessageCoreClient
/// 动态消息个数更新通知
- (void)onUpdateDynamicMessageCount:(DynamicMessageUnread *)count {
    [self updateDiscoverBadgeWithDynamicMsgCount:count.total];
}

#pragma mark - TTServiceCoreClient
- (void)onQYUnreadCountChanged:(NSInteger)count {
   [self updateBadge];
}

#pragma mark - APNSCoreClient
/// 收到消息页面类型的通知（需跳转到消息页）
- (void)onReceiveMessageTypeNotification:(NSDictionary *)info {
    [self gotoMessagePage];
}

/// 收到网页页面类型的通知（需跳转到web页）
- (void)onReceiveWebTypeNotificationWithURL:(NSString *)url {
    if (url == nil || url.length == 0) {
        return;
    }
    
    UINavigationController *nav = self.selectedViewController;
    TTWKWebViewViewController *webVC = [[TTWKWebViewViewController alloc] init];
    webVC.urlString = url;
    [nav pushViewController:webVC animated:YES];
}

/// 动态未读消息更新通知
- (void)onReceiveDynamicMessageUpdateNotification:(NSDictionary *)info {
    
    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTDynamicMessageViewController];
    UIViewController *current = [self currentViewController];
    if ([NSStringFromClass(current.class) isEqualToString:NSStringFromClass(vc.class)]) {
        return;
    }
    
    UINavigationController *nav = self.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)setupControllers {
    
    TabBarItemModel *game = [[TabBarItemModel alloc] init];
    game.image = [UIImage imageNamed:@"tab_gameHome_normal"];
    game.selectedImage = [UIImage imageNamed:@"tab_gameHome_selected"];
    
    TabBarItemModel *discover = [[TabBarItemModel alloc] init];
    discover.image = [UIImage imageNamed:@"tab_discover_normal"];
    discover.selectedImage = [UIImage imageNamed:@"tab_discover_selected"];
    
    TabBarItemModel *message = [[TabBarItemModel alloc] init];
    message.image = [UIImage imageNamed:@"tab_message_normal"];
    message.selectedImage = [UIImage imageNamed:@"tab_message_selected"];
    
    TabBarItemModel *me = [[TabBarItemModel alloc] init];
    me.image = [UIImage imageNamed:@"tab_me_normal"];
    me.selectedImage = [UIImage imageNamed:@"tab_me_selected"];
    
    if (self.tabBarConfig) {
        //读取服务端配置的TabBar
        for (TabBarConfigItem *conf in self.tabBarConfig.tabVos) {
            UIImage *uncheckIcon = [UIImage imageWithData:conf.uncheckIconData];
            if (uncheckIcon) {
                uncheckIcon = [self originImage:uncheckIcon scaleToSize:CGSizeMake(kTabBarItemSize, kTabBarItemSize)];
                
                switch (conf.code) {
                    case TabBarConfigItemCodeHome:
                    {
                        game.image = uncheckIcon;
                    }
                        break;
                    case TabBarConfigItemCodeSquare:
                    {
                        discover.image = uncheckIcon;
                    }
                        break;
                    case TabBarConfigItemCodeMessage:
                    {
                        message.image = uncheckIcon;
                    }
                        break;
                    case TabBarConfigItemCodePersonal:
                    {
                        me.image = uncheckIcon;
                    }
                        break;
                    default:
                        break;
                }
            }
            
            UIImage *checkIcon = [UIImage imageWithData:conf.checkIconData];
            if (checkIcon) {
                checkIcon = [self originImage:checkIcon scaleToSize:CGSizeMake(kTabBarItemSize, kTabBarItemSize)];
                
                switch (conf.code) {
                    case TabBarConfigItemCodeHome:
                    {
                        game.selectedImage = checkIcon;
                    }
                        break;
                    case TabBarConfigItemCodeSquare:
                    {
                        discover.selectedImage = checkIcon;
                    }
                        break;
                    case TabBarConfigItemCodeMessage:
                    {
                        message.selectedImage = checkIcon;
                    }
                        break;
                    case TabBarConfigItemCodePersonal:
                    {
                        me.selectedImage = checkIcon;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    UINavigationController *gameNav = [self createTabBarItem:[[XCMediator sharedInstance] ttGameMoudle_TTNewGameHomeViewController] model:game];
    
    UINavigationController *messageNav = [self createTabBarItem:[[XCMediator sharedInstance] ttMessageMoudle_TTMainMessageViewController] model:message];
    
    UINavigationController *discoverNav = [self createTabBarItem:[[XCMediator sharedInstance] ttDiscoverMoudle_TTDiscoverContainViewController] model:discover];
    
    UINavigationController *meNav = [self createTabBarItem:[[XCMediator sharedInstance] ttPersonalModule_MineView] model:me];
    
    [self addChildViewController:gameNav];
    [self addChildViewController:discoverNav];
    [self addChildViewController:messageNav];
    [self addChildViewController:meNav];
    
    //默认选中第一个
    self.selectedIndex = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //延迟设置svg，确保初始化完之后正确执行动画
        [self selectViewControllerAnimation:gameNav guardReclick:NO];
    });
}

- (UINavigationController *)createTabBarItem:(UIViewController *)vc model:(TabBarItemModel *)model {
    
    vc.tabBarItem.image = [model.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [model.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[XCTheme getTTMainColor]} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xA0A0A0)} forState:UIControlStateNormal];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.imageInsets =  UIEdgeInsetsMake(5, 0, - 5, 0);
    
    return nav;
}

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//获取当前显示的UIViewController
- (UIViewController *)currentViewController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *viewController = window.rootViewController;
    return [self getVisibleViewController:viewController];
}

//获取当前显示的UIViewController
- (UIViewController *)getVisibleViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)viewController;
        return [self getVisibleViewController:nav.visibleViewController];
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController*)viewController;
        return [self getVisibleViewController:tab.selectedViewController];
    } else {
        UIViewController *presentedViewController = viewController.presentedViewController;
        if (presentedViewController) {
            return [self getVisibleViewController:presentedViewController];
        } else {
            return viewController;
        }
    }
}

/// 跳转到消息页
- (void)gotoMessagePage {
    
    NSUInteger index = 2;
    if (self.childViewControllers.count <= index) {
        return;
    }
    
    //延时的原因：当应用发布动态后弹窗未消失前推出后台，再从后台推送进入跳转，会导致底部一条黑屏问题
    //不知道具体原因，延时是临时解决方案
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectedIndex = index;
    });
}

#pragma mark - Badge Settings
/// 设置消息个数角标
- (void)updateBadge {
    
    NSInteger msgCount = [GetCore(ImMessageCore) getUnreadCount];
//    NSInteger qyCount = [GetCore(TTServiceCore) getQYServiceUnreadCount];
    NSInteger dynamicCount = GetCore(MessageCore).unread.total;
    
    //更新角标必须在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //发现页角标更新
        [self updateDiscoverBadgeWithDynamicMsgCount:dynamicCount];
        //消息页角标更新
        [self updateMessageBadgeWithImMsgCount:msgCount qyMsgCout:0];
    });
}

/// 消息页角标更新
/// @param imMsgCount 云信消息数
/// @param qyMsgCount 七鱼消息数
- (void)updateMessageBadgeWithImMsgCount:(NSInteger)imMsgCount
                               qyMsgCout:(NSInteger)qyMsgCount {
    
    NSInteger count = imMsgCount + qyMsgCount;
    NSString *badge = count > 0 ? @(count).stringValue : nil;
    if (count > 99) {
        badge = @"99+";
    }
    
    NSUInteger index = 2;
    UITabBarItem *item = self.tabBar.items.count > index ? self.tabBar.items[index] : nil;
    [item setBadgeValue:badge];
}

/// 发现页角标更新
/// @param dynamicMsgCount 动态消息数
- (void)updateDiscoverBadgeWithDynamicMsgCount:(NSInteger)dynamicMsgCount {
    NSString *badge = dynamicMsgCount > 0 ? @(dynamicMsgCount).stringValue : nil;
    if (dynamicMsgCount > 99) {
        badge = @"99+";
    }
    
    NSUInteger index = 1;
    UITabBarItem *item = self.tabBar.items.count > index ? self.tabBar.items[index] : nil;
    [item setBadgeValue:badge];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    switch (tabBarController.selectedIndex) {
        case 0:
        {
            [TTStatisticsService trackEvent:@"home_first_tab" eventDescribe:@"首页tab"];
        }
            break;
        case 1:
        {
            [TTStatisticsService trackEvent:@"home_find_tab" eventDescribe:@"发现tab"];
        }
            break;
        case 2:
        {
            [TTStatisticsService trackEvent:@"home_message_tab" eventDescribe:@"消息tab"];
        }
            break;
        case 3:
        {
            [TTStatisticsService trackEvent:@"home_mine_tab" eventDescribe:@"我的tab"];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    [self selectViewControllerAnimation:viewController guardReclick:YES];
    
    return YES;
}

#pragma mark - SGVA Animation
/// 选择控制器后的动画
/// @param viewController 选中的控制器
/// @param guardReclick 是否判断重复点击防护
- (void)selectViewControllerAnimation:(UIViewController *)viewController guardReclick:(BOOL)guardReclick {

    if (!self.tabBarConfig) {
        return;
    }
    
    if (guardReclick && self.selectedViewController == viewController) {
        //选择同一个tab不再执行动画
        return;
    }
    
    NSInteger shouldSelectIndex = NSNotFound;
    for (NSInteger index=0; index<self.viewControllers.count; index++) {
        UIViewController *vc = self.viewControllers[index];
        if (viewController == vc) {
            shouldSelectIndex = index;
            break;
        }
    }
    
    if (shouldSelectIndex != NSNotFound) {
        
        UIView *view = nil;
        if (self.tabBar.subviews.count > shouldSelectIndex+1) {
            view = self.tabBar.subviews[shouldSelectIndex+1];
        }
        
        TabBarConfigItem *conf = nil;
        TabBarConfigItemCode code = shouldSelectIndex + 1;
        for (TabBarConfigItem *item in self.tabBarConfig.tabVos) {
            if (item.code == code) {
                conf = item;
                break;
            }
        }
        
        self.svgImageView.hidden = !(view && conf.svgaUrl);
        [self.svgImageView clear];
        
        if (view && conf.svgaUrl) {
            CGFloat x = CGRectGetMidX(view.frame) - kTabBarItemSize/2.0;
            CGFloat y = CGRectGetMinY(view.frame);
            self.svgImageView.frame = CGRectMake(x, y, kTabBarItemSize, kTabBarItemSize);

            NSURL *url = [NSURL URLWithString:conf.svgaUrl];
            
            @weakify(self)
            [self.svgManager loadSvgaWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                @strongify(self)
                self.svgImageView.loops = conf.needLoop ? INT_MAX : 1;
                self.svgImageView.clearsAfterStop = NO;
                self.svgImageView.videoItem = videoItem;
                [self.svgImageView startAnimation];
            } failureBlock:^(NSError * _Nullable error) {
            }];
        }
    }
}

#pragma mark - Lazy Load
- (SVGAParserManager *)svgManager {
    if (!_svgManager) {
        _svgManager = [[SVGAParserManager alloc] init];
    }
    return _svgManager;
}

- (SVGAImageView *)svgImageView {
    if (_svgImageView == nil) {
        _svgImageView = [[SVGAImageView alloc]init];
        _svgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _svgImageView.userInteractionEnabled = NO;
    }
    return _svgImageView;
}

@end
