//
//  XCMasterFourthTaskMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCMasterFourthTaskMessageContentView.h"
#import "Attachment.h"
#import "TTMasterFourthTaskView.h"
#import "UIView+NIM.h"

#import "XCMentoringShipAttachment.h"
#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "ImMessageCore.h"

#import "XCHUDTool.h"

@interface XCMasterFourthTaskMessageContentView ()

@property (nonatomic, strong) TTMasterFourthTaskView * fourthTaskView;

@property (nonatomic, strong) NIMMessage * message;

@property (nonatomic, strong) XCMentoringShipAttachment * masterFourthAttach;
@end

@implementation XCMasterFourthTaskMessageContentView

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
    [self addSubview:self.fourthTaskView];
    
    @KWeakify(self);
    self.fourthTaskView.inviteButtonDidClickBlcok = ^{
        @KStrongify(self);
        self.fourthTaskView.inviteButton.userInteractionEnabled = NO;
        [XCHUDTool showGIFLoading];
        [GetCore(MentoringShipCore) masterSendInviteRequestWithMasterUid:self.masterFourthAttach.masterUid apprenticeUid:self.masterFourthAttach.apprenticeUid];
    };
}

- (void)refresh:(NIMMessageModel *)data{
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master) {
            self.message = data.message;
            if (self.message.localExt) {
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                self.masterFourthAttach = mentoringAtttach;
                self.fourthTaskView.masterFourthTaskAttach = mentoringAtttach;
            }else{
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                self.masterFourthAttach = mentoringAtttach;
                self.fourthTaskView.masterFourthTaskAttach = mentoringAtttach;
            }
        }
    }
}


- (void)layoutSubviews{
    self.fourthTaskView.nim_width = 300 + 22;
    self.fourthTaskView.nim_height = self.nim_height;
    if (self.frame.origin.x >= 0) {
        self.fourthTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.fourthTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.fourthTaskView.nim_top = 0;
}

#pragma mark - MentoringShipCoreClient
- (void)masterSendInviteRequestSuccess{
    [XCHUDTool hideHUD];
    self.fourthTaskView.inviteButton.userInteractionEnabled = YES;
    self.masterFourthAttach.masterInvite = YES;
    self.message.localExt = @{@"data":[self.masterFourthAttach model2dictionary]};
    [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
}

- (void)masterSendInviteRequestFail{
    [XCHUDTool hideHUD];
    self.fourthTaskView.inviteButton.userInteractionEnabled = YES;
}

- (TTMasterFourthTaskView *)fourthTaskView{
    if (!_fourthTaskView) {
        _fourthTaskView = [[TTMasterFourthTaskView alloc] init];
    }
    return _fourthTaskView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
