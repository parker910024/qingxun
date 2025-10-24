//
//  MessageCommonView.m
//  XChat
//
//  Created by 卫明何 on 2018/5/28.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "MessageCommonView.h"
#import <YYLabel.h>
#import "MessageBussiness.h"
#import "UIColor+UIColor_Hex.h"
#import "PLTimeUtil.h"
#import "TTSessionRichTextParser.h"
#import "NSObject+YYModel.h"

#import <Masonry/Masonry.h>

#import "XCMacros.h"
#import "XCTheme.h"

#define ControlPanelViewHeight 40.f

NSString * const MessageCommonViewClick = @"MessageCommonView";

@interface MessageCommonView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) YYLabel *contentLabel;
@property (strong, nonatomic) TTMessageCommonControlView  *controlPanelView;
@end

@implementation MessageCommonView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        [self initView];
        [self initConstraints];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.controlPanelView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.leading.mas_equalTo(self.mas_leading).offset(15);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(KScreenWidth * 0.3);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
        make.trailing.mas_equalTo(self.dateLabel.mas_trailing);
        make.bottom.mas_equalTo(self.controlPanelView.mas_top);
    }];
    [self.controlPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.height.mas_equalTo(ControlPanelViewHeight);
    }];
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    MessageBussiness *customObject;
    Attachment * att = (Attachment *)object.attachment;
    if (data.message.localExt) {
        MessageBussiness *bus = [MessageBussiness yy_modelWithJSON:data.message.localExt];
        bus.layout = [MessageLayout yy_modelWithJSON:data.message.localExt[@"layout"]];
        customObject = bus;
        bus.first = att.first;
        bus.second = att.second;
    }else {
        if ([object.attachment isKindOfClass:[MessageBussiness class]]) {
            customObject = (MessageBussiness *)object.attachment;
        }else if ([object.attachment isKindOfClass:[Attachment class]]) {
            Attachment * att = (Attachment *)object.attachment;
            customObject = [MessageBussiness yy_modelWithJSON:att.data];
        }
        data.message.localExt = [customObject model2dictionary];
    }
    
    
    
    if (customObject.status > 0 || customObject.second == Custom_Noti_Sub_Header_Message_Handle_Bussiness || customObject.second == Custom_Noti_Sub_OfficialAnchorCertification_Bussiness) {
        self.controlPanelView.hidden = NO;
        [self.controlPanelView setBussiness:customObject];
        [self.controlPanelView setMessage:data.message];
        [self.controlPanelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(ControlPanelViewHeight);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.dateLabel.mas_trailing);
            make.bottom.mas_equalTo(self.controlPanelView.mas_top);
        }];
    }else {
        self.controlPanelView.hidden = YES;
        [self.controlPanelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(0);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.dateLabel.mas_trailing);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        }];
    }
    self.titleLabel.text = customObject.layout.title.content;
    self.titleLabel.textColor = [UIColor colorWithHexString:customObject.layout.title.fontColor.length>0?customObject.layout.title.fontColor:@"#333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:[customObject.layout.title.fontSize floatValue]>0?[customObject.layout.title.fontSize floatValue]:15.f weight:customObject.layout.title.fontBold?UIFontWeightBold:UIFontWeightRegular];
    self.contentLabel.preferredMaxLayoutWidth = self.frame.size.width - 30;
    self.dateLabel.text = customObject.layout.time.content;
    self.dateLabel.textColor = [UIColor colorWithHexString:customObject.layout.time.fontColor.length>0?customObject.layout.time.fontColor:@"#999999"];
    self.dateLabel.font = [UIFont systemFontOfSize:[customObject.layout.time.fontSize floatValue]>0?[customObject.layout.time.fontSize floatValue]:12.f];
    @weakify(self);
    

    [[TTSessionRichTextParser shareParser]creatMessageContentAttributeWithMessageBusiness:customObject messageId:data.message.messageId completionHandler:^(NSMutableAttributedString *attr) {
        @strongify(self);
        self.contentLabel.attributedText = attr;
    } failure:^(NSError *error) {

    }];
    
    //计算时间的长度 优先显示时间
    CGFloat width = [self getDateLabelWidthWithDateStr:customObject];
    if (width <= 0) {
        return;
    }
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.width.mas_equalTo(KScreenWidth - 100 - width - 30);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = MessageCommonViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}


- (CGFloat)getDateLabelWidthWithDateStr:(MessageBussiness *)customObject{
    UIFont * font =   [UIFont systemFontOfSize:[customObject.layout.time.fontSize floatValue]>0?[customObject.layout.time.fontSize floatValue]:12.f];
    CGSize size = [customObject.layout.time.content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size ;
    return size.width + 5;
}


#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:12.f];
        _dateLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _dateLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc]init];
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (TTMessageCommonControlView *)controlPanelView {
    if (!_controlPanelView) {
        _controlPanelView = [[TTMessageCommonControlView alloc]init];
    }
    return _controlPanelView;
}


@end
