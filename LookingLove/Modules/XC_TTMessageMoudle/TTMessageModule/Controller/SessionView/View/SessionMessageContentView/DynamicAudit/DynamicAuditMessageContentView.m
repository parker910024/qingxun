//
//  DynamicAuditMessageContentView.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/11/29.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "DynamicAuditMessageContentView.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "UIView+NTES.h"
#import "XCHUDTool.h"
#import "UIColor+UIColor_Hex.h"
#import "TTSessionRichTextParser.h"

#import "XCDynamicAuditAttachment.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "ImMessageCore.h"

@interface DynamicAuditMessageContentView ()
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *contentLabel;//内容
@property (nonatomic, strong) UILabel *timeLabel;//时间

@end

@implementation DynamicAuditMessageContentView

#pragma mark - Life Cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        [self initView];
        [self setupConstraints];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCDynamicAuditAttachment *attachment;
    
    if (data.message.localExt) {
        Attachment *att = (Attachment *)object.attachment;

        XCDynamicAuditAttachment *attach = [XCDynamicAuditAttachment yy_modelWithJSON:data.message.localExt];
        attach.layout = [MessageLayout yy_modelWithJSON:data.message.localExt[@"layout"]];
        attach.first = att.first;
        attach.second = att.second;
        
        attachment = attach;

    } else {
        if ([object.attachment isKindOfClass:[XCDynamicAuditAttachment class]]) {
            attachment = (XCDynamicAuditAttachment *)object.attachment;
        } else if ([object.attachment isKindOfClass:[Attachment class]]) {
            Attachment *att = (Attachment *)object.attachment;
            attachment = [XCDynamicAuditAttachment yy_modelWithJSON:att.data];
        }
        
        data.message.localExt = [attachment model2dictionary];
    }
    
    [self updateUIWithAttachment:attachment];
}

#pragma mark - Private Methods
- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
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
        make.bottom.mas_lessThanOrEqualTo(-8);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-15);
    }];
}

/**
 更新UI

 @param attachment attachment
 */
- (void)updateUIWithAttachment:(XCDynamicAuditAttachment *)attachment {
    
    self.timeLabel.text = attachment.layout.time.content;
    
    self.titleLabel.text = attachment.layout.title.content;
    self.titleLabel.textColor = [UIColor colorWithHexString:attachment.layout.title.fontColor.length>0 ? attachment.layout.title.fontColor : @"#333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:[attachment.layout.title.fontSize floatValue]>0 ? [attachment.layout.title.fontSize floatValue] : 15.f weight:attachment.layout.title.fontBold ? UIFontWeightBold : UIFontWeightRegular];
    
    [[TTSessionRichTextParser shareParser] creatMessageContentAttributeWithMessageBusiness:(MessageBussiness *)attachment messageId:self.model.message.messageId completionHandler:^(NSMutableAttributedString *attr) {
        
        self.contentLabel.attributedText = attr;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getters and Setters
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [XCTheme getTTMainTextColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _timeLabel;
}

@end
