//
//  TTMessageView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"
#import "TTRoomModuleCenter.h"
//core
#import "UserCar.h"
#import "MeetingCore.h"
#import "BalanceErrorClient.h"
#import "ShareSendInfo.h"
#import "NobleBroadcastInfo.h"
#import "NobleCore.h"
#import "NobleSourceInfo.h"
#import "TTPopup.h"

//tool
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import <SDImageCache.h>
#import "TTMessageStrategies.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>
#import <YYAnimatedImageView.h>

//Category
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTMessageView+RoomNotification.h"
#import "TTMessageView+RoomFace.h"
#import "TTMessageView+TextMessage.h"
#import "TTMessageView+RoomNoble.h"

@interface TTMessageView ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
RoomCoreClient,
ImRoomCoreClient,
BalanceErrorClient
>

@property(nonatomic, strong)RoomInfo *roomInfo;

@property (nonatomic, assign) BOOL _isForbiddenRefreshChannelTableView;
@property (nonatomic, assign) BOOL currentIsInBottom;

@property (nonatomic, strong) NSMutableArray *canRemoveMessageArray;
@property (nonatomic, copy) NSString *currentMsgId;

@property (nonatomic, strong) UIButton *messagTipsBtn;

@property (nonatomic, strong) UIView *gradientBgView;//背景渐变

@property (strong, nonatomic) NSCache *heightCache;
@end


@implementation TTMessageView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [TTMessageContentProvider shareProvider];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self initConstrations];
}


- (void)dealloc {
    RemoveCoreClientAll(self);
}


#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    CGFloat height = aScrollView.frame.size.height;
    CGFloat contentOffsetY = aScrollView.contentOffset.y;
    CGFloat bottomOffset = aScrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height){
        self.currentIsInBottom = YES;
    }else{
        self.currentIsInBottom = NO;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollTableViewMessageListToBottoWithAnimated:) object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.currentIsInBottom) {
        self.messagTipsBtn.hidden = YES;
        [self reloadChatList:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollTableViewMessageListToBottoWithAnimated:) object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.currentIsInBottom) {
        self.messagTipsBtn.hidden = YES;
        [self reloadChatList:YES];
    }
}


