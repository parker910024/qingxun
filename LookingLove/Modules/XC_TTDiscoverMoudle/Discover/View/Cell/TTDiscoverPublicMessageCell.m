//
//  TTDiscoverPublicMessageCell.m
//  TuTu
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTDiscoverPublicMessageCell.h"

#import <YYText/YYText.h>

#import <Masonry/Masonry.h>

//nim
#import "NIMKit.h"
#import "NIMKitInfoFetchOption.h"

//attr
#import "TTPublicChatAttrbutedStringHandler.h"

//core
#import "AuthCore.h"
#import "UserCore.h"

//model
#import <NIMSDK/NIMSDK.h>

//tool
#import "TTPublicChatDataHelper.h"
#import "TTPublicChatProvider.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "XCCPGamePrivateAttachment.h"
#import <NIMSDK/NIMCustomObject.h>
#import "PublicChatroomMessageHelper.h"


#import "TTGameCPPrivateChatModel.h"
#import "PublicGameCache.h"

@interface TTDiscoverPublicMessageCell ()

/**
 用户名label
 */
@property (strong, nonatomic) YYLabel *usernameLabel;

/**
 头像
 */
@property (strong, nonatomic) UIImageView *avatar;

/**
 背景图片
 */
@property (strong, nonatomic) UIImageView *backgroudImage;

/**
 内容
 */
@property (strong, nonatomic) YYLabel *contentLabel;

/// 红包富文本，罗小黑 在这是个房间昵称发了一个     “大家快来抢啊~” 点我 带你去抢红包 >
@property (strong, nonatomic) YYLabel *redLabel;

@property (nonatomic, assign) BOOL hadLayout;

@end

@implementation TTDiscoverPublicMessageCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.backgroudImage];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.redLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatarPress:)];
    [self.avatar addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatarLongPress:)];
    [self.avatar addGestureRecognizer:longPress];
}

- (void)initConstrations {
    
}

#pragma mark - private method

- (UIImage *)disposeBubbleImage:(UIImage *)image {
    CGFloat topBottom = image.size.height * 0.5;
    CGFloat leftRight = image.size.width * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(topBottom, leftRight, topBottom, leftRight);
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
    return newImage;
}

#pragma mark - user respone

- (void)onAvatarPress:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(onTapAvatar:)]) {
        [self.delegate onTapAvatar:self.messageModel.message];
    }
}

- (void)onAvatarLongPress:(UILongPressGestureRecognizer *)longTap {
    if ([self.delegate respondsToSelector:@selector(onLongPressAvatar:)]) {
        [self.delegate onLongPressAvatar:self.messageModel.message];
    }
}

#pragma mark - setter & getter

- (void)setMessageModel:(NIMMessageModel *)messageModel {
    _messageModel = messageModel;
    
    if (messageModel) {
        NIMMessage *message = messageModel.message;
        
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        
        Attachment *attachment = (Attachment *)object.attachment;
        
        _usernameLabel.attributedText = messageModel.nameAttributedString;
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.message = message;
        
        NIMKitInfo *info = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
        [_avatar qn_setImageImageWithUrl:info.avatarUrlString placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        
        if (object) {
            if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"我发起了一个游戏，快来玩"];
            }else{
                self.contentLabel.attributedText = messageModel.messageAttributedString;
            }
        }else{
            self.contentLabel.attributedText = messageModel.messageAttributedString;
        }
        
        //红包
        BOOL roomRed = attachment.first == Custom_Noti_Header_Red && attachment.first == Custom_Noti_Header_Red;
        self.avatar.hidden = roomRed;
        self.usernameLabel.hidden = roomRed;
        self.contentLabel.hidden = roomRed;
        self.backgroudImage.hidden = roomRed;
        self.redLabel.hidden = !roomRed;
        
        if (roomRed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.redLabel.attributedText = messageModel.messageAttributedString;
            });
            
            [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.left.right.mas_equalTo(self.contentView).inset(50);
            }];
        }
        
        //设置背景气泡
        _backgroudImage.image = [self disposeBubbleImage:[UIImage imageNamed:messageModel.bgName]];
        
        if (!self.hadLayout) {
            self.hadLayout = NO;
            if (messageModel.isMe) {
                [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.contentView.mas_top).offset(5);
                    make.right.mas_equalTo(-20);
                    make.width.height.mas_equalTo(40);
                }];
                
                [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.avatar.mas_left).offset(-10);
                    make.top.mas_equalTo(self.avatar.mas_top).offset(6);
                    make.height.mas_equalTo(15);
                }];
                [self.backgroudImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(10);
                    make.right.mas_equalTo(self.usernameLabel);
                    make.left.mas_greaterThanOrEqualTo(20);
                    make.bottom.mas_lessThanOrEqualTo(-10);
                }];
                [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.mas_equalTo(self.backgroudImage);
                }];
            }else {
                [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.contentView.mas_top).offset(5);
                    make.left.mas_equalTo(20);
                    make.width.height.mas_equalTo(40);
                }];
                [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.avatar.mas_right).offset(10);
                    make.top.mas_equalTo(self.avatar.mas_top).offset(6);
                    make.height.mas_equalTo(15);
                }];
                [self.backgroudImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(10);
                    make.left.mas_equalTo(self.usernameLabel);
                    make.right.mas_equalTo(-20);
                    make.bottom.mas_lessThanOrEqualTo(-10);
                }];
                [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.mas_equalTo(self.backgroudImage);
                }];
            }
        }
    }
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc]init];
        _avatar.userInteractionEnabled = YES;
        _avatar.layer.cornerRadius = 20;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (YYLabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[YYLabel alloc]init];
        _usernameLabel.numberOfLines = 0;
        // 屏幕宽度 - 2 * 头像宽度 - 2 * (2 * 头像 offset ) - 右边界 offset
        _usernameLabel.preferredMaxLayoutWidth = KScreenWidth - 2 * 40 - 4 * 10 - 15;
    }
    return _usernameLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc]init];
        //0.67为UI设计然后算出的宽度
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width * 0.67;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}

- (UIImageView *)backgroudImage {
    if (!_backgroudImage) {
        _backgroudImage = [[UIImageView alloc]init];
    }
    return _backgroudImage;
}

- (YYLabel *)redLabel {
    if (!_redLabel) {
        _redLabel = [[YYLabel alloc] init];
        _redLabel.textAlignment = NSTextAlignmentCenter;
        _redLabel.numberOfLines = 0;
        _redLabel.backgroundColor = UIColorRGBAlpha(0x0c0c1f, 0.14);
        _redLabel.hidden = YES;
        
        _redLabel.layer.cornerRadius = 8;
        _redLabel.layer.masksToBounds = YES;
    }
    return _redLabel;
}

@end
