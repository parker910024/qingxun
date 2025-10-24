//
//  TTMessageTextCell.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageTextCell.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "SingleNobleInfo.h"
#import "TTNobleSourceHandler.h"
#import "TTMessageViewConst.h"

@interface TTMessageTextCell()

@end

@implementation TTMessageTextCell

#pragma mark - Life Style
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;//被选中的样式
        [self setupSubView];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - public
- (void)configCellWithAttributedString:(NSMutableAttributedString *)attributedString nobleInfo:(SingleNobleInfo *)nobleInfo{
    
    self.messageLabel.attributedText = attributedString;
    
    if (nobleInfo.bubble) {
        self.labelContentView.hidden = YES;
        self.chatBubleImageView.hidden = NO;
        [TTNobleSourceHandler handlerImageView:self.chatBubleImageView soure:nobleInfo.bubble imageType:ImageTypeRoomChatBuble];
    }else{
        self.labelContentView.hidden = NO;
        self.chatBubleImageView.hidden = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TTMessageTextCell";
    TTMessageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TTMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - Private

- (void)setupSubView{
    
    self.layer.drawsAsynchronously = YES;
//    self.messageLabel.displaysAsynchronously = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.chatBubleImageView];
    [self.contentView addSubview:self.labelContentView];
    [self.contentView addSubview:self.messageLabel];
}

- (void)setupConstraints{
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.chatBubleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageLabel).offset(-12);
        make.right.equalTo(self.messageLabel).offset(8);
        make.top.equalTo(self.messageLabel).offset(-5);
        make.bottom.equalTo(self.messageLabel).offset(5);
    }];
    [self.labelContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.messageLabel);
        make.width.equalTo(self.messageLabel).offset(20);
        make.height.equalTo(self.messageLabel).offset(14);
    }];
}

#pragma mark - Getter

- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _messageLabel;
}

- (UIView *)labelContentView {
    if (!_labelContentView) {
        _labelContentView = [[UIView alloc]init];
        _labelContentView.backgroundColor = UIColorRGBAlpha(0x000000, 0.16);
        _labelContentView.layer.cornerRadius = TTMessageViewCellBubbleCornerRadius;
    }
    return _labelContentView;
}

- (UIImageView *)chatBubleImageView {
    if (!_chatBubleImageView) {
        _chatBubleImageView = [[UIImageView alloc]init];
        _chatBubleImageView.layer.cornerRadius = TTMessageViewCellBubbleCornerRadius;
        _chatBubleImageView.layer.masksToBounds = YES;
    }
    return _chatBubleImageView;
}
@end
