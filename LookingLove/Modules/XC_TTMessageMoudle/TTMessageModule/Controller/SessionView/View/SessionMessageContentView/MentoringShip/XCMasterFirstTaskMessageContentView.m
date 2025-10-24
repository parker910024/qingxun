//
//  XCMasterFirstTaskMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCMasterFirstTaskMessageContentView.h"
//view
#import "TTMasterFirstTaskView.h"
//core
#import "XCMacros.h"
#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "AuthCore.h"
#import "ImMessageCore.h"
#import "Attachment.h"
#import "XCMentoringShipAttachment.h"
//category
#import "XCHUDTool.h"
#import "UIView+NIM.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
//tool
#import "TTWKWebViewViewController.h"
#import "XCCurrentVCStackManager.h"
#import "XCHtmlUrl.h"
#import <Masonry/Masonry.h>


static NSString * const XCMasterFirstTaskMessageContentViewClick  = @"XCMasterFirstTaskMessageContentViewClick";

@interface XCMasterFirstTaskMessageContentView ()<MentoringShipCoreClient>

@property (nonatomic, strong) TTMasterFirstTaskView * firstTaskView;
@property (nonatomic, strong) XCMentoringShipAttachment * mentoringShipAttach;

@property (nonatomic, strong) NIMMessage * message;

@end

@implementation XCMasterFirstTaskMessageContentView

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)initSessionMessageContentView{
    if (self = [super initSessionMessageContentView]) {
        [self initView];
        [self addCore];
    }
    return self;
}

#pragma mark - private method
- (void)addCore{
    AddCoreClient(MentoringShipCoreClient, self);
}

- (void)initView{
     self.bubbleImageView.hidden = YES;
    [self addSubview:self.firstTaskView];
    @KWeakify(self);
    self.firstTaskView.followButtonDidClickBlcok = ^{
        @KStrongify(self);
        [XCHUDTool showGIFLoading];
        self.firstTaskView.followButton.userInteractionEnabled = NO;
        [GetCore(MentoringShipCore) mentoringShipFocusOrGreetToUser:self.mentoringShipAttach.masterUid likeUid:self.mentoringShipAttach.apprenticeUid];
    };
    
    self.firstTaskView.reportButtonDidClickBlcok = ^{
        @KStrongify(self);
        TTWKWebViewViewController * webViewController = [[TTWKWebViewViewController alloc] init];
        NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld",HtmlUrlKey(kReportURL),self.mentoringShipAttach.apprenticeUid];
        webViewController.urlString = urlstr;
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:webViewController animated:YES];
    };
    
    self.firstTaskView.avatarImageTapBlock = ^{
        @KStrongify(self);
        if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
            NIMKitEvent *event = [[NIMKitEvent alloc] init];
            event.eventName = XCMasterFirstTaskMessageContentViewClick;
            event.messageModel = self.model;
            event.data = self;
            [self.delegate onCatchEvent:event];
        }
    };
}


- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    if (data.message.messageObject) {
        NIMCustomObject * customObject = data.message.messageObject;
        Attachment * atttach = (Attachment *)customObject.attachment;
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master) {
            self.message = data.message;
            if (data.message.localExt) {
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                self.mentoringShipAttach = mentoringAtttach;
                self.firstTaskView.masterFirstTaskAttach = mentoringAtttach;
            }else{
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                self.mentoringShipAttach = mentoringAtttach;
                self.firstTaskView.masterFirstTaskAttach = mentoringAtttach;
            }
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets insets = self.model.contentViewInsets;
    self.firstTaskView.nim_width = 300 + 22;
    self.firstTaskView.nim_height = self.nim_height;
    if (self.frame.origin.x >= 0) {
        self.firstTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.firstTaskView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.firstTaskView.nim_top = 0;
}


#pragma mark - MentoringShipCoreClient
- (void)mentoringShipFocusOrGreetToUserSuccess:(NSDictionary *)dic{
    [XCHUDTool hideHUD];
    [self updateLocationMessageAndSendMessage];
}

- (void)mentoringShipFocusOrGreetToUserFail:(NSString *)message{
    [XCHUDTool hideHUD];
}

//更新本地的ext 并且发送一个打招呼
- (void)updateLocationMessageAndSendMessage{
    self.firstTaskView.followButton.userInteractionEnabled = YES;
    self.mentoringShipAttach.masterFocus = YES;
    self.message.localExt = @{@"data":[self.mentoringShipAttach model2dictionary]};
    [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
    //发一条消息
    [self sendCustomMessageWithSessionId:self.mentoringShipAttach.apprenticeUid];
}

- (void)sendCustomMessageWithSessionId:(UserID)sessionId{
    [GetCore(ImMessageCore) sendTextMessage:self.mentoringShipAttach.message nick:nil sessionId:[NSString stringWithFormat:@"%lld", sessionId] type:NIMSessionTypeP2P];
}


- (TTMasterFirstTaskView *)firstTaskView {
    if (!_firstTaskView) {
        _firstTaskView = [[TTMasterFirstTaskView alloc] init];
    }
    return _firstTaskView;
}

@end
