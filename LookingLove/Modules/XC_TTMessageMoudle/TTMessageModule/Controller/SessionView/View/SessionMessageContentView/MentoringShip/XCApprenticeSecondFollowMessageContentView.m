//
//  XCApprenticeSecondFollowMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/1/22.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCApprenticeSecondFollowMessageContentView.h"
#import "TTApprenticeFollowView.h"
#import "Attachment.h"
#import "XCMentoringShipAttachment.h"
#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "ImMessageCore.h"
#import "AuthCore.h"
#import "UIView+NIM.h"

#import "XCHtmlUrl.h"
#import "XCCurrentVCStackManager.h"

#import "TTWKWebViewViewController.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

static NSString * const XCApprenticeSecondFollowMessageContentViewClick = @"XCApprenticeSecondFollowMessageContentViewClick";

@interface XCApprenticeSecondFollowMessageContentView ()<MentoringShipCoreClient>

@property (nonatomic, strong) TTApprenticeFollowView * followView;
/** 保存当前的msg 准备更新使用*/
@property (nonatomic, strong) NIMMessage * message;
/** 保存一下值 关注的时候使用*/
@property (nonatomic, strong) XCMentoringShipAttachment * apprenticeAttach;

@end

@implementation XCApprenticeSecondFollowMessageContentView

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
    [self addSubview:self.followView];
    self.bubbleImageView.hidden = YES;
    @KWeakify(self);
    self.followView.reportButtonDidClickBlcok = ^{
        @KStrongify(self);
        TTWKWebViewViewController * webViewController = [[TTWKWebViewViewController alloc] init];
        NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld",HtmlUrlKey(kReportURL),self.apprenticeAttach.masterUid];
        webViewController.urlString = urlstr;
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:webViewController animated:YES];
    };
    
    self.followView.avatarImageBlock = ^{
        @KStrongify(self);
        if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
            NIMKitEvent *event = [[NIMKitEvent alloc] init];
            event.eventName = XCApprenticeSecondFollowMessageContentViewClick;
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
        if (atttach.first == Custom_Noti_Header_Mentoring_RelationShip && atttach.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice) {
            self.message = data.message;
            if (data.message.localExt) {
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:data.message.localExt[@"data"]];
                self.apprenticeAttach = mentoringAtttach;
                self.followView.apprenticeFollowAttach = mentoringAtttach;
            }else{
                XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:atttach.data];
                self.apprenticeAttach = mentoringAtttach;
                self.followView.apprenticeFollowAttach = mentoringAtttach;
            }
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets insets = self.model.contentViewInsets;
    self.followView.nim_width = 300 + 22;
    self.followView.nim_height = self.nim_height;
    if (self.frame.origin.x >= 0) {
        self.followView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.followView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.followView.nim_top = 0;
}

- (TTApprenticeFollowView *)followView{
    if (!_followView) {
        _followView = [[TTApprenticeFollowView alloc] init];
    }
    return _followView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
