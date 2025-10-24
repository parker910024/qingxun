//
//  TTSendGiftView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftView.h"

#import "TTSendGiftAvatarView.h"
#import "TTSendGiftSegmentView.h"
#import "TTSendGiftMiddleView.h"
#import "TTSendGiftBottomView.h"
#import "TTSendGiftCustomCountView.h"
#import "TTGiftCountContainerView.h"

#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "RoomMagicInfo.h"
#import "GiftCore.h"
#import "ImRoomCoreV2.h"
#import "RoomMagicCore.h"
#import "RoomInfo.h"
#import "ImPublicChatroomCore.h"
#import "LittleWorldCore.h"

#import "TTSendGiftViewConfig.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "UIView+NTES.h"
#import "TTSendGiftTipsView.h"


@interface TTSendGiftView ()<PurseCoreClient, TTSendGiftBottomViewDelegate, TTSendGiftAvatarViewDelegate, TTSendGiftSegmentViewDelegate, TTSendGiftMiddleViewDelegate, TTGiftCountContainerViewDelegate, TTSendGiftCustomCountViewDelegate>
/** 关闭手势view */
@property (nonatomic, strong) UIView *closeTapView;
/** 内容view */
@property (nonatomic, strong) UIView *giftContianterView;
/** 麦位view */
@property (nonatomic, strong) TTSendGiftAvatarView *avatarView;
/** 菜单view */
@property (nonatomic, strong) TTSendGiftSegmentView *segmentView;
/** 礼物面板view */
@property (nonatomic, strong) TTSendGiftMiddleView *middleView;
/** 底部view */
@property (nonatomic, strong) TTSendGiftBottomView *bottomView;
/** 自定义送礼数的编辑的view */
@property (nonatomic, strong) TTSendGiftCustomCountView *customCountEditView;
/** 数量选择面板 */
@property (nonatomic, strong) TTGiftCountContainerView *giftCountContainerView;

/** 金币钱包 */
@property (nonatomic, strong) BalanceInfo *balanceInfo;
/** 萝卜钱包 */
@property (nonatomic, strong) CarrotWallet *carrotWallet;
/** 房间礼物面板时, 房间uid */
@property (nonatomic, assign) NSInteger roomUid;
/// 盲盒礼物被选中时候，展示的特效
@property (nonatomic, strong) TTSendGiftTipsView *giftTipsView;
@end

@implementation TTSendGiftView

#pragma mark - life cycle

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
                   usingPlace:(XCSendGiftViewUsingPlace)usingPlace
                      roomUid:(NSInteger)roomUid {
    if (self = [super initWithFrame:frame]) {
        
        if (usingPlace == XCSendGiftViewUsingPlace_PublcChat) {
            self.roomUid = GetCore(ImPublicChatroomCore).publicChatroomUid;
        } else {
            self.roomUid = roomUid;
        }
        self.usingPlace = usingPlace;
        self.currentType = SelectGiftType_gift;
        
        [self initView];
        [self initConstrations];
        [self addCore];
        [self addNotificationCenter];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.giftContianterView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.giftContianterView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.giftContianterView.layer.mask = maskLayer;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - TTSendGiftSegmentViewDelegate
/**
 点击了成为贵族按钮
 
 @param segmentView segmentView
 @param button 成为贵族按钮
 */
- (void)sendGiftSegmentView:(TTSendGiftSegmentView *)segmentView didClickBecomeNobeButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(sendGiftViewDidClickBecomeNobe:)]) {
        [self.delegate sendGiftViewDidClickBecomeNobe:self];
    }
}

- (void)sendGiftSegmentView:(TTSendGiftSegmentView *)segmentView didClickFirstRechargeButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftViewDidClickRecharge:type:)]) {
        [self.delegate sendGiftViewDidClickRecharge:self type:GiftConsumeTypeCoin];
    }
}
/**
 点击了菜单栏
 
 @param segmentView segmentView
 @param item 菜单栏模型
 @param type 菜单的类型
 */
- (void)sendGiftSegmentView:(TTSendGiftSegmentView *)segmentView didClickSegmentItem:(TTSendGiftSegmentItem *)item SelectGiftType:(SelectGiftType)type {
    self.currentType = type;
    
    if (type == SelectGiftType_magic) {
        self.giftCountContainerView.hidden = YES;
        [self.bottomView updateArrowImage:NO];
    }
}

#pragma mark - TTSendGiftAvatarViewDelegate
/**
 点击了资料按钮 (公聊)
 
 @param avatarView avatarView
 @param button 资料按钮
 */
