//
//  TTDressUpContainViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpContainViewController.h"
#import "TTRechargeViewController.h"
#import "LLRechargeViewController.h"

#import "TTDressUpContainViewController+BuyOrPresentAction.h"
//controller
#import "TTCarDressUpShopViewController.h"
#import "TTHeadwearDressUpShopViewController.h"
#import "TTMineDressUpContainViewController.h"
//view
#import "TTUserCarPreviewView.h"
#import "TTDressUpSelectTabView.h"
#import "TTDressUpShopBottomView.h"
#import "ZJScrollPageView.h"

//model
#import "UserHeadWear.h"
#import "UserCar.h"

//core
#import "TTDressUpUIClient.h"
#import "BalanceErrorClient.h"
#import "CarCore.h"
#import "HeadWearCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "P2PInteractiveAttachment.h"
//t
#import "CoreManager.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>

//cate
#import "XCHUDTool.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

@interface TTDressUpContainViewController ()<ZJScrollPageViewDelegate,TTDressUpContainHeadViewDelegate,TTDressUpUIClient,TTUserCarPreviewViewDelegate, ImMessageCoreClient>

@property (nonatomic, strong) UIView  *containView;//
@property (nonatomic, strong) TTDressUpSelectTabView  *segmentView;//

@property(strong, nonatomic) ZJScrollPageView *scrollPageView;
@property(strong, nonatomic) NSArray<NSString *> *titles;

@property (nonatomic, strong) TTDressUpShopBottomView  *bottomView;//
@property (nonatomic, strong) TTUserCarPreviewView  *preview;//预览座驾
@property (nonatomic, assign) TTDressUpPlaceType type; // 类型
@end

@implementation TTDressUpContainViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}
- (BOOL)isHiddenNavBar {
    return YES;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    
    //显示小红点的状态
    NSString * isreadKey = [NSString stringWithFormat:@"%@%@", kDressNewMessageReadKey, [GetCore(AuthCore) getUid]];
    NSString * isRead = [[NSUserDefaults standardUserDefaults] valueForKey:isreadKey];
    
    if (isRead && [isRead isEqualToString:@"NO"] && self.userInfo.uid == [[GetCore(AuthCore) getUid] userIDValue]) {
        self.headView.isShowBage = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initSubViews {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.containView];
    [self.containView addSubview:self.segmentView];
    [self.containView addSubview:self.scrollPageView];
    [self.view addSubview:self.bottomView];
    [self makeConstriants];
    if (self.place) {
        [self.scrollPageView setSelectedIndex:self.place animated:YES];
    }
    //显示小红点的状态
    NSString * isreadKey = [NSString stringWithFormat:@"%@%@", kDressNewMessageReadKey, [GetCore(AuthCore) getUid]];
    NSString * isRead = [[NSUserDefaults standardUserDefaults] valueForKey:isreadKey];
    
    if (isRead && [isRead isEqualToString:@"NO"]) {
        self.headView.isShowBage = YES;
    }
}

- (void)makeConstriants {
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(202+statusbarHeight);
    }];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(-10);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(59+kSafeAreaBottomHeight);
    }];
    [self addCore];
}

- (void)addCore {
    AddCoreClient(TTDressUpUIClient, self);
    AddCoreClient(BalanceErrorClient, self);
    AddCoreClient(ImMessageCoreClient, self);
}

#pragma mark - Core && Client

- (void)onBalanceNotEnough {
    [XCHUDTool hideHUD];
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"温馨提示";
    config.message = @"账户余额不足，前往充值?";
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        UIViewController *vc;
        vc = [[LLRechargeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        // 统计钱包不足的行为是什么导致
        [TTStatisticsService trackEvent:TTStatisticsServiceEventNotEnoughToRecharge eventDescribe:[self trackEventName]];
    } cancelHandler:^{
    }];
}

/// 统计字段
- (NSString *)trackEventName {
    NSString *str;
    if (self.type == TTDressUpPlaceType_CarShop) {
        str = @"买座驾";
    } else if (self.type == TTDressUpPlaceType_HeadwearShop) {
        str = @"买头饰";
    }
    return str;
}

// 底部 操作 面板 赠送头饰座驾
- (void)shopBottomPresentCar:(UserCar *)userCar headwear:(UserHeadWear *)headwear {
    [self selectPresenterPersonWithCar:userCar Headwear:headwear];
}

//购买 座驾
- (void)shopBuyCar:(UserCar *)userCar place:(TTDressUpPlaceType)type {
    if (type != TTDressUpPlaceType_CarShop) {
        return;
    }
    self.type = type;
    [self presenterActionWithUserInfo:nil car:userCar headwear:nil isPresent:NO];
}