#pragma mark - UITableViewDataSource

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    TTMessageDisplayModel *message = (TTMessageDisplayModel *)[self.messages safeObjectAtIndex:indexPath.row];
//    NSString *msgId = message.message.messageId;
//    [self.heightCache setObject:@(cell.frame.size.height) forKey:msgId];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TTMessageDisplayModel *message = (TTMessageDisplayModel *)[self.messages safeObjectAtIndex:indexPath.row];
//    NSString *msgId = message.message.messageId;
//    CGFloat height = [[self.heightCache objectForKey:msgId] floatValue];
//    return height == 0 ? 50 : height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    TTMessageDisplayModel *model = [self.messages safeObjectAtIndex:indexPath.row];

    TTMessageCell *cell = [TTMessageTextCell cellWithTableView:tableView];
    [(TTMessageTextCell *)cell messageLabel].preferredMaxLayoutWidth = tableView.frame.size.width - 30;
    if (model.message.messageType == NIMMessageTypeText) { //文字信息
        
        @KWeakify(self);
        [self handleTextCell:(TTMessageTextCell *)cell model:model textMessageBlock:^(UserID uid) {
            @KStrongify(self);
            [self didClickTextMessageCellWith:uid];
        }];
        
    } else if (model.message.messageType == NIMMessageTypeNotification){ //notiface
        
        @KWeakify(self);
        [self handleNotificationCell:(TTMessageTextCell *)cell model:model notificationBlock:^(NIMMessage *message) {
            @KStrongify(self);
            [self didClickNotificationMessageCellWith:message];
        }];
        
    } else if (model.message.messageType == NIMMessageTypeCustom) { // custom
        
        NIMCustomObject *obj = (NIMCustomObject *)model.message.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        
        if (attachment.first == Custom_Noti_Header_Face) {

            if (attachment.second == Custom_Noti_Sub_Face_Send) {
                
                cell = [TTMessageFaceCell cellWithTableView:tableView];
                [(TTMessageFaceCell *)cell messageLabel].preferredMaxLayoutWidth = tableView.frame.size.width - 15;
                [self handleFaceCell:(TTMessageFaceCell *)cell model:model];
                
            }
        }else if (attachment.first == Custom_Noti_Header_NobleNotify) {//noble
            if (attachment.second == Custom_Noti_Sub_NobleNotify_Renew_Success || attachment.second == Custom_Noti_Sub_NobleNotify_Open_Success) {
                [self handleNobleCell:(TTMessageTextCell *)cell model:model];
            }
        }else{
            NSInvocation *strategy = [[TTMessageStrategies defaultStrategy] strategyByMessageHeader:attachment.first target:self cell:(TTMessageTextCell *)cell model:model];
            [strategy invoke];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.messages safeObjectAtIndex:indexPath.row]) {
        return ((TTMessageDisplayModel *)[self.messages safeObjectAtIndex:indexPath.row]).contentHeight;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    NIMMessage *msg = [self.messages objectAtIndex:indexPath.row];
    if (!msg) {
        return;
    }
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    if (msg.messageType == NIMMessageTypeText) {//text

        if (myUid != msg.from.userIDValue) {
            if (myUid == self.roomInfo.uid) { //房主
                [self showMsgRoomOwnerOperation:msg.from.userIDValue];
            } else if(myMember.type == NIMChatroomMemberTypeManager) {//管理
                [self showMsgRoomOwnerOperation:msg.from.userIDValue];
            }else {
                [self showPersonalView:msg.from.userIDValue];
            }
        }else{
            [self showPersonalView:myUid];
        }
    }else if (msg.messageType == NIMMessageTypeNotification) {//notification
    
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)msg.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeEnter) {//enter room
            NIMChatroomNotificationMember *member = content.targets[0];
            if (myUid != member.userId.userIDValue) {
                if (myMember.type == NIMChatroomMemberTypeCreator) {
                    [self showMsgRoomOwnerOperation:msg.from.userIDValue];
                } else if(myMember.type == NIMChatroomMemberTypeManager) {
                    [self showMsgRoomOwnerOperation:msg.from.userIDValue];
                }else {
                    [self showPersonalView:msg.from.userIDValue];
                }
            }else {
                [self showPersonalView:msg.from.userIDValue];
            }
        }
    }else if (msg.messageType == NIMMessageTypeCustom){
        
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        if (customObject.attachment) {
            Attachment *attachment = (Attachment *)customObject.attachment;
            if (attachment.first == Custom_Noti_Header_Gift ||
                attachment.first == Custom_Noti_Header_RoomMagic ||
                attachment.first == Custom_Noti_Header_Room_Tip ||
                attachment.first == Custom_Noti_Header_Kick ||
                attachment.first == Custom_Noti_Header_Queue) {
                [self showPersonalView:msg.from.userIDValue];
            }
        }
    }
     */
}


#pragma mark - ImRoomCoreClient

- (void)onMeInterChatRoomSuccess {
    [self updateInfo];
    [self updateMessage];
}

#pragma mark - RoomCoreClient
//房间信息改变
- (void)onCurrentRoomMsgUpdate:(NSMutableArray *)messages {
    
    self.messages = [messages mutableCopy];
    
    if (self.currentIsInBottom) {
        self.messagTipsBtn.hidden = YES;
        [self reloadChatList:YES];
        
    }else{
        self.messagTipsBtn.hidden = NO;
    }
}

//清除一条缓存的消息
- (void)onMessagesDidRemoveFromCache:(NSArray *)message {
    if (self.currentIsInBottom) {
        for (TTMessageDisplayModel *msg in message) {
            if (msg.message.messageId) {
                [self.attributedStringContent removeObjectForKey:msg.message.messageId];
                [self.heightCache removeObjectForKey:msg.message.messageId];
            }
        }
        for (TTMessageDisplayModel *msg in self.canRemoveMessageArray) {
            if (msg.message.messageId) {
                [self.attributedStringContent removeObjectForKey:msg.message.messageId];
                [self.heightCache removeObjectForKey:msg.message.messageId];
            }
        }
    }else {
        [self.canRemoveMessageArray addObjectsFromArray:message];
    }
}

#pragma mark - Event

- (void)gotoBottom:(UIButton *)messageTipButton {
    
    self.messagTipsBtn.hidden = YES;
    [self reloadChatList:NO];
}


#pragma mark - 自定义cell的点击事件
- (void)didClickTextMessageCellWith:(UserID)msgFromUid{
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    if (myUid != msgFromUid) {
        if (myUid == self.roomInfo.uid) { //房主
            [self showMsgRoomOwnerOperation:msgFromUid];
        } else if(myMember.type == NIMChatroomMemberTypeManager) {//管理
            [self showMsgRoomOwnerOperation:msgFromUid];
        }else {
            [self showPersonalView:msgFromUid];
        }
    }else{
        [self showPersonalView:myUid];
    }
}

