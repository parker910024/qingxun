//
//  TTPublicGiftSpringView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/2.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicGiftSpringView.h"

//view
#import "SVGAImageView.h"

//tool
#import "UIImageView+QiNiu.h"

//3rd part
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"

@interface TTPublicGiftSpringView ()

/**
 发送者头像
 */
@property (strong, nonatomic) UIImageView *senderAvatar;

/**
 赠送字眼
 */
@property (strong, nonatomic) UILabel *sendContent;

/**
 接受者头像
 */
@property (strong, nonatomic) UIImageView *receiverAvatar;

/**
 礼物图片
 */
@property (strong, nonatomic) UIImageView *giftPic;

/**
 礼物数量
 */
@property (strong, nonatomic) UILabel *numberLabel;



@end

@implementation TTPublicGiftSpringView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.svgaImageView];
    [self addSubview:self.senderAvatar];
    [self addSubview:self.sendContent];
    [self addSubview:self.receiverAvatar];
    [self addSubview:self.giftPic];
    [self addSubview:self.numberLabel];
}

- (void)initConstrations {
    [self.svgaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.width.height.mas_equalTo(self);
        make.center.mas_equalTo(self.center);
    }];
    [self.senderAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(36);
        make.top.mas_equalTo(self.mas_top).offset(40);
        make.width.height.mas_equalTo(50);
    }];
    [self.sendContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.senderAvatar.mas_trailing).offset(8);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.senderAvatar.mas_centerY);
    }];
    [self.receiverAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sendContent.mas_trailing).offset(8);
        make.centerY.mas_equalTo(self.senderAvatar.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    [self.giftPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.receiverAvatar.mas_trailing).offset(15);
        make.width.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.receiverAvatar.mas_centerY).offset(-10);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftPic.mas_bottom).offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(18);
        make.centerX.mas_equalTo(self.giftPic.mas_centerX);
    }];
}

#pragma mark settter & getter

- (void)setInfo:(GiftAllMicroSendInfo *)info {
    _info = info;
    [self.senderAvatar qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:(ImageType)ImageTypeUserIcon cornerRadious:60];
    [self.receiverAvatar qn_setImageImageWithUrl:info.targetAvatar placeholderImage:[XCTheme defaultTheme].default_avatar type:(ImageType)ImageTypeUserIcon cornerRadious:60];
    [self.giftPic qn_setImageImageWithUrl:info.gift.giftUrl placeholderImage:[XCTheme defaultTheme].default_avatar type:(ImageType)ImageTypeUserIcon cornerRadious:60];
    [self.numberLabel setText:[NSString stringWithFormat:@"X%ld",(long)info.giftNum]];
    
}

- (SVGAImageView *)svgaImageView {
    if (!_svgaImageView) {
        _svgaImageView = [[SVGAImageView alloc]init];
        _svgaImageView.contentMode = UIViewContentModeCenter;
    }
    return _svgaImageView;
}

- (UIImageView *)senderAvatar {
    if (!_senderAvatar) {
        _senderAvatar = [[UIImageView alloc]init];
        _senderAvatar.layer.masksToBounds = YES;
        _senderAvatar.layer.cornerRadius = 25.f;
        _senderAvatar.layer.borderWidth = 2.f;
        _senderAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _senderAvatar;
}

- (UIImageView *)receiverAvatar {
    if (!_receiverAvatar) {
        _receiverAvatar = [[UIImageView alloc]init];
        _receiverAvatar.layer.masksToBounds = YES;
        _receiverAvatar.layer.cornerRadius = 25.f;
        _receiverAvatar.layer.borderWidth = 2.f;
        _receiverAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _receiverAvatar;
}

- (UILabel *)sendContent {
    if (!_sendContent) {
        _sendContent = [[UILabel alloc]init];
        _sendContent.text = @"赠送";
        _sendContent.font = [UIFont systemFontOfSize:11.f];
        _sendContent.textAlignment = NSTextAlignmentCenter;
        _sendContent.textColor =UIColorFromRGB(0xFE5F0F);
        _sendContent.backgroundColor = UIColorFromRGB(0xffffff);
        _sendContent.layer.masksToBounds = YES;
        _sendContent.layer.cornerRadius = 8.5f;
    }
    return _sendContent;
}

- (UIImageView *)giftPic {
    if (!_giftPic) {
        _giftPic = [[UIImageView alloc]init];
        
    }
    return _giftPic;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:13.f];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor =UIColorFromRGB(0xFE5F0F);
        _numberLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.layer.cornerRadius = 8.5f;
    }
    return _numberLabel;
}

@end
