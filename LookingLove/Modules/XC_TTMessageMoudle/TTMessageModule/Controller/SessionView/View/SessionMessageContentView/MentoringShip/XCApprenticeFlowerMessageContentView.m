//
//  XCApprenticeFlowerMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCApprenticeFlowerMessageContentView.h"
#import "TTApprenticeFlowerView.h"
#import "UIView+NIM.h"

#import "MentoringShipCore.h"
#import "Attachment.h"
#import "XCMentoringShipAttachment.h"
#import "UserCore.h"
#import "ImMessageCore.h"

#import "TTSendGiftView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "XCCurrentVCStackManager.h"
//birdge
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCTheme.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

@interface XCApprenticeFlowerMessageContentView ()<TTSendGiftViewDelegate>


@property (nonatomic, strong) TTApprenticeFlowerView * apprenticeFlowerView;

@property (nonatomic, strong) NIMMessage * message;

@property (nonatomic, strong) XCMentoringShipAttachment * apprenticeFlowerAttach;
@end

@implementation XCApprenticeFlowerMessageContentView

- (id)initSessionMessageContentView{
    if (self= [super initSessionMessageContentView]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.apprenticeFlowerView];
    //答谢
     @KWeakify(self);
    self.apprenticeFlowerView.thanksButtonDidClickBlcok = ^{
        @KStrongify(self);
        [self apprenticeThankMaster];
    };
    //回赠
    self.apprenticeFlowerView.rewardButtonDidClickBlcok = ^{
        @KStrongify(self);
        [self apprenticeSendGiftToMaster];
    };
}


- (void)refresh:(NIMMessageModel *)data{
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Apprentice) {
            self.message = data.message;
            if (data.message.localExt) {
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                self.apprenticeFlowerAttach = mentoringAtttach;
                self.apprenticeFlowerView.appenticeFlowerAttach = mentoringAtttach;
            }else{
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                self.apprenticeFlowerAttach = mentoringAtttach;
                self.apprenticeFlowerView.appenticeFlowerAttach = mentoringAtttach;
            }
        }
    }
}

- (void)layoutSubviews{
    self.apprenticeFlowerView.nim_top = self.nim_top;
    self.apprenticeFlowerView.nim_left = 0;
    self.apprenticeFlowerView.nim_size = self.nim_size;
}

- (void)apprenticeThankMaster{
    //更新本地的消息
    self.apprenticeFlowerAttach.apprenticeThank = YES;
    self.message.localExt = @{@"data":[self.apprenticeFlowerAttach model2dictionary]};
    [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
    
    //自动发送一句话 给师傅
    NSString * message = self.apprenticeFlowerAttach.message && self.apprenticeFlowerAttach.message.length > 0 ? self.apprenticeFlowerAttach.message : @"谢谢你的礼物，我超喜欢的~~";
    [GetCore(ImMessageCore) sendTextMessage:message nick:nil sessionId:[NSString stringWithFormat:@"%lld", self.apprenticeFlowerAttach.masterUid] type:NIMSessionTypeP2P];
}

- (void)apprenticeSendGiftToMaster{
    
    UserInfo *  targetInfor=  [GetCore(UserCore) getUserInfoInDB:self.apprenticeFlowerAttach.masterUid];
    TTSendGiftView *giftView = [[TTSendGiftView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) usingPlace:XCSendGiftViewUsingPlace_Message roomUid:0];
    giftView.delegate = self;
    giftView.targetInfo = targetInfor;
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = giftView;
    config.style = TTPopupStyleActionSheet;
    config.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
        [IQKeyboardManager sharedManager].enable = NO;
    };
    config.didFinishShowingHandler = ^{
        
        [IQKeyboardManager sharedManager].enable = YES;
        if (iPhoneX) {
            [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 40;
        }
    };
    
    [TTPopup popupWithConfig:config];
}



#pragma mark - XCSendGiftViewDelegate
//关闭
- (void)sendGiftViewDidClose:(TTSendGiftView *)sendGiftView {
    [TTPopup dismiss];
}

//充值
- (void)sendGiftViewDidClickRecharge:(TTSendGiftView *)sendGiftView type:(GiftConsumeType)type {
    [TTPopup dismiss];
    
    if (type == GiftConsumeTypeCarrot) {
        // 跳转去做任务。
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    // 之前的是跳去充值
    
    UIViewController *rechargeVc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
    [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:rechargeVc animated:YES];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventGiftViewToRecharge eventDescribe:@"礼物面板-充值"];
    // 首次充值资格
    if (sendGiftView.isFirstRecharge) {
        [TTStatisticsService trackEvent:@"room_gift_oneyuan_entrance" eventDescribe:@"群聊"];
    }
}

// 萝卜不足，去做任务
- (void)sendGiftView:(TTSendGiftView *)sendGiftView notEnoughtCarrot:(NSString *)errorMsg {
    // 跳转去任务
    [self ttShowCarrotBalanceNotEnougth];
}

/** 萝卜钱包余额不足 */
- (void)ttShowCarrotBalanceNotEnougth {
    [TTPopup dismiss];
    
    //防止多次萝卜不足弹窗
    static BOOL hasShowRadishAlert = NO;
    if (hasShowRadishAlert) {
        return;
    }
    
    hasShowRadishAlert = YES;
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = @"完成任务获取更多的萝卜";
    attConfig.color = [XCTheme getTTMainColor];

    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"您的萝卜不足,请前往任务中心\n完成任务获取更多的萝卜";
    config.confirmButtonConfig.title = @"前往";
    config.messageAttributedConfig = @[attConfig];
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        
        hasShowRadishAlert = NO;
        
    } cancelHandler:^{
        hasShowRadishAlert = NO;
    }];
}


- (TTApprenticeFlowerView *)apprenticeFlowerView{
    if (!_apprenticeFlowerView) {
        _apprenticeFlowerView = [[TTApprenticeFlowerView alloc] init];
    }
    return _apprenticeFlowerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
