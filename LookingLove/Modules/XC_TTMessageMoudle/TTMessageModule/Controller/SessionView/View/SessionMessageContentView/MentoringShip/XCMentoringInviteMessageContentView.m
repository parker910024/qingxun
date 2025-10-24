//
//  XCMentoringInviteMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/2/18.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCMentoringInviteMessageContentView.h"
#import "UIView+NIM.h"
#import "TTMentoringInviteView.h"
#import "Attachment.h"
#import "MentoringInviteModel.h"

#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "AuthCore.h"
#import "RoomCoreV2.h"

#import "XCCurrentVCStackManager.h"
//bridge
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
//tool

//v
#import "XCFloatView.h"

NSString * const XCMentoringInviteMessageContentViewClick = @"XCMentoringInviteMessageContentViewClick";

@interface XCMentoringInviteMessageContentView ()<MentoringShipCoreClient>

@property (nonatomic, strong) TTMentoringInviteView * inviteView;

@property (nonatomic, strong) MentoringInviteModel * inviteModel;
@end

@implementation XCMentoringInviteMessageContentView

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)initSessionMessageContentView{
    if (self = [super initSessionMessageContentView]) {
        AddCoreClient(MentoringShipCoreClient, self);
        [self addSubview:self.inviteView];
        self.bubbleImageView.hidden = YES;
        @KWeakify(self);
        self.inviteView.didClickEnterButton = ^(UIButton * _Nonnull sender) {
            @KStrongify(self);
                [self mentoringTaskEnable];
        };
        
        self.inviteView.avatarImageTapBlock = ^{
            @KStrongify(self);
            if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
                NIMKitEvent *event = [[NIMKitEvent alloc] init];
                event.eventName = XCMentoringInviteMessageContentViewClick;
                event.messageModel = self.model;
                event.data = self;
                [self.delegate onCatchEvent:event];
            }
        };
    }
    return self;
}

- (void)mentoringTaskEnable{
    if (GetCore(AuthCore).getUid.userIDValue == self.inviteModel.apprenticeUid) {
        self.inviteView.enterButton.userInteractionEnabled = NO;
        [GetCore(MentoringShipCore) mentoringShipInviteEnableWithMasterUid:self.inviteModel.masterUid apprenticeUid:self.inviteModel.apprenticeUid isMaster:NO];
    }
}


- (void)mentoringShipInviteEnableSuccessisMaster:(BOOL)isMaster{
    if (!isMaster) {
        self.inviteView.enterButton.userInteractionEnabled = YES;
        if (GetCore(AuthCore).getUid.userIDValue == self.inviteModel.apprenticeUid) {
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.uid == self.inviteModel.masterUid && GetCore(RoomCoreV2).isInRoom) {
                @KWeakify(self);
                [[XCFloatView shareFloatView] hideFloatingView];
                [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:self.inviteModel.masterUid masterUid:self.inviteModel.roomUid apprenticeUid:self.inviteModel.apprenticeUid];
                });
            }else{
               [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:self.inviteModel.masterUid masterUid:self.inviteModel.roomUid apprenticeUid:self.inviteModel.apprenticeUid];
            }
           
        }
    }
}

- (void)mentoringShipInviteEnableFail:(NSString *)message isMaster:(BOOL)isMaster{
    if (!isMaster) {
        self.inviteView.enterButton.userInteractionEnabled = YES;
    }
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite) {
            MentoringInviteModel * mentoringAtttach = [MentoringInviteModel modelDictionary:atttach.data];
            self.inviteModel = mentoringAtttach;
            self.inviteView.inviteModel = mentoringAtttach;
        }
    }
}


- (void)layoutSubviews{
    self.inviteView.nim_width = 300 + 22;
    self.inviteView.nim_height = self.nim_height;
    if (self.frame.origin.x >= 0) {
        self.inviteView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.inviteView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.inviteView.nim_top = 0;
}



- (TTMentoringInviteView *)inviteView{
    if (!_inviteView) {
        _inviteView = [[TTMentoringInviteView alloc] init];
    }
    return _inviteView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
