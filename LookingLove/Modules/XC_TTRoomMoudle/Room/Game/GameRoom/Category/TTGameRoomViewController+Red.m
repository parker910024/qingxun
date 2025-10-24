//
//  TTGameRoomViewController+Red.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/12.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTGameRoomViewController+Red.h"
#import "TTGameRoomViewController+Private.h"
#import "TTSendRedBagView.h"
#import "TTRedBagGuideView.h"
#import "TTRedDrawResultView.h"

#import "ImRoomCoreV2.h"
#import "PraiseCore.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "ClientCore.h"

#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"
#import "TTStatisticsService.h"

#import <Masonry.h>

///红包引导状态保存
static NSString *const kRedbagGuideStatusStoreKey = @"TTGameRoomViewControllerRedbagGuideStatus";

@implementation TTGameRoomViewController (Red)

#pragma mark - Public
/// 初始化配置红包入口，是否显示及显示动画
- (void)initialRedEntranceView {
    @weakify(self)
    [self requestRedListWithCompletion:^{
        @strongify(self)
        [self updateRedEntranceViewShowStatus];
        
        if (!self.redEntranceView.isHidden) {
            [self.redEntranceView showAnimation];
        }
    }];
}

/// 更新红包入口显示状态
- (void)updateRedEntranceViewShowStatus {
    
    if (GetCore(VersionCore).loadingData) {
        self.redEntranceView.hidden = YES;
        return;
    }
    
    if (GetCore(RoomCoreV2).redList.count > 0) {
        self.redEntranceView.hidden = NO;
    } else {
        self.redEntranceView.hidden = ![self redPacketEnable];
    }
}

#pragma mark - Request
/// 请求红包列表
/// @param completion 完成回调
- (void)requestRedListWithCompletion:(void(^_Nullable)(void))completion {
    @weakify(self)
    NSString *roomUid = @(GetCore(RoomCoreV2).getCurrentRoomInfo.uid).stringValue;
    [GetCore(RoomCoreV2) requestRoomRedList:roomUid completion:^(NSArray<RoomRedListItem *> *data, NSNumber *code, NSString *msg) {

        GetCore(RoomCoreV2).redList = data;
        
        @strongify(self)
        [self onReceiveUpdateRedList];
        
        !completion ?: completion();
    }];
}

/// 红包列表查看红包详情
/// @param packetId 红包ID
- (void)redListQueryRedDetailWithId:(NSString *)packetId {
    @weakify(self)
    [GetCore(RoomCoreV2) requestRoomRedDetail:packetId completion:^(RoomRedDetail * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        @strongify(self)
        [self.redListView showRed:data];
    }];
}

/// 抢红包获取红包详情
/// @param packetId 红包ID
- (void)drawDetailWithPacketId:(NSString *)packetId {
    @weakify(self)
    [GetCore(RoomCoreV2) requestRoomRedDetail:packetId completion:^(RoomRedDetail * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if (code) {
            [XCHUDTool showErrorWithMessage:msg ?: @"请求出现错误"];
            return;
        }
        
        @strongify(self)
        self.redDrawView.model = data;
        
        if (![self.view.superview.subviews containsObject:self.redDrawView]) {
            //将视图加到TTGameRoomContainerController.view
            //解决视图被礼物动效遮挡问题
            [self.view.superview addSubview:self.redDrawView];
            [self.redDrawView showAnimation];
        }
    }];
}

/// 抢红包
/// @param packetId 红包ID
- (void)requestDrawWithPacketId:(NSString *)packetId {
    
    @weakify(self);
    [GetCore(RoomCoreV2) requestRoomRedDraw:packetId completion:^(NSString * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if ([code isEqualToNumber:@23002]) {//不满足条件
            [XCHUDTool showErrorWithMessage:msg];
            [TTStatisticsService trackEvent:@"room_red_paper_failed" eventDescribe:@"不满足条件"];
            return;
        }
        
        if ([code isEqualToNumber:@23108]) {//需要实名认证
            [self userCertifyWithMsg:msg];
            return;
        }
        
        TTRedDrawResultViewType type;
        if (data) {
            type = TTRedDrawResultViewTypeSuccess;
            [TTStatisticsService trackEvent:@"room_red_paper_success" eventDescribe:@"红包_抢红包成功"];
        }  else if ([code isEqualToNumber:@23001]) {
            type = TTRedDrawResultViewTypeSnow;
            [TTStatisticsService trackEvent:@"room_red_paper_failed" eventDescribe:@"手慢了"];
        } else {
            type = TTRedDrawResultViewTypeOver;
            [TTStatisticsService trackEvent:@"room_red_paper_failed" eventDescribe:@"已过期"];
        }
        
        @strongify(self)
        [self showDrawResult:type data:data];
        self.redDrawView.model.alreadyReceive = YES;
    }];
}