- (void)sendGiftAvatarView:(TTSendGiftAvatarView *)avatarView didClickUserInfoButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(sendGiftView:showUserInfoCardWithUid:)]) {
        [self.delegate sendGiftView:self showUserInfoCardWithUid:self.targetInfo.uid];
    }
}

/**
 点击了举报按钮 (公聊)
 
 @param avatarView avatarView
 @param button 举报按钮
 */
- (void)sendGiftAvatarView:(TTSendGiftAvatarView *)avatarView didClickReportButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(sendGiftViewDidClickReport:)]) {
        [self.delegate sendGiftViewDidClickReport:self];
    }
}

#pragma mark - TTSendGiftBottomViewDelegate
- (void)sendGiftBottomView:(TTSendGiftBottomView *)bottomView didClickRechargeButton:(UIButton *)button type:(GiftConsumeType)type; {
    if ([self.delegate respondsToSelector:@selector(sendGiftViewDidClickRecharge:type:)]) {
        [self.delegate sendGiftViewDidClickRecharge:self type:type];
    }
}

/**
 选择礼物数量按钮的点击
 
 @param bottomView bottomView
 @param button 选择礼物数量按钮
 */
- (void)sendGiftBottomView:(TTSendGiftBottomView *)bottomView didClickSelectCountBtn:(UIButton *)button {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         
                         self.giftCountContainerView.hidden = !self.giftCountContainerView.isHidden;
                         [self.bottomView updateArrowImage:!self.giftCountContainerView.hidden];
                     } completion:nil];
}

/**
 送礼按钮的点击
 
 @param bottomView bottomView
 @param button 送礼按钮
 */
- (void)sendGiftBottomView:(TTSendGiftBottomView *)bottomView didClickSendButton:(UIButton *)button {
    [self tutuSendButtonClick:button];
}