//购买 头饰
- (void)shopBuyHeadwear:(UserHeadWear *)headwear place:(TTDressUpPlaceType)type {
    if (type != TTDressUpPlaceType_HeadwearShop) {
        return;
    }
    self.type = type;
    [self presenterActionWithUserInfo:nil car:nil headwear:headwear isPresent:NO];
}

//座驾预览
- (void)showCar:(UserCar *)userCar {
    self.preview = nil;
    self.preview.car = userCar;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.view addSubview:self.preview];

}

#pragma mark - TTUserCarPreviewViewDelegate

- (void)carOrderViewDidDismiss {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - TTDressUpContainHeadViewDelegate

- (void)onClickBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickMineDressupAction {
    //是不是已经看过了 重置一下状态
    NSString * isreadKey = [NSString stringWithFormat:@"%@%@", kDressNewMessageReadKey, [GetCore(AuthCore) getUid]];
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:isreadKey];
    self.headView.isShowBage = NO; // 取消显示红点
    
    TTMineDressUpContainViewController *VC = [[TTMineDressUpContainViewController alloc] init];
    VC.presentVC = self;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - ImMessageCoreClient
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg{
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeP2P) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[P2PInteractiveAttachment class]]) {
            P2PInteractiveAttachment * p2p = (P2PInteractiveAttachment *)customObject.attachment;
            if (p2p.routerType == P2PInteractive_SkipType_Car || p2p.routerType == P2PInteractive_SkipType_Headwear) {
                self.headView.isShowBage = YES;
            }
        }
    }
}

#pragma mark -显示小红点
- (void)buyCarOrWearPresentRedHot:(BOOL)status
{
    NSString * isreadKey = [NSString stringWithFormat:@"%@%@", kDressNewMessageReadKey, [GetCore(AuthCore) getUid]];
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:isreadKey];
    self.headView.isShowBage = YES;
}


#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers
{
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        @weakify(self)
        if (index == 0) {
            TTHeadwearDressUpShopViewController *hearwearShop = [[TTHeadwearDressUpShopViewController alloc]init];
            hearwearShop.type = TTDressUpPlaceType_HeadwearShop;
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)hearwearShop;
        }else if (index == 1) {
            TTCarDressUpShopViewController *carShopVc = [[TTCarDressUpShopViewController alloc]init];
            carShopVc.type = TTDressUpPlaceType_CarShop;
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)carShopVc;
        }
    }
    
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    self.segmentView.index = index;
}


#pragma mark - Getter && Setter

- (void)setUserID:(UserID)userID {
    _userID = userID;
    if (_userID == 0) {
        @weakify(self)
        [[GetCore(UserCore) getUserInfoByRac:GetCore(AuthCore).getUid.longLongValue refresh:NO] subscribeNext:^(id x) {
            @strongify(self)
            self.userInfo = (UserInfo *)x;
        }];
    }else {
        @weakify(self)
        [[GetCore(UserCore) getUserInfoByRac:_userID refresh:NO] subscribeNext:^(id x) {
            @strongify(self)
            self.userInfo = (UserInfo *)x;
        }];
    }
    
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    self.headView.info = _userInfo;
}

- (TTDressUpContainHeadView *)headView {
    if (!_headView) {
        _headView = [[TTDressUpContainHeadView alloc] init];
        _headView.delegate = self;
    }
    return _headView;
}

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor whiteColor];
        _containView.layer.cornerRadius = 14;
        _containView.layer.masksToBounds = YES;
    }
    return _containView;
}

- (TTDressUpSelectTabView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TTDressUpSelectTabView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50) titles:self.titles];
        @weakify(self)
        _segmentView.selectBlock = ^(int selectIndex) {
            @strongify(self)
            [self.scrollPageView setSelectedIndex:selectIndex animated:YES];
        };
    }
    return _segmentView;
}

- (ZJScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight-(202+statusbarHeight)-(50+kSafeAreaBottomHeight)) segmentStyle:nil titles:self.titles parentViewController:self delegate:self];
    }
    return _scrollPageView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"头饰",@"座驾"];
    }
    return _titles;
}

- (TTDressUpShopBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TTDressUpShopBottomView alloc] init];
    }
    return _bottomView;
}

- (TTUserCarPreviewView *)preview {
    if (!_preview) {
        _preview = [[TTUserCarPreviewView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _preview.delegate = self;
    }
    return _preview;
}

@end