#pragma mark - RoomRedClient
/// 收到当前房间发红包的消息
- (void)onReceiveCurrentRoomSendRed {
    //房间内有人发红包，刷新一下列表
    [self requestRedListWithCompletion:nil];
}

/// 红包显示权限修改通知
- (void)onReceiveRedAuthorityChange:(XCRedAuthorityAttachment *)attach {
    if (attach.first == Custom_Noti_Header_Red) {
        if (attach.second == Custom_Noti_Sub_Red_Authority_All ||
            attach.second == Custom_Noti_Sub_Red_Authority_Specific) {
            
            GetCore(RoomCoreV2).hideRedPacket = attach.hideRedPacket;
            [self updateRedEntranceViewShowStatus];
        }
    }
}

#pragma mark - TTRedEntranceViewDelegate
/// 选中红包入口
- (void)didSelectedEntranceView:(TTRedEntranceView *)view {
    
    [TTStatisticsService trackEvent:@"room_red_paper" eventDescribe:@"房间红包入口"];
    
    // 首次显示引导
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:kRedbagGuideStatusStoreKey];
    if (hadGuide) {
        [self showListView];
    } else {
        [ud setBool:YES forKey:kRedbagGuideStatusStoreKey];
        [ud synchronize];

        TTRedBagGuideView *guideView = [[TTRedBagGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        @KWeakify(self);
        guideView.didFinishGuide = ^{
          @KStrongify(self);
          [self showListView];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:guideView];
   }
}

/// 全体注意，开始抢红包了~
/// @param redItem 红包
- (void)entranceView:(TTRedEntranceView *)view startDraw:(RoomRedListItem *)redItem {

    if (GetCore(VersionCore).loadingData) {
        //审核中不弹出抢红包
        return;
    }
    
    [self.view endEditing:YES];
    [self removeRedListView];
    [self drawViewRemoveResultView];
    
    //获取红包详情，调出抢红包界面
    [self drawDetailWithPacketId:redItem.packetId];
}

/// 抢红包结束了~
/// @param redItem 红包
- (void)entranceView:(TTRedEntranceView *)view endDraw:(RoomRedListItem *)redItem {
    
    //倒计时结束时，未领取红包显示过期结果
    [self showDrawResult:TTRedDrawResultViewTypeOver data:@"0"];
    self.redDrawView.model.alreadyReceive = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //抢红包结束，刷新一下列表
        [self requestRedListWithCompletion:nil];
    });
}

#pragma mark - TTRedListViewDelegate
/// 红包列表的操作
- (void)redListView:(TTRedListView *)view didAction:(TTRedListViewAction)action {
    switch (action) {
        case TTRedListViewActionClose:
        {
            [self removeRedListView];
        }
            break;
        case TTRedListViewActionSend:
        {
            [self showSendRedViewIn:self.redListView.bgImageView];
            
            [TTStatisticsService trackEvent:@"room_wanna_give_red_paper" eventDescribe:@"红包_我要发红包"];
        }
            break;
        case TTRedListViewActionRecord:
        {
            [self showRecord];
            
            [TTStatisticsService trackEvent:@"room_red_paper_record" eventDescribe:@"红包_红包记录"];
        }
            break;
        default:
            break;
    }
}

