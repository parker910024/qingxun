//
//  TTPublicMessageCell.m
//  TuTu
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicMessageCell.h"

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

@interface TTPublicMessageCell ()

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


@property (strong, nonatomic) YYLabel *gameOverLabel;


/// 红包富文本，罗小黑 在这是个房间昵称发了一个     “大家快来抢啊~” 点我 带你去抢红包 >
@property (strong, nonatomic) YYLabel *redLabel;

@property (nonatomic,assign) BOOL hadLayout;

@end

@implementation TTPublicMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


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
    self.discoverCell = NO;
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.backgroudImage];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.gameOverLabel];
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
        NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:message.messageId];
        
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        
        Attachment *attachment = (Attachment *)object.attachment;
        
        _usernameLabel.attributedText = messageModel.nameAttributedString;
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.message = message;
        
        NIMKitInfo *info = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
        [_avatar qn_setImageImageWithUrl:info.avatarUrlString placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        
        if (locationMessage.localExt) {
            [[PublicChatroomMessageHelper shareHelper] configAttrSyncWithMessage:locationMessage andModel:messageModel];
        }
        
        if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification) {
            if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_GameOver) {
                self.avatar.hidden = YES;
                self.usernameLabel.hidden = YES;
                self.contentLabel.hidden = YES;
                self.backgroudImage.hidden = YES;
                self.gameOverLabel.hidden = NO;
                self.redLabel.hidden = YES;
                
                self.gameOverLabel.attributedText = messageModel.messageAttributedString;
                
                [self.gameOverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.contentView.mas_top).offset(0);
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
                    make.center.mas_equalTo(self.contentView);
                }];
                
                [self.gameOverLabel layoutIfNeeded];
                self.gameOverLabel.layer.cornerRadius = 8;
                self.gameOverLabel.layer.masksToBounds = YES;
            }
            
        } else if (attachment.first == Custom_Noti_Header_Red) {
            if (attachment.second == Custom_Noti_Sub_Red_Room_Other) {
                
                self.avatar.hidden = YES;
                self.usernameLabel.hidden = YES;
                self.contentLabel.hidden = YES;
                self.backgroudImage.hidden = YES;
                self.gameOverLabel.hidden = YES;
                self.redLabel.hidden = NO;
                                
                self.redLabel.attributedText = messageModel.messageAttributedString;
                
                [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(10);
                    make.bottom.mas_equalTo(-10);
                    make.left.right.mas_equalTo(self.contentView).inset(50);
                }];
            }
            
        } else {
            self.avatar.hidden = NO;
            self.usernameLabel.hidden = NO;
            self.contentLabel.hidden = NO;
            self.backgroudImage.hidden = NO;
            self.gameOverLabel.hidden = YES;
            self.redLabel.hidden = YES;
            
            if (object) {
                if (!object.attachment){
                    self.avatar.hidden = YES;
                    self.usernameLabel.hidden = YES;
                    self.backgroudImage.hidden = YES;
                }
            }
            
            if (self.discoverCell == YES) {
                if (object) {
                    if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                        self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"我发起了一个游戏，快来玩"];
                    }else{
                        self.contentLabel.attributedText = messageModel.messageAttributedString;
                    }
                }else{
                    self.contentLabel.attributedText = messageModel.messageAttributedString;
                }
            }else{
                self.contentLabel.attributedText = messageModel.messageAttributedString;
            }
            
            _backgroudImage.image = [self disposeBubbleImage:[UIImage imageNamed:messageModel.bgName]];
            
            if (!self.hadLayout) {
                self.hadLayout = NO;
                if (messageModel.isMe) {
                    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
                        make.width.height.mas_equalTo(40);
                        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
                    }];
                    
                    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.trailing.mas_equalTo(self.avatar.mas_leading).offset(-10);
                        make.top.mas_equalTo(self.avatar.mas_top);
                        make.height.mas_equalTo(15);
                    }];
                    if (self.discoverCell == YES){
                        self.backgroudImage.hidden = NO;
                        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.trailing.mas_equalTo(self.avatar.mas_leading).offset(-20);
                            make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(18);
                            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
                        }];
                        
                        [self.backgroudImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(self.contentLabel.mas_leading).offset(-10);
                            make.trailing.mas_equalTo(self.contentLabel.mas_trailing).offset(10);
                            make.top.mas_equalTo(self.contentLabel.mas_top).offset(-10);
                            make.bottom.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
                        }];
                    }else{
                        if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                            self.backgroudImage.hidden = YES;
                            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.trailing.mas_equalTo(self.avatar.mas_leading).offset(-20);
                                make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(0);
                                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
                            }];
                        }else{
                            self.backgroudImage.hidden = NO;
                            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.trailing.mas_equalTo(self.avatar.mas_leading).offset(-20);
                                make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(18);
                                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
                            }];
                            
                            [self.backgroudImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.leading.mas_equalTo(self.contentLabel.mas_leading).offset(-10);
                                make.trailing.mas_equalTo(self.contentLabel.mas_trailing).offset(10);
                                make.top.mas_equalTo(self.contentLabel.mas_top).offset(-10);
                                make.bottom.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
                            }];
                        }
                    }
                    
                }else {
                    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
                        make.width.height.mas_equalTo(40);
                        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
                    }];
                    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.mas_equalTo(self.avatar.mas_trailing).offset(10);
                        make.top.mas_equalTo(self.avatar.mas_top);
                        make.height.mas_equalTo(15);
                    }];
                    if (self.discoverCell == YES){
                        self.backgroudImage.hidden = NO;
                        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(self.avatar.mas_trailing).offset(20);
                            make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(18);
                            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
                        }];
                        [self.backgroudImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(self.contentLabel.mas_leading).offset(-10);
                            make.trailing.mas_equalTo(self.contentLabel.mas_trailing).offset(10);
                            make.top.mas_equalTo(self.contentLabel.mas_top).offset(-10);
                            make.bottom.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
                        }];
                    }else{
                        if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                            self.backgroudImage.hidden = YES;
                            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.leading.mas_equalTo(self.avatar.mas_trailing).offset(20);
                                make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(0);
                                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
                            }];
                        }else{
                            self.backgroudImage.hidden = NO;
                            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.leading.mas_equalTo(self.avatar.mas_trailing).offset(20);
                                make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(18);
                                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
                            }];
                            [self.backgroudImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.leading.mas_equalTo(self.contentLabel.mas_leading).offset(-10);
                                make.trailing.mas_equalTo(self.contentLabel.mas_trailing).offset(10);
                                make.top.mas_equalTo(self.contentLabel.mas_top).offset(-10);
                                make.bottom.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
                            }];
                        }
                    }
                }
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
        // 屏幕宽度 - 2 * 头像宽度 - 2 * (2 * 头像 offset )
        _usernameLabel.preferredMaxLayoutWidth = KScreenWidth - 2 * 40 - 4 * 10 ;
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

- (YYLabel *)gameOverLabel {
    if (!_gameOverLabel) {
        _gameOverLabel = [[YYLabel alloc] init];
        //0.67为UI设计然后算出的宽度
        _gameOverLabel.textAlignment = NSTextAlignmentCenter;
        _gameOverLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width * 0.67;
        _gameOverLabel.numberOfLines = 0;
        _gameOverLabel.backgroundColor = UIColorFromRGB(0xD6D6D6);
//        _gameOverLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _gameOverLabel.hidden = YES;
    }
    return _gameOverLabel;
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

- (UIImageView *)backgroudImage {
    if (!_backgroudImage) {
        _backgroudImage = [[UIImageView alloc]init];
    }
    return _backgroudImage;
}


@end