- (void)tutuSendButtonClick:(UIButton *)sender {
    [[BaiduMobStat defaultStat] logEvent:@"roomcp_gift_send_click" eventLabel:@"礼物赠送按钮"];
    
    GiftInfo *info;
    RoomMagicInfo *magicInfo;
    if (self.currentType == SelectGiftType_gift) {
        info = self.middleView.lastSelectGiftInfo;
    } else if (self.currentType == SelectGiftType_magic) {
        magicInfo = self.middleView.lastSelectMagicInfo;
    } else if (self.currentType == SelectGiftType_giftPackage) {
        info = self.middleView.lastSelectPackInfo;
    } else if (self.currentType == SelectGiftType_nobleGift) {
        info = self.middleView.lastSelectNobleInfo;
        UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
        UserInfo *myUserInfo = [GetCore(UserCore) getUserInfoInDB:myUid];
        if (myUserInfo.nobleUsers.level < self.middleView.lastSelectNobleInfo.nobleId) {
            if ([self.delegate respondsToSelector:@selector(sendGiftView:currentNobleLevel:needNobelLevel:)]) {
                [self.delegate sendGiftView:self currentNobleLevel:(int)myUserInfo.nobleUsers.level needNobelLevel:self.middleView.lastSelectNobleInfo.nobleId];
            }
            return;
        }
    }
    
    if (info == nil && magicInfo == nil) {
        [self.middleView.collectionView reloadData];
        return;
    }
    
    NSString *msg = @"";
    if (info.isSendMsg) {
        msg = self.middleView.msgTextField.text.length > 0 ? self.middleView.msgTextField.text : [TTSendGiftViewConfig globalConfig].room_gift_sendMsg_default;
        msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (msg.length <= 0) {
            [XCHUDTool showErrorWithMessage:@"请输入合法内容"];
            return;
        }
    }
    
    NSString *uids = [[NSString alloc] init];
    NSInteger microCount = 1;
    NSInteger giftNum = [self.bottomView.selectedCountLabel.text integerValue];
    GameRoomGiftType gameGiftType = GameRoomGiftType_Normal;
    GameRoomSendType gameRoomSendType = GameRoomSendType_OnMic;
    GameRoomSendGiftType gameRoomSendGiftType = GameRoomSendGiftType_ToOne;
    NSInteger roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    
    if (self.usingPlace == XCSendGiftViewUsingPlace_Room) {
        gameRoomSendType = GameRoomSendType_OnMic;
        
        NSInteger micCount = 0;
        if (self.avatarView.selectedUids.count > 0) {
            for (NSString *item in self.avatarView.selectedUids) {
                if (uids.length > 0) {
                    uids = [uids stringByAppendingString:@","];
                }
                if (![item isEqualToString:[GetCore(AuthCore) getUid]]) {
                    uids = [uids stringByAppendingString:item];
                    micCount++;
                }
            }
            microCount = micCount;
            
            if (self.avatarView.isAllMicroSend) {
                gameRoomSendGiftType = GameRoomSendGiftType_AllMic;
            } else if (self.avatarView.selectedUids.count > 1) {
                gameRoomSendGiftType = GameRoomSendGiftType_MutableOnMic;
            } else if (self.avatarView.selectedUids.count == 0 && self.avatarView.microArray.count == 0) { // 没人
                [XCHUDTool showErrorWithMessage:@"请选择至少一个人"];
                [self.middleView.msgTextField resignFirstResponder];
                return;
            } else if (self.avatarView.selectedUids.firstObject.userIDValue != [GetCore(AuthCore) getUid].userIDValue) { // 单人, 非自己
                gameRoomSendGiftType = GameRoomSendGiftType_ToOne;
            } else {
                [XCHUDTool showErrorWithMessage:@"当前没有可以接收礼物的人"];
                [self.middleView.msgTextField resignFirstResponder];
                return;
            }
        } else {
            [XCHUDTool showErrorWithMessage:@"当前没有可以接收礼物的人"];
            [self.middleView.msgTextField resignFirstResponder];
            return;
        }
    } else if (self.usingPlace == XCSendGiftViewUsingPlace_Message) {
        gameRoomSendType = GameRoomSendType_Chat;
        uids = [NSString stringWithFormat:@"%lld", self.targetInfo.uid];
        gameRoomSendGiftType = GameRoomSendGiftType_ToOne;
        roomUid = 0;
        microCount = 1;
    } else if (self.usingPlace == XCSendGiftViewUsingPlace_PublcChat) {
        gameRoomSendType = GameRoomSendType_PublicChat;
        uids = [NSString stringWithFormat:@"%lld", self.targetInfo.uid];
        gameRoomSendGiftType = GameRoomSendGiftType_ToOne;
        roomUid = 0;
        microCount = 1;
    }else if (self.usingPlace == XCSendGiftViewUsingPlace_Team) {
        gameRoomSendType = GameRoomSendType_Team;
        uids = [NSString stringWithFormat:@"%lld", self.targetInfo.uid];
        gameRoomSendGiftType = GameRoomSendGiftType_ToOne;
        roomUid = 0;
        microCount = 1;
    }
    
    if (self.currentType == SelectGiftType_gift) {
        gameGiftType = GameRoomGiftType_Normal;
    } else if (self.currentType == SelectGiftType_magic) {//魔法
        
        [GetCore(RoomMagicCore) sendBatchMagicByUids:uids magicId:magicInfo.magicId roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid gameRoomSendGiftType:gameRoomSendGiftType];
        [self.middleView.msgTextField resignFirstResponder];
        self.middleView.msgTextField.text = nil;
        return;
    } else if (self.currentType == SelectGiftType_giftPackage) {//背包礼物
        gameGiftType = GameRoomGiftType_GiftPack;
    } else if (self.currentType == SelectGiftType_nobleGift) {//贵族礼物
        gameGiftType = GameRoomGiftType_Noble;
    }
    
    if (self.usingPlace == XCSendGiftViewUsingPlace_Team) {
        [GetCore(GiftCore) sendGiftByUids:uids microCount:microCount giftInfo:info gameGiftType:gameGiftType gameRoomSendType:gameRoomSendType gameRoomSendGiftType:gameRoomSendGiftType giftNum:giftNum roomUid:roomUid msg:msg sessionId:self.sessionId];
    }else {
         [GetCore(GiftCore) sendGiftByUids:uids microCount:microCount giftInfo:info gameGiftType:gameGiftType gameRoomSendType:gameRoomSendType gameRoomSendGiftType:gameRoomSendGiftType giftNum:giftNum roomUid:roomUid msg:msg];
    }

    [self.middleView.msgTextField resignFirstResponder];
    self.middleView.msgTextField.text = nil;
    
    // 统计小世界群聊送礼
    [GetCore(LittleWorldCore) reportWorldMemberoActiveType:2 reportUid:GetCore(AuthCore).getUid.userIDValue worldId:GetCore(LittleWorldCore).reportWorldID];
}

#pragma mark - TTSendGiftMiddleViewDelegate
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView currentNobleLevel:(NSInteger)currentLevel needNobelLevel:(NSInteger)needLevel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftView:currentNobleLevel:needNobelLevel:)]) {
        [self.delegate sendGiftView:self currentNobleLevel:currentLevel needNobelLevel:needLevel];
    }
}

