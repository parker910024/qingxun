//
//  XCMasterSecondTaskMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCMasterSecondTaskMessageContentView.h"
#import "TTMasterSecondTaskView.h"
#import "Attachment.h"
#import "XCMentoringShipAttachment.h"
#import "UIView+NIM.h"
#import "XCMacros.h"
#import "XCKeyWordTool.h"

#import "MentoringShipCoreClient.h"
#import "MentoringGiftModel.h"
#import "ImMessageCore.h"
#import "MentoringShipCore.h"

@interface  XCMasterSecondTaskMessageContentView ()<MentoringShipCoreClient>

@property (nonatomic, strong) TTMasterSecondTaskView * secondTaskView;
/**
 更新本地回话的时候使用
 */
@property (nonatomic, strong) NIMMessage * message;

@property (nonatomic, strong) XCMentoringShipAttachment * masterSecondAttach;

@property (nonatomic, strong) Attachment * attach;
/**
 师徒的礼物模型
 */
@property (nonatomic, strong) MentoringGiftModel * mentorGiftModel;

@end

@implementation XCMasterSecondTaskMessageContentView

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)initSessionMessageContentView{
    if (self = [super initSessionMessageContentView]) {
        AddCoreClient(MentoringShipCoreClient, self);
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.secondTaskView];
    @KWeakify(self);
    self.secondTaskView.sendButtonDidClickBlcok = ^{
        @KStrongify(self);
        MentoringGiftModel * giftModel = [MentoringGiftModel yy_modelWithJSON:self.masterSecondAttach.extendData];
        if (self.attach.first == Custom_Noti_Header_Mentoring_RelationShip) {
            if (self.attach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master) {
                 [self sendGiftToMasterOrApprenticWith:giftModel.giftId targetInfo:self.masterSecondAttach.apprenticeUid];
            }else if (self.attach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice){
                 [self sendGiftToMasterOrApprenticWith:giftModel.giftId targetInfo:self.masterSecondAttach.masterUid];
            }
        }
       
    };
}



- (void)sendGiftToMasterOrApprenticWith:(UserID)giftId targetInfo:(UserID)targetUid{
    [GetCore(MentoringShipCore) mentoringShipSendChatGift:giftId gameGiftType:GameRoomGiftType_Normal giftNum:1 targetUid:targetUid giftModel:self.mentorGiftModel];
}

#pragma mark - MentoringShipCoreClient
//背包礼物赠送成功
- (void)onUpdatePackGiftWithGiftIdWhenMentoringShip {
    if (self.attach.first == Custom_Noti_Header_Mentoring_RelationShip) {
        if (self.attach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master) {
            self.masterSecondAttach.masterSendGift = YES;
            self.message.localExt = @{@"data":[self.masterSecondAttach model2dictionary]};
            [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
            
            //自动发送一句话 给徒弟
            NSString * message = self.masterSecondAttach.message && self.masterSecondAttach.message.length > 0 ? self.masterSecondAttach.message : [NSString stringWithFormat:@"在%@,喜欢谁就给谁送花花~收到花花你不仅可以提升魅力值还可以提现哦！", [XCKeyWordTool sharedInstance].myAppName];
            [GetCore(ImMessageCore) sendTextMessage:message nick:nil sessionId:[NSString stringWithFormat:@"%lld", self.masterSecondAttach.apprenticeUid] type:NIMSessionTypeP2P];
        }else if (self.attach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice){
            [[BaiduMobStat defaultStat] logEvent:@"news_task_three_complete" eventLabel:@"任务三完成"];
            self.masterSecondAttach.apprenticeSendGift = YES;
            self.message.localExt = @{@"data":[self.masterSecondAttach model2dictionary]};
            [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
        }
    }
}

- (void)refresh:(NIMMessageModel *)data{
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        self.attach = atttach;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip) {
            if (atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master) {
                self.message = data.message;
               
                if (data.message.localExt) {
                    XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                    self.masterSecondAttach = mentoringAtttach;
                    self.mentorGiftModel = [MentoringGiftModel yy_modelWithJSON:mentoringAtttach.extendData];
                    self.secondTaskView.masterSecondTaskAttach = mentoringAtttach;
                }else{
                    XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                     self.mentorGiftModel = [MentoringGiftModel yy_modelWithJSON:mentoringAtttach.extendData];
                    self.masterSecondAttach = mentoringAtttach;
                    self.secondTaskView.masterSecondTaskAttach = mentoringAtttach;
                }
            }else if (atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice){
                self.message = data.message;
                if (data.message.localExt) {
                    XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                    self.mentorGiftModel = [MentoringGiftModel yy_modelWithJSON:mentoringAtttach.extendData];
                    self.masterSecondAttach = mentoringAtttach;
                    self.secondTaskView.apprenticeSendAttachment = mentoringAtttach;
                }else{
                    XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                    self.mentorGiftModel = [MentoringGiftModel yy_modelWithJSON:mentoringAtttach.extendData];
                    self.masterSecondAttach = mentoringAtttach;
                    self.secondTaskView.apprenticeSendAttachment = mentoringAtttach;
                }
            }
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.secondTaskView.nim_width = 300 + 22;
    self.secondTaskView.nim_height = self.nim_height;
    if (self.frame.origin.x >= 0) {
        self.secondTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.secondTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.secondTaskView.nim_top = 0;
}


- (TTMasterSecondTaskView *)secondTaskView{
    if (!_secondTaskView) {
        _secondTaskView = [[TTMasterSecondTaskView alloc] init];
    }
    return _secondTaskView;
}

@end