/// 红包关注操作
- (void)redListView:(TTRedListView *)view focus:(RoomRedDetail *)redDetail {
    if ([self isSuperAdmin]) {
        [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
        return;
    }
    
    NSString *mine = [GetCore(AuthCore) getUid];
    UserID toUid = redDetail.requirement==1 ? redDetail.roomUid.userIDValue : redDetail.uid.userIDValue;
    [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:toUid completion:^(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if (success) {
            [TTStatisticsService trackEvent:@"room-focus-on-homeowner" eventDescribe:@"红包条件"];
            [XCHUDTool showSuccessWithMessage:@"关注成功"];
            redDetail.reachRequirement = YES;
            [view showRed:redDetail];//刷新一下
            return;
        }
    }];
}

#pragma mark - TTRedListItemViewDelegate
/// 选中红包
- (void)didSelectedItemView:(TTRedListItemView *)view {
    
//    Android不做这个现在
//    [self redListQueryRedDetailWithId:view.model.packetId];
}

/// 分享红包
- (void)shareItemView:(TTRedListItemView *)view {
    if ([self isSuperAdmin]) {
        [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
        return;
    }
    
    [TTStatisticsService trackEvent:@"room_share_red_paper" eventDescribe:@"红包_分享到公聊大厅"];
    
    [GetCore(RoomCoreV2) requestRoomRedShare:view.model.packetId roomUid:@(GetCore(RoomCoreV2).getCurrentRoomInfo.uid).stringValue completion:^(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if (code) {
            [XCHUDTool showSuccessWithMessage:msg ?: @"分享出错啦"];
            return;
        }
        
        [view hadShareSuccess];
        [XCHUDTool showSuccessWithMessage:@"分享成功"];
    }];
}

#pragma mark - TTRedDrawViewDelegate
/// 抢红包的操作
- (void)redDrawView:(TTRedDrawView *)view didAction:(TTRedDrawViewAction)action {
    switch (action) {
        case TTRedDrawViewActionClose:
        {
            [self removeDrawView];
        }
            break;
        case TTRedDrawViewActionDraw:
        {
            if ([self isSuperAdmin]) {
                [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
                return;
            }
            
            [self requestDrawWithPacketId:view.model.packetId];
        }
            break;
        case TTRedDrawViewActionFocus:
        {
            if ([self isSuperAdmin]) {
                [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
                return;
            }
            
            NSString *mine = [GetCore(AuthCore) getUid];
            UserID toUid = view.model.requirement==1 ? view.model.roomUid.userIDValue : view.model.uid.userIDValue;
            [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:toUid completion:^(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg) {
                
                if (success) {
                    [XCHUDTool showSuccessWithMessage:@"关注成功"];
                    view.model.reachRequirement = YES;
                    view.model = view.model;//刷新一下
                    return;
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private Method
/// 显示发红包界面
- (void)showSendRedViewIn:(UIView *)view {
    if ([self isSuperAdmin]) {
        [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
        return;
    }
    
    if (![self redPacketEnable]) {
        [XCHUDTool showErrorWithMessage:@"已关闭红包功能"];
        return;
    }
    
    @weakify(self)
    [GetCore(RoomCoreV2) requestRoomRedConfigCompletion:^(RoomRedConfig * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if (data == nil) {
            return;
        }
        
        @strongify(self)
        TTSendRedBagView *send = [[TTSendRedBagView alloc] init];
        send.config = data;
        send.sendRedBagSuccessBlock = ^{
            @strongify(self)
            if ([self.view.superview.subviews containsObject:self.redDrawView]) {
                [self removeDrawView];
                [self showListView];
            }
        };
        [view addSubview:send];
        [send mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.mas_equalTo(295);
            make.height.mas_equalTo(385);
        }];
    }];
}

/// 显示红包记录
- (void)showRecord {
    if ([self isSuperAdmin]) {
        [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
        return;
    }
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = HtmlUrlKey(kRedRecordURL);
    [self.navigationController pushViewController:vc animated:YES];
}

/// 显示红包列表页面
- (void)showListView {
    [self.view endEditing:YES];
    
    [TTStatisticsService trackEvent:@"room_red_paper" eventDescribe:@"房间红包入口"];
    
    if ([self isSuperAdmin]) {
        [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
        return;
    }
    
    @weakify(self)
    [self requestRedListWithCompletion:^{
        @strongify(self)
        
        RoomRedListItem *item = GetCore(RoomCoreV2).redList.firstObject;
        if (item.openStatus && !item.alreadyOpen) {
            //当前可领取红包，去抢红包
            [self drawDetailWithPacketId:item.packetId];
            return;
        }
        
        //将视图加到TTGameRoomContainerController.view
        //解决视图被礼物动效遮挡问题
        [self.view.superview addSubview:self.redListView];
        [self.redListView showAnimation];
    }];
}

/// 显示红包结果页面
/// @param type 结果类型
/// @param data 数值
- (void)showDrawResult:(TTRedDrawResultViewType)type data:(NSString *)data {
    
    if (self.redDrawView.model.alreadyReceive) {
        return;
    }
    
    TTRedDrawResultView *result = [[TTRedDrawResultView alloc] initWithType:type data:data];
    [self.redDrawView.bgImageView addSubview:result];
    [self.redDrawView showDrawResultAnimationWithView:result];
    
    @weakify(self);
    result.resultViewBlock = ^(TTRedDrawResultViewAction action) {
        @strongify(self);
        switch (action) {
            case TTRedDrawResultViewActionSend: {
                [self showSendRedViewIn:self.redDrawView.bgImageView];
                
                if (type == TTRedDrawResultViewTypeSuccess) {
                    [TTStatisticsService trackEvent:@"room_wanna_give_one" eventDescribe:@"抢到了"];
                }  else if (type == TTRedDrawResultViewTypeSnow) {
                    [TTStatisticsService trackEvent:@"room_wanna_give_one" eventDescribe:@"手慢了"];
                } else {
                    [TTStatisticsService trackEvent:@"room_wanna_give_one" eventDescribe:@"已过期"];
                }
            }
                break;
             case TTRedDrawResultViewActionRecord:
                [self showRecord];
                break;
            default:
                break;
        }
    };
    
    [result mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.redDrawView);
        make.width.equalTo(@295);
        make.height.equalTo(@385);
    }];
}

/// 抢红包移除结果详情
- (void)drawViewRemoveResultView {
    for (UIView *subview in self.redDrawView.bgImageView.subviews) {
        if ([subview isKindOfClass:TTRedDrawResultView.class] ||
            [subview isKindOfClass:TTSendRedBagView.class]) {
            
            [subview removeFromSuperview];
        }
    }
}

/// 移除抢红包页面
- (void)removeDrawView {
    [self.redDrawView removeFromSuperview];
    [self drawViewRemoveResultView];
}

/// 移除红包列表
- (void)removeRedListView {
    [self.redListView removeFromSuperview];
    for (UIView *subview in self.redListView.bgImageView.subviews) {
        if ([subview isKindOfClass:TTSendRedBagView.class]) {
            [subview removeFromSuperview];
        }
    }
}

/// 红包是否可用
- (BOOL)redPacketEnable {
    BOOL platfEnable = !GetCore(RoomCoreV2).hideRedPacket;//平台设置
    BOOL roomEnable = !self.roomInfo.closeRedPacket;//房间设置
    BOOL audit = GetCore(VersionCore).loadingData;//审核中
    BOOL enable = platfEnable && roomEnable && !audit;
    return enable;
}

/// 红包列表更新
- (void)onReceiveUpdateRedList {
    //更新红包入口显示状态
    [self updateRedEntranceViewShowStatus];
    //更新红包入口数据
    [self.redEntranceView updateCountdownWithRedItem:GetCore(RoomCoreV2).redList.firstObject];
    //更新红包列表
    self.redListView.dataArray = GetCore(RoomCoreV2).redList;
    
    if (GetCore(RoomCoreV2).redList.count > 0) {
        //查看第一个红包详情
        [self redListQueryRedDetailWithId:GetCore(RoomCoreV2).redList.firstObject.packetId];
    }
}

//实名认证
- (void)userCertifyWithMsg:(NSString *)msg {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = msg;
    config.messageLineSpacing = 4;
    config.confirmButtonConfig.title = @"前往认证";
    config.confirmButtonConfig.titleColor = UIColor.whiteColor;
    config.confirmButtonConfig.backgroundColor = [XCTheme getTTMainColor];
    
    TTAlertMessageAttributedConfig *nameAttrConf = [[TTAlertMessageAttributedConfig alloc] init];
    nameAttrConf.text = @"实名认证";
    nameAttrConf.color = [XCTheme getTTMainColor];
    config.messageAttributedConfig = @[nameAttrConf];
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kIdentityURL), GetCore(AuthCore).getUid];
        [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:web animated:YES];

    } cancelHandler:^{
    }];
}

@end