- (void)didClickNotificationMessageCellWith:(NIMMessage *)msg{
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    NIMNotificationObject *notiMsg = (NIMNotificationObject *)msg.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
    if (content.eventType == NIMChatroomEventTypeEnter) {//enter room
        NIMChatroomNotificationMember *member = content.targets[0];
        if (myUid != member.userId.userIDValue) {
            if (myMember.type == NIMChatroomMemberTypeCreator) {
                [self showMsgRoomOwnerOperation:msg.from.userIDValue];
            } else if(myMember.type == NIMChatroomMemberTypeManager) {
                [self showMsgRoomOwnerOperation:msg.from.userIDValue];
            }else {
                [self showPersonalView:msg.from.userIDValue];
            }
        }else {
            [self showPersonalView:msg.from.userIDValue];
        }
    }
}

- (void)didClickRoomFaceMessageCellWith:(NIMMessage *)msg{
    NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
    if (customObject.attachment) {
        Attachment *attachment = (Attachment *)customObject.attachment;
        if (attachment.first == Custom_Noti_Header_Gift ||
            attachment.first == Custom_Noti_Header_RoomMagic ||
            attachment.first == Custom_Noti_Header_Room_Tip ||
            attachment.first == Custom_Noti_Header_Kick ||
            attachment.first == Custom_Noti_Header_Queue) {
            [self showPersonalView:msg.from.userIDValue];
        }
    }
}

#pragma mark - private method

- (void) _configureContentAttributedMap{
    
    self.attributedStringContent = [[NSCache alloc]init];;
}

- (NSMutableArray *)canRemoveMessageArray{
    if (!_canRemoveMessageArray) {
        _canRemoveMessageArray = [NSMutableArray array];
    }
    return _canRemoveMessageArray;
}

//获取房间信息
- (void)updateInfo {
    self.roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
    
}
//刷新
- (void)updateMessage {
    self.messages = [NSMutableArray arrayWithArray:[TTMessageContentProvider shareProvider].messages];
    [self reloadChatList:YES];
}
//刷新
- (void)reloadChatList:(BOOL)animate {
    
    if(self.messages.count == 0)return;
    TTMessageDisplayModel *msg = self.messages.lastObject;
    if ([self.currentMsgId isEqualToString:msg.message.messageId])return;
    [self reloadData:animate];
}

- (void)reloadData:(BOOL)animate {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollTableViewMessageListToBottoWithAnimated) object:nil];
    [self.tableView reloadData];
    [self scrollTableViewMessageListToBottoWithAnimated:animate];
//    [self performSelector:@selector(scrollTableViewMessageListToBottoWithAnimated) withObject:nil afterDelay:0.25];
}

- (void)scrollTableViewMessageListToBottoWithAnimated:(BOOL)animate{
    
    if (self.messages.count < 1) {
        return;
    }
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(rows-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animate];
    });
    
    self.messagTipsBtn.hidden = YES;
    TTMessageDisplayModel *msg = self.messages.lastObject;
    self.currentMsgId = msg.message.messageId;
}

//底部弹框逻辑
- (void)showMsgRoomOwnerOperation:(UserID)userId {
    
    /// 点击公屏用户信息时直接展示卡片信息
    [self showPersonalView:userId];
}

//show个人信息
- (void)showPersonalView:(UserID)uid {
    
    if ([_delegate respondsToSelector:@selector(messageTableView:needShowUserInfoCardWithUid:)]) {
        [_delegate messageTableView:self needShowUserInfoCardWithUid:uid];
    }
}

//黑名单
- (void)showAlertWithAddBlackList:(NIMChatroomMember *)member {
    __block NSString *title = [NSString stringWithFormat:@"你正在拉黑%@",member.roomNickname];
    [GetCore(UserCore) getUserInfo:member.userId.userIDValue refresh:NO success:^(UserInfo *info) {
        if (!member.roomNickname) {
            title = [NSString stringWithFormat:@"你正在拉黑%@",info.nick];
        }
    }failure:^(NSError *error) {
        
    }];
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = title;
    config.message = @"拉黑后他将无法加入此房间";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        [GetCore(ImRoomCoreV2) markBlackList:member.userId.userIDValue enable:YES];
    } cancelHandler:^{
        
    }];
}