/**
 展示和隐藏喊话的输入框 时的回调, 外界更新高度
 
 @param sendGiftMiddleView self
 @param isShow yes:展示 no:隐藏
 */
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView layoutMsgTextField:(BOOL)isShow {
    if (!_giftContianterView) {
        return;
    }
    
    if (isShow) {
        [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.segmentView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(218 + 35);
        }];
        
        [self.giftContianterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(353 + kSafeAreaBottomHeight + 35);
        }];
    } else {
        [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.segmentView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(218);
        }];
        
        [self.giftContianterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(353 + kSafeAreaBottomHeight);
        }];
    }
    
    [self layoutIfNeeded];
}

/**
 选中了礼物 时的回调
 
 @param sendGiftMiddleView self
 @param gift 礼物模型 可能是魔法模型 or 礼物模型
 */
- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView didSelectGift:(id)gift {
    [self.bottomView updateBottomViewInfo:gift];
    
    // 根据礼物信息中的tpis字段处理当前选中的礼物，是否需要显示顶部的tipsView(魔法礼物除外)
    if ([gift isKindOfClass:[GiftInfo class]]) {
        GiftInfo *giftItem = (GiftInfo *)gift;
        self.giftTipsView.giftInfo = giftItem;
        self.giftTipsView.hidden = !giftItem.tips;
        
        // 如果是盲盒礼物，上一个礼物打开的数量选择框，需要关闭。
        if (giftItem.consumeType == GiftConsumeTypeBox && !self.giftCountContainerView.isHidden) {
            self.giftCountContainerView.hidden = YES;
        }
        
    } else {
        self.giftTipsView.hidden = YES;
    }
}

- (void)sendGiftMiddleView:(TTSendGiftMiddleView *)sendGiftMiddleView notEnoughtCarrot:(NSString *)errorMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftView:notEnoughtCarrot:)]) {
        [self.delegate sendGiftView:self notEnoughtCarrot:errorMsg];
    }
}

#pragma mark - TTGiftCountContainerViewDelegate
- (void)giftCountContainerView:(TTGiftCountContainerView *)countView didSelectItem:(TTSendGiftCountItem *)countItem {
    if (countItem.isCustomCount) {
        countItem.giftCount = @"";
        // 弹起输入框
        self.customCountEditView.hidden = NO;
        [self.customCountEditView.editTextFiled becomeFirstResponder];
    }
    [self.bottomView updateGiftCountWithItem:countItem];
}

#pragma mark - TTSendGiftCustomCountViewDelegate
- (void)sendGiftCustomCountView:(TTSendGiftCustomCountView *)countView didClickSureButton:(UIButton *)button {
    NSString *countStr = [self.customCountEditView.editTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger count = [countStr integerValue];
    if (countStr.length == 0 || count == 0) {
        count = 1;
    } else if (count > 9999) {
        [XCHUDTool showErrorWithMessage:@"礼物数最多9999"];
        return;
    }
    [self.customCountEditView.editTextFiled resignFirstResponder];
    self.customCountEditView.editTextFiled.text = @"";
    
    self.bottomView.selectedCountLabel.text = [NSString stringWithFormat:@"%ld", count];
}

#pragma mark - PurseCoreClient
// 钱包更新
- (void)onBalanceInfoUpdate:(BalanceInfo *)balanceInfo {
    self.balanceInfo = balanceInfo;
    self.bottomView.balanceInfo = balanceInfo;
}

// 萝卜
- (void)getCarrotNum:(CarrotWallet *)carrotWallet code:(NSNumber *)code message:(NSString *)message {
    self.carrotWallet = carrotWallet;
    self.bottomView.carrotWallet = carrotWallet;
}

// 是否首次充值
- (void)requestUserIsFirstRecharge:(BOOL)isFirst code:(NSNumber *)code message:(NSString *)message {
//    ture:首次充值，false:非首次充值
    [self.segmentView updateFirstRechargeButtonLayout:isFirst];
    self.isFirstRecharge = isFirst;
}

// 内购成功
- (void)entryCheckReceiptSuccess {
    if (_segmentView) {
        // 内购成功后更新一元首冲按钮
        [_segmentView updateFirstRechargeButtonLayout:NO];
    }
}

#pragma mark - event response
- (void)closeSendGiftView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftViewDidClose:)]) {
        [self.delegate sendGiftViewDidClose:self];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = CGRectGetMinY(keyboardRect) - KScreenHeight;
    
    if (height < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.top = height;
        }];
    }
}

//键盘隐藏
- (void)keyboardWillHidden:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.top = 0;
    }];
    self.customCountEditView.hidden = YES;
    self.customCountEditView.editTextFiled.text = @"";
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:KTTInputViewBecomeFirstResponder object:self.customCountEditView.editTextFiled];
}

#pragma mark - private method

- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}



