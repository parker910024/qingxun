//
//  XCGuildManageMessageContentView.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCGuildMessageContentView.h"
#import "XCGuildMessageContentControlView.h"
#import "TTGuildGroupManageConst.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "UIView+NTES.h"
#import "XCHUDTool.h"
#import "UIColor+UIColor_Hex.h"
#import "TTSessionRichTextParser.h"

#import "XCGuildAttachment.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "ImMessageCore.h"

NSString *const XCGuildMessageContentViewClick = @"XCGuildMessageContentViewClick";

@interface XCGuildMessageContentView ()<GuildCoreClient>
@property (nonatomic, strong) UILabel *titleLabel;//主标题
@property (nonatomic, strong) UILabel *contentLabel;//副标题

@property (nonatomic, strong) XCGuildMessageContentControlView *controlPanelView;//控制面板

@property (nonatomic, strong) XCGuildAttachment *attachment;

@property (nonatomic, assign) NSInteger selectStatus;//选择状态 -1：未选，0：拒绝，1：同意

@property (nonatomic, copy) NSString *currentOperateMessageId;//当前操作的 messageId

@end

@implementation XCGuildMessageContentView

#pragma mark - Life Cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        AddCoreClient(GuildCoreClient, self);
        
        self.selectStatus = -1;
        self.currentOperateMessageId = nil;
        
        [self initView];
        [self setupConstraints];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCGuildAttachment *attachment;
    
    if (data.message.localExt) {
        Attachment *att = (Attachment *)object.attachment;

        XCGuildAttachment *attach = [XCGuildAttachment yy_modelWithJSON:data.message.localExt];
        attach.layout = [MessageLayout yy_modelWithJSON:data.message.localExt[@"layout"]];
        attach.first = att.first;
        attach.second = att.second;
        
        attachment = attach;

    } else {
        if ([object.attachment isKindOfClass:[XCGuildAttachment class]]) {
            attachment = (XCGuildAttachment *)object.attachment;
        } else if ([object.attachment isKindOfClass:[Attachment class]]) {
            Attachment *att = (Attachment *)object.attachment;
            attachment = [XCGuildAttachment yy_modelWithJSON:att.data];
        }
        
        data.message.localExt = [attachment model2dictionary];
    }
    
    self.attachment = attachment;
    self.controlPanelView.attachment = attachment;
    
    [self updateUIWithAttachment:attachment];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCGuildMessageContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

#pragma mark - Core Protocols
#pragma mark GuildCoreClient
/**
 厅主/高管 审核加入申请
 
 @param data 操作成功时为 nil，出现错误时返回 code 和 msg 返回，注意和外层 code msg 是不同的
 code: 90121：消息已过期 / 90122：消息已处理
 
 @param code 错误码，90121：消息已过期 / 90122：消息已处理
 @param msg 错误信息
 */
- (void)responseGuildHallDealApply:(NSDictionary *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUD];
    
    if (self.selectStatus == -1) {
        return;
    }
    
    if (![self.currentOperateMessageId isEqualToString:self.model.message.messageId]) {
        return;
    }
    
    self.currentOperateMessageId = nil;
    
    if (code) {
        [XCHUDTool showErrorWithMessage:msg ?: @"操作出错了"];
        return;
    }
    
    BOOL isAgree = self.selectStatus == 1;
    XCGuildAttachmentStatus status = [self statusWithActionType:isAgree responseData:data];
    [self updateMessageToStatus:status];
}

/**
 厅主/高管 同意退出申请
 
 @param data 操作成功时为 nil，出现错误时返回 code 和 msg 返回，注意和外层 code msg 是不同的
 code: 90121：消息已过期 / 90122：消息已处理
 
 @param code 错误码，90121：消息已过期 / 90122：消息已处理
 @param msg 错误信息
 */
- (void)responseGuildDealAuditQuit:(NSDictionary *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUD];
    
    if (self.selectStatus == -1) {
        return;
    }
    
    if (![self.currentOperateMessageId isEqualToString:self.model.message.messageId]) {
        return;
    }
    
    self.currentOperateMessageId = nil;
    
    if (code) {
        [XCHUDTool showErrorWithMessage:msg ?: @"操作出错了"];
        return;
    }
    
    BOOL isAgree = self.selectStatus == 1;
    XCGuildAttachmentStatus status = [self statusWithActionType:isAgree responseData:data];
    [self updateMessageToStatus:status];
}

