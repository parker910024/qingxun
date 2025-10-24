//
//  XCApprenticeAcceptMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCApprenticeAcceptMessageContentView.h"
#import "TTApprenticeAcceptView.h"
#import "TTMasterTaskSuccessView.h"
#import "UIView+NIM.h"

#import "XCMentoringShipAttachment.h"
#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "ImMessageCore.h"

#import "XCHUDTool.h"
#import "XCCurrentVCStackManager.h"


@interface XCApprenticeAcceptMessageContentView ()<MentoringShipCoreClient, TTMasterTaskSuccessViewDelegate>

@property (nonatomic, strong) TTApprenticeAcceptView * apprenticeAcceptView;

@property (nonatomic, strong) NIMMessage * message;

@property (nonatomic, strong) XCMentoringShipAttachment * apprenticeAcceptAttach;

@end


@implementation XCApprenticeAcceptMessageContentView

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
    [self addSubview:self.apprenticeAcceptView];
    
    @KWeakify(self);
    self.apprenticeAcceptView.agreeButtonDidClickBlcok = ^{
        @KStrongify(self);
         [self agreeOrRejectInvite:YES];
    };
    
    self.apprenticeAcceptView.rejectButtonDidClickBlcok = ^{
        @KStrongify(self);
        [self agreeOrRejectInvite:NO];
    };
}

- (void)agreeOrRejectInvite:(BOOL)staus{
    [XCHUDTool showGIFLoading];
    int type;
    if (staus) {
        type = 1;
    }else{
        type = 2;
    }
    [GetCore(MentoringShipCore) bulidMentoringShipWithMasterUid:self.apprenticeAcceptAttach.masterUid apprenticeUid:self.apprenticeAcceptAttach.apprenticeUid type:type];
}

#pragma makr - MentoringShipCoreClient
- (void)bulidMentoringShipWithMasterSuccess:(NSDictionary *)dic type:(int)type{
    [XCHUDTool hideHUD];
    if (type == 1) {
        self.apprenticeAcceptAttach.apprenticeAgree = YES;
        self.message.localExt = @{@"data":[self.apprenticeAcceptAttach model2dictionary]};
        [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
    
    }else{
        self.apprenticeAcceptAttach.apprenticeReject = YES;
        self.message.localExt = @{@"data":[self.apprenticeAcceptAttach model2dictionary]};
        [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
    }
    [[BaiduMobStat defaultStat] logEvent:@"news_task_four_complete" eventLabel:@"任务四完成"];
}

- (void)bulidMentoringShipWithMasterFail:(NSString *)message code:(nonnull NSNumber *)code type:(int)type{
    [XCHUDTool hideHUD];
    if ([code integerValue] == 90020) {
        self.apprenticeAcceptAttach.apprenticeAgreeFail = YES;
        self.message.localExt = @{@"data":[self.apprenticeAcceptAttach model2dictionary]};
        [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
    }
}


- (void)refresh:(NIMMessageModel *)data{
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Apprentice) {
            self.message = data.message;
            if (data.message.localExt) {
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                self.apprenticeAcceptAttach = mentoringAtttach;
                self.apprenticeAcceptView.appenticeAcceptAttach = mentoringAtttach;
            }else{
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                self.apprenticeAcceptAttach = mentoringAtttach;
                self.apprenticeAcceptView.appenticeAcceptAttach = mentoringAtttach;
            }
        }
    }
}

- (void)layoutSubviews{
    self.apprenticeAcceptView.nim_top = self.nim_top;
    self.apprenticeAcceptView.nim_left = 0;
    self.apprenticeAcceptView.nim_size = self.nim_size;
}

- (TTApprenticeAcceptView *)apprenticeAcceptView{
    if (!_apprenticeAcceptView) {
        _apprenticeAcceptView = [[TTApprenticeAcceptView alloc] init];
    }
    return _apprenticeAcceptView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