//是否在麦上
- (BOOL)userIsOnMicroWith:(UserID)uid {
    
    NSArray *micMembers = [GetCore(ImRoomCoreV2).micMembers copy];
    if (micMembers != nil && micMembers.count > 0) {
        for (int i = 0; i < micMembers.count; i ++) {
            NIMChatroomMember *chatRoomMember = micMembers[i];
            if (chatRoomMember.userId.userIDValue == uid) {
                return YES;
            }
        }
    }
    return NO;
}

//通过uid判断麦位
- (NSString *)findThePositionByUid:(UserID)uid{
    if (uid > 0) {
        NSArray *keys = [GetCore(ImRoomCoreV2).micQueue allKeys];
        if (keys.count > 0) {
            for (NSString *key in keys) {
                NIMChatroomMember *member = [[GetCore(ImRoomCoreV2).micQueue objectForKey:key] chatRoomMember];
                if (member.userId.userIDValue == uid) {
                    return key;
                }
            }
        }
    }
    return nil;
}

- (BOOL)isShowUserCard:(NIMChatroomMember *) member{
    
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    if (myMember.type == NIMChatroomMemberTypeManager && [self userIsOnMicroWith:member.userId.userIDValue]) {
        
        if (member.type == NIMChatroomMemberTypeManager || member.type == NIMChatroomMemberTypeCreator) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (void)initView {
    AddCoreClient(RoomCoreClient, self);
    AddCoreClient(ImRoomCoreClient, self);
    AddCoreClient(BalanceErrorClient, self);
    
    self.currentIsInBottom = YES;
    [self addSubview:self.gradientBgView];
    [self.gradientBgView addSubview:self.tableView];
    [self addSubview:self.messagTipsBtn];
    
    [self updateInfo];
    [self _configureContentAttributedMap];
    [self updateMessage];
}

- (void)initConstrations {
    [self.gradientBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.messagTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    CGPoint tipBtnCenter = CGPointMake(KScreenWidth/2,CGRectGetMaxY(self.frame)-5-15);
    self.messagTipsBtn.center = [self convertPoint:tipBtnCenter fromView:self.superview];
    
    CGFloat expectHeight = 60;//渐变长度
    CGFloat endY = expectHeight / self.gradientBgView.frame.size.height;
    if (self.gradientBgView.frame.size.height == 0 || endY >= 1) {
        endY = 0.2;
    }
    
    CAGradientLayer *gradinetLayer = [CAGradientLayer layer];
    NSArray *colors = @[(id)[UIColor colorWithWhite:0 alpha:0].CGColor,
                        (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor,
                        (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,
                        (id)[UIColor colorWithWhite:0 alpha:0.75].CGColor,
                        (id)[UIColor colorWithWhite:0 alpha:1].CGColor
                        ];
    [gradinetLayer setColors:colors];
    [gradinetLayer setStartPoint:CGPointMake(0, 0)];
    [gradinetLayer setEndPoint:CGPointMake(0, endY)];
    [gradinetLayer setFrame:self.gradientBgView.bounds];
    [self.gradientBgView.layer setMask:gradinetLayer];
}

#pragma mark - getter&setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0.0;
//        _tableView.rowHeight = UITableViewAutomaticDimension;//高度设置为自适应
//        _tableView.bounces = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}

- (NSCache *)heightCache {
    if (!_heightCache) {
        _heightCache = [[NSCache alloc]init];
    }
    return _heightCache;
}

- (UIButton *)messagTipsBtn {
    if (!_messagTipsBtn) {
        
        _messagTipsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messagTipsBtn setTitle:@"底部有新消息" forState:UIControlStateNormal];
        [_messagTipsBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _messagTipsBtn.layer.cornerRadius = 15.0;
        _messagTipsBtn.layer.masksToBounds = YES;
        _messagTipsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _messagTipsBtn.backgroundColor = [UIColor whiteColor];
        [_messagTipsBtn addTarget:self action:@selector(gotoBottom:) forControlEvents:UIControlEventTouchUpInside];
        _messagTipsBtn.hidden = YES;
    }
    return _messagTipsBtn;
}

- (UIView *)gradientBgView {
    if (_gradientBgView == nil) {
        _gradientBgView = [[UIView alloc] init];
        _gradientBgView.backgroundColor = UIColor.clearColor;
        _gradientBgView.userInteractionEnabled = YES;
    }
    return _gradientBgView;
}

@end