/**
 普通成员 处理入厅邀请
 
 @param data 操作成功时为 nil，出现错误时返回 code 和 msg 返回，注意和外层 code msg 是不同的
 code: 90121：消息已过期 / 90122：消息已处理
 
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildDealHallInvite:(NSDictionary *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUD];
    
    if (self.selectStatus == -1) {
        return;
    }
    
    if (![self.currentOperateMessageId isEqualToString:self.model.message.messageId]) {
        return;
    }
    
    self.currentOperateMessageId = nil;
    
    if (code) {
        [XCHUDTool showErrorWithMessage:msg ?: @"操作出错了"];
        return;
    }
    
    BOOL isAgree = self.selectStatus == 1;
    XCGuildAttachmentStatus status = [self statusWithActionType:isAgree responseData:data];
    [self updateMessageToStatus:status];
}

#pragma mark - Event Responses
- (void)confirmButtonTapped {
    
    if (self.attachment == nil) {
        return;
    }
    
    self.selectStatus = 1;
    
    [XCHUDTool showGIFLoading];

    NSRange recordRange = [self.attachment.url rangeOfString:@"recordId="];
    NSString *recordId;
    
    if (!NSEqualRanges(recordRange, NSMakeRange(NSNotFound, 0))) {
        if (self.attachment.url.length > recordRange.location+recordRange.length) {
            recordId = [self.attachment.url substringFromIndex:recordRange.location+recordRange.length];
        }
    }
    
    self.currentOperateMessageId = self.model.message.messageId;
    
    if (self.attachment.second == Custom_Noti_Sub_HALL_APPLY_JOIN) {
        [GetCore(GuildCore) requestGuildAuditApplyHallWithPath:self.attachment.url
                                                      recordId:recordId
                                                          type:1];
        
    } else if (self.attachment.second == Custom_Noti_Sub_HALL_MANAGER_INVITE) {
        [GetCore(GuildCore) requestGuildDealInviteHallWithPath:self.attachment.url
                                                      recordId:recordId
                                                          type:1];
        
    } else if (self.attachment.second == Custom_Noti_Sub_HALL_APPLY_EXIT) {
        [GetCore(GuildCore) requestGuildAuditQuitHallWithPath:self.attachment.url
                                                     recordId:recordId];
    }
}

- (void)rejectButtonTapped {
    if (self.attachment == nil) {
        return;
    }
    
    self.selectStatus = 0;
    
    [XCHUDTool showGIFLoading];
    
    NSRange recordRange = [self.attachment.url rangeOfString:@"recordId="];
    NSString *recordId;
    
    if (!NSEqualRanges(recordRange, NSMakeRange(NSNotFound, 0))) {
        if (self.attachment.url.length > recordRange.location+recordRange.length) {
            recordId = [self.attachment.url substringFromIndex:recordRange.location+recordRange.length];
        }
    }
    
    self.currentOperateMessageId = self.model.message.messageId;
    
    if (self.attachment.second == Custom_Noti_Sub_HALL_APPLY_JOIN) {
        [GetCore(GuildCore) requestGuildAuditApplyHallWithPath:self.attachment.url
                                                      recordId:recordId
                                                          type:0];
        
    } else if (self.attachment.second == Custom_Noti_Sub_HALL_MANAGER_INVITE) {
        [GetCore(GuildCore) requestGuildDealInviteHallWithPath:self.attachment.url
                                                      recordId:recordId
                                                          type:0];
    }
}

#pragma mark - Private Methods
- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    [self addSubview:self.controlPanelView];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self.titleLabel);
    }];
    
    [self.controlPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(6);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

/**
 根据操作类型和响应数据获取状态
 
 @param isAgree 操作类型，同意，否则拒绝
 @param data 操作结果响应数据
 @return 状态
 */
- (XCGuildAttachmentStatus)statusWithActionType:(BOOL)isAgree
                                   responseData:(NSDictionary *)data {
    
    NSString *code = [NSString stringWithFormat:@"%@", data[@"code"]];
    BOOL isExpired = [code isEqualToString:@"90121"];
    BOOL isHandled = [code isEqualToString:@"90122"];
    
    XCGuildAttachmentStatus status = XCGuildAttachmentStatusUntreated;
    if (isExpired) {
        status = XCGuildAttachmentStatusExpired;
    } else if (isHandled) {
        status = XCGuildAttachmentStatusProcessed;
    } else {
        status = isAgree ? XCGuildAttachmentStatusAgree : XCGuildAttachmentStatusReject;
    }
    
    return status;
}

/**
 更新消息
 
 @param status 消息修改状态
 */
- (void)updateMessageToStatus:(XCGuildAttachmentStatus)status {
    
    switch (status) {
        case XCGuildAttachmentStatusAgree:
        case XCGuildAttachmentStatusReject:
        {
            //当用户的公会入厅状态发生改变时，发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageMayUpdateHallJoinStatusNoti object:nil];
        }
            break;
            
        default:
            break;
    }
    XCGuildAttachment *attach = [XCGuildAttachment yy_modelWithJSON:self.model.message.localExt];
    attach.layout = [MessageLayout yy_modelWithJSON:self.model.message.localExt[@"layout"]];
    attach.msgStatus = status;
    self.model.message.localExt = [attach model2dictionary];
    
    [GetCore(ImMessageCore) updateMessage:self.model.message
                                  session:self.model.message.session];
}

/**
 更新UI

 @param attachment attachment
 */
- (void)updateUIWithAttachment:(XCGuildAttachment *)attachment {
    BOOL isCommonNotice = attachment.second == Custom_Noti_Sub_HALL_NOTICE;
    self.controlPanelView.hidden = isCommonNotice;
    
    CGFloat panelViewHeight = [self.attachment panelViewHeight];
    [self.controlPanelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(panelViewHeight);
    }];
    
    self.titleLabel.text = attachment.layout.title.content;
    self.titleLabel.textColor = [UIColor colorWithHexString:attachment.layout.title.fontColor.length>0 ? attachment.layout.title.fontColor : @"#333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:[attachment.layout.title.fontSize floatValue]>0 ? [attachment.layout.title.fontSize floatValue] : 15.f weight:attachment.layout.title.fontBold ? UIFontWeightBold : UIFontWeightRegular];
    
    [[TTSessionRichTextParser shareParser] creatMessageContentAttributeWithMessageBusiness:attachment messageId:self.model.message.messageId completionHandler:^(NSMutableAttributedString *attr) {
        
        self.contentLabel.attributedText = attr;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getters and Setters
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [XCTheme getTTSubTextColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (XCGuildMessageContentControlView *)controlPanelView {
    if (!_controlPanelView) {
        _controlPanelView = [[XCGuildMessageContentControlView alloc] init];
        _controlPanelView.clipsToBounds = YES;
        [_controlPanelView.agreeButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_controlPanelView.rejectButton addTarget:self action:@selector(rejectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlPanelView;
}

@end
