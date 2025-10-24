//
//  TTMessageFaceCell.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageFaceCell.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "SingleNobleInfo.h"
#import "TTNobleSourceHandler.h"
#import "TTMessageViewConst.h"

@interface TTMessageFaceCell()

@end

@implementation TTMessageFaceCell

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
        self.messageBgView.hidden = YES;
        self.chatBubleImageView.hidden = NO;
        [TTNobleSourceHandler handlerImageView:self.chatBubleImageView soure:nobleInfo.bubble imageType:ImageTypeRoomChatBuble];
    }else{
        self.messageBgView.hidden = NO;
        self.chatBubleImageView.hidden = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TTMessageFaceCell";
    TTMessageFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TTMessageFaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - Private
- (void)setupSubView{
    
    self.layer.drawsAsynchronously = YES;
//    self.messageLabel.displaysAsynchronously = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.chatBubleImageView];
    [self.contentView addSubview:self.messageBgView];
    [self.contentView addSubview:self.messageLabel];
}
- (void)setupConstraints{
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.chatBubleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageLabel).offset(-12);
        make.right.equalTo(self.messageLabel).offset(8);
        make.top.equalTo(self.messageLabel).offset(-8);
        make.bottom.equalTo(self.messageLabel).offset(8);
    }];
    [self.messageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.messageLabel);
        make.width.equalTo(self.messageLabel).offset(20);
        make.height.equalTo(self.messageLabel).offset(14);
    }];
}

#pragma mark - Getter
- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc]init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _messageLabel;
}

- (UIView *)messageBgView {
    if (!_messageBgView) {
        _messageBgView = [[UIView alloc]init];
        _messageBgView.backgroundColor = UIColorRGBAlpha(0x000000, 0.16);
        _messageBgView.layer.cornerRadius = TTMessageViewCellBubbleCornerRadius;
        _messageBgView.userInteractionEnabled = NO;
    }
    return _messageBgView;
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