- (void)addCore {
    AddCoreClient(PurseCoreClient, self); // 监听钱包的更新
    
    // 请求我的金币 和 萝卜币
    UserID myUid = [GetCore(AuthCore)getUid].userIDValue;
    [GetCore(PurseCore) requestBalanceInfo:myUid];
    [GetCore(PurseCore) requestCarrotWalletWithType:1]; // 萝卜数量
    [GetCore(PurseCore) requestUserIsFirstRecharge]; // 是否是第一次充值
}

- (void)initView {
    [self addSubview:self.closeTapView];
    [self addSubview:self.giftContianterView];
    [self addSubview:self.giftTipsView];
    
    [self.giftContianterView addSubview:self.avatarView];
    [self.giftContianterView addSubview:self.segmentView];
    [self.giftContianterView addSubview:self.middleView];
    [self.giftContianterView addSubview:self.bottomView];
    [self addSubview:self.customCountEditView];
    [self.giftContianterView addSubview:self.giftCountContainerView];
}

- (void)initConstrations {
    
    CGFloat topViewHeight = 55.0f;
    CGFloat segmentViewHeight = 36.0f;
    CGFloat middleViewHeight = 218.0f;
    CGFloat bottomViewHeight = 44.0f;
    
    if (@available(iOS 11.0, *)) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self.giftContianterView insertSubview:effectView atIndex:0];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.giftContianterView );
        }];
    } else {
        self.giftContianterView.backgroundColor = RGBACOLOR(12, 11, 13, 0.9);
    }
    
    [self.closeTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self.giftContianterView.mas_top);
    }];
    
    [self.giftTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.giftContianterView.mas_top).offset(10);
        make.height.mas_equalTo(80);
        make.left.right.mas_equalTo(self);
    }];
    
    [self.giftContianterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(topViewHeight + segmentViewHeight + middleViewHeight + bottomViewHeight + kSafeAreaBottomHeight);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(topViewHeight);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarView.mas_bottom);
        make.height.mas_equalTo(segmentViewHeight);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(middleViewHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.middleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    
    [self.customCountEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    [self.giftCountContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-6);
        make.height.mas_equalTo(231);
        make.width.mas_equalTo(135);
    }];
}

#pragma mark - getters and setters
- (void)setCurrentType:(SelectGiftType)currentType {
    _currentType = currentType;
    
    self.middleView.currentType = currentType;
    self.bottomView.currentType = currentType;
}

- (void)setUsingPlace:(XCSendGiftViewUsingPlace)usingPlace {
    _usingPlace = usingPlace;
    
    self.avatarView.usingPlace = usingPlace;
    self.segmentView.usingPlace = usingPlace;
}

- (void)setTargetInfo:(UserInfo *)targetInfo {
    _targetInfo = targetInfo;
    
    self.avatarView.targetInfo = targetInfo;
}

- (UIView *)closeTapView {
    if (!_closeTapView){
        _closeTapView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSendGiftView)];
        [_closeTapView addGestureRecognizer:tap];
    }
    return _closeTapView;
}

- (UIView *)giftContianterView {
    if (!_giftContianterView) {
        _giftContianterView = [[UIView alloc] init];
    }
    return _giftContianterView;
}

- (TTSendGiftAvatarView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[TTSendGiftAvatarView alloc] init];
        _avatarView.delegate = self;
    }
    return _avatarView;
}

- (TTSendGiftSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TTSendGiftSegmentView alloc] init];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (TTSendGiftMiddleView *)middleView {
    if (!_middleView) {
        _middleView = [[TTSendGiftMiddleView alloc] initWithRoomUid:self.roomUid];
        _middleView.delegate = self;
        _middleView.usingPlace = self.usingPlace;
    }
    return _middleView;
}

- (TTSendGiftBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TTSendGiftBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (TTSendGiftCustomCountView *)customCountEditView {
    if (!_customCountEditView) {
        _customCountEditView = [[TTSendGiftCustomCountView alloc] init];
        _customCountEditView.hidden = YES;
        _customCountEditView.delegate = self;
    }
    return _customCountEditView;
}

- (TTGiftCountContainerView *)giftCountContainerView {
    if (!_giftCountContainerView) {
        _giftCountContainerView = [[TTGiftCountContainerView alloc] init];
        _giftCountContainerView.delegate = self;
        _giftCountContainerView.hidden = YES;
    }
    return _giftCountContainerView;
}

- (TTSendGiftTipsView *)giftTipsView {
    if (!_giftTipsView) {
        _giftTipsView = [[TTSendGiftTipsView alloc] init];
        _giftTipsView.hidden = YES;
    }
    return _giftTipsView;
}

@end
