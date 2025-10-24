//
//  XCMasterThirdTaskMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCMasterThirdTaskMessageContentView.h"

#import "TTMasterThirdTaskView.h"
#import "TTHomeRoomSelectView.h"

#import "UIView+NIM.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "TTPopup.h"

#import "Attachment.h"
#import "XCMentoringShipAttachment.h"
#import "AuthCore.h"
#import "XCCurrentVCStackManager.h"
#import "UIColor+UIColor_Hex.h"

#import "RoomCoreV2.h"
#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "MentoringInviteModel.h"
#import "RoomCoreV2.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "UserCore.h"
#import "TTGameStaticTypeCore.h"

#import "XCMediator+TTRoomMoudleBridge.h"

@interface XCMasterThirdTaskMessageContentView ()<TTHomeRoomSelectViewDelegate,MentoringShipCoreClient, ImMessageCoreClient>

@property (nonatomic, strong) TTMasterThirdTaskView * thirdTaskView;

@property (nonatomic, strong) NIMMessage * message;

@property (nonatomic, strong) XCMentoringShipAttachment * thirdMasterAttach;
/** 开启房间*/
@property (nonatomic, strong) TTHomeRoomSelectView * roomSelectView;

@end

@implementation XCMasterThirdTaskMessageContentView
- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)initSessionMessageContentView{
    if (self= [super initSessionMessageContentView]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    AddCoreClient(MentoringShipCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);
    [self addSubview:self.thirdTaskView];
    @KWeakify(self);
    self.thirdTaskView.inviteButtonDidClickBlcok = ^{
        @KStrongify(self);
        //先判断 当前的师徒任务是不是有效
        self.thirdTaskView.inviteButton.userInteractionEnabled = NO;
        [XCHUDTool showGIFLoading];
        [GetCore(MentoringShipCore) mentoringShipInviteEnableWithMasterUid:self.thirdMasterAttach.masterUid apprenticeUid:self.thirdMasterAttach.apprenticeUid isMaster:YES];
    };
}

- (void)sendInviteMessageToApprentice{
   RoomInfo * infor = GetCore(RoomCoreV2).getCurrentRoomInfo;
    UserInfo * userInfor = [GetCore(UserCore) getUserInfoInDB:self.thirdMasterAttach.masterUid];
    MentoringInviteModel * inviteModel = [[MentoringInviteModel alloc] init];
    inviteModel.avatar = infor.avatar;
    inviteModel.nick = userInfor.nick;
    inviteModel.roomUid = infor.uid;
    inviteModel.apprenticeUid =self.thirdMasterAttach.apprenticeUid;
    inviteModel.masterUid = infor.uid;
    inviteModel.expired = YES;
    
    Attachment * attach = [[Attachment alloc] init];
    attach.first = Custom_Noti_Header_Mentoring_RelationShip;
    attach.second =  Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite;
    attach.data = [inviteModel model2dictionary];
    
    [GetCore(ImMessageCore)sendCustomMessageAttachement:attach sessionId:[NSString stringWithFormat:@"%lld", self.thirdMasterAttach.apprenticeUid] type:NIMSessionTypeP2P];
}

#pragma mark-  MentoringShipCoreClient
- (void)mentoringShipInviteEnableSuccessisMaster:(BOOL)isMaster{
    if (isMaster) {
        self.thirdTaskView.inviteButton.userInteractionEnabled = YES;
        [XCHUDTool hideHUD];
        GetCore(MentoringShipCore).masterUid = self.thirdMasterAttach.masterUid;
        GetCore(MentoringShipCore).inviteApprenticeUid = self.thirdMasterAttach.apprenticeUid;
        //如果房间存在 并且是自己的房间的话 就只需要发送邀请就行
        if (GetCore(RoomCoreV2).getCurrentRoomInfo && GetCore(RoomCoreV2).getCurrentRoomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
            [self sendInviteMessageToApprentice];
        }else{
            if (!self.roomSelectView.roomShowsView.isHidden) {
                self.roomSelectView.roomShowsView.hidden = YES;
            }
            [TTPopup popupView:self.roomSelectView
                         style:TTPopupStyleAlert];
        }
    }
}

- (void)mentoringShipInviteEnableFail:(NSString *)message isMaster:(BOOL)isMaster{
    if (isMaster) {
        [XCHUDTool hideHUD];
        self.thirdTaskView.userInteractionEnabled = NO;
    }
}

#pragma mark - ImMessageCoreClient
- (void)onSendMessageSuccess:(NIMMessage *)msg{
    if ([msg.messageObject isKindOfClass:NIMCustomObject.class]) {
        NIMCustomObject * customObject = msg.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite) {
            self.thirdMasterAttach.masterInviteRoom = YES;
            self.message.localExt = @{@"data":[self.thirdMasterAttach model2dictionary]};
            [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
        }
    }
}

#pragma mark --- 创建房间选择 ---
- (void)ordinaryButtonActionResponse {
    [TTPopup dismiss];
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_Normal;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:3];
    [[BaiduMobStat defaultStat] logEvent:@"news_task_three_ordinary" eventLabel:@"任务三邀请进房-普通房"];
}
- (void)companyButtonActionResponse {
    [TTPopup dismiss];
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_CP;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:5];
    [[BaiduMobStat defaultStat]logEvent:@"news_task_three_accompanying" eventLabel:@"任务三邀请进房-陪伴房"];
}

- (void)touchMaskBackground {
    [TTPopup dismiss];
}

- (void)clickMyRoomBtnAction:(UIButton *)sender {
    if (!self.roomSelectView.roomShowsView.isHidden) {
        self.roomSelectView.roomShowsView.hidden = YES;
    }
    
    [TTPopup popupView:self.roomSelectView
                 style:TTPopupStyleAlert];
}


- (void)refresh:(NIMMessageModel *)data{
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master) {
            self.message = data.message;
            if (data.message.localExt) {
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                self.thirdMasterAttach = mentoringAtttach;
                self.thirdTaskView.masterThirdTaskAttach = mentoringAtttach;
            }else{
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                self.thirdMasterAttach = mentoringAtttach;
                self.thirdTaskView.masterThirdTaskAttach = mentoringAtttach;
            }
        }
    }
}

- (void)layoutSubviews{
    self.thirdTaskView.nim_width = 300 + 22;
    self.thirdTaskView.nim_height = self.nim_height;
    if (self.frame.origin.x >= 0) {
        self.thirdTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.thirdTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.thirdTaskView.nim_top = 0;
}

- (TTMasterThirdTaskView *)thirdTaskView{
    if (!_thirdTaskView) {
        _thirdTaskView = [[TTMasterThirdTaskView alloc] init];
    }
    return _thirdTaskView;
}

-(TTHomeRoomSelectView *)roomSelectView{
    if (!_roomSelectView) {
        _roomSelectView = [[TTHomeRoomSelectView alloc] init];
        _roomSelectView.frame = CGRectMake(0, 0, 311, 311);
        _roomSelectView.backgroundColor = [UIColor clearColor];
        _roomSelectView.delegate = self;
    }
    return _roomSelectView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
