//
//  TTGoddessChatContentCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGoddessChatContentCell.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler.h"

#import "Attachment.h"
#import "GiftAllMicroSendInfo.h"

#import <NIMSDK/NIMSDK.h>
#import <NIMSDK/NIMCustomObject.h>
#import "NIMKitInfoFetchOption.h"
#import "NIMMessageModel.h"
#import "NIMKit.h"
#import "NIMKitInfoFetchOption.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

//头像大小
CGFloat const TTGoddessChatContentCellAvatarSize = 20.0f;
//头像和文本间距
CGFloat const TTGoddessChatContentCellInterval = 6.0f;
//文本最大长度
CGFloat const TTGoddessChatContentCellLabelMaxWidth = 130.0f;

@interface TTGoddessChatContentCell ()

@property (nonatomic, strong) UIImageView *firstAvatarImageView;//头像1
@property (nonatomic, strong) YYLabel *firstChatLabel;//聊天1

@property (nonatomic, strong) UIImageView *secondAvatarImageView;//头像2
@property (nonatomic, strong) YYLabel *secondChatLabel;//聊天2

@end

@implementation TTGoddessChatContentCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.firstAvatarImageView];
    [self addSubview:self.firstChatLabel];
    [self addSubview:self.secondAvatarImageView];
    [self addSubview:self.secondChatLabel];
}

- (void)initConstraints {
    [self.firstAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(TTGoddessChatContentCellAvatarSize, TTGoddessChatContentCellAvatarSize));
    }];
    
    [self.firstChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.firstAvatarImageView);
        make.left.mas_equalTo(self.firstAvatarImageView.mas_right).offset(TTGoddessChatContentCellInterval);
        make.width.mas_equalTo(TTGoddessChatContentCellLabelMaxWidth);
    }];
    
    [self.secondAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstAvatarImageView.mas_bottom).offset(6);
        make.left.width.height.mas_equalTo(self.firstAvatarImageView);
    }];
    
    [self.secondChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.secondAvatarImageView);
        make.left.width.mas_equalTo(self.firstChatLabel);
    }];
}

#pragma mark Make Gift Text
- (NSMutableAttributedString *)sendGiftText:(Attachment *)attachment {
    
    GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];

    //发送者名称
//    NSMutableAttributedString *nick = [[NSMutableAttributedString alloc]initWithString:info.nick];
//    [nick addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTDeepGrayTextColor] range:NSMakeRange(0, nick.length)];
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
//    [string appendAttributedString:nick];
//    [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];

    //送
    NSMutableAttributedString *give = [BaseAttrbutedStringHandler creatStrAttrByStr:@"赠送"];
    [give addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTDeepGrayTextColor] range:NSMakeRange(0, give.length)];
    [string appendAttributedString:give];
    [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
    
    //接受者名称
    NSMutableAttributedString *receiveNick = [BaseAttrbutedStringHandler creatStrAttrByStr:info.targetNick];
    [receiveNick addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTDeepGrayTextColor] range:NSMakeRange(0, receiveNick.length)];
    [string appendAttributedString:receiveNick];
    [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
    
    //礼物图片
    [string appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 20, 20) urlString:info.giftInfo.giftUrl imageName:nil]];
    [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
    
    //数量
    NSMutableAttributedString *count = [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"X%ld", (long)info.giftNum]];
    [count addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTDeepGrayTextColor] range:NSMakeRange(0, count.length)];
    [string appendAttributedString:count];
    
    return string;
}

/**
 构造显示内容富文本
 */
- (NSMutableAttributedString *)contentText:(NIMMessageModel *)model {
    
    NSMutableAttributedString *content = nil;
    
    id<NIMMessageObject> obj = model.message.messageObject;
    if ([obj isKindOfClass:NIMCustomObject.class]) {
        
        Attachment *att = (Attachment *)[(NIMCustomObject *)obj attachment];
        
        if ([att isKindOfClass:Attachment.class]) {
            
            // 送礼
            if (att.first == Custom_Noti_Header_PublicChatroom &&
                att.second == Custom_Noti_Sub_PublicChatroom_Send_Gift) {
                
                content = [self sendGiftText:att];
                
            } else if (att.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                
                content = [[NSMutableAttributedString alloc] initWithString:@"我发起了一个游戏，快来玩" attributes:@{NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}];
                
            } else {
                content = model.messageAttributedString;
            }
        }
        
    } else {
        // 普通文本
        content = model.messageAttributedString;
    }
    
    return content;
}

#pragma mark - Getters and Setters
- (void)setModelArray:(NSArray<NIMMessageModel *> *)modelArray {
    _modelArray = modelArray;
    
    if (_modelArray.count == 0) {
        return;
    }
    
    NIMMessageModel *topModel = [modelArray safeObjectAtIndex:0];
    NIMMessageModel *bottomModel = [modelArray safeObjectAtIndex:1];
    
    topModel.messageAttributedString.yy_color = [XCTheme getTTDeepGrayTextColor];
    bottomModel.messageAttributedString.yy_color = [XCTheme getTTDeepGrayTextColor];

    self.firstChatLabel.hidden = topModel == nil;
    self.firstAvatarImageView.hidden = topModel == nil;
    self.secondChatLabel.hidden = bottomModel == nil;
    self.secondAvatarImageView.hidden = bottomModel == nil;
    
    NIMMessage *message = topModel.message;
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.message = message;
    
    NIMKitInfo *info = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
    
    [self.firstAvatarImageView qn_setImageImageWithUrl:info.avatarUrlString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    message = bottomModel.message;
    object = (NIMCustomObject *)message.messageObject;
    option.message = message;
    info = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
    
    [self.secondAvatarImageView qn_setImageImageWithUrl:info.avatarUrlString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    //content
    self.firstChatLabel.attributedText = [self contentText:topModel];
    self.secondChatLabel.attributedText = [self contentText:bottomModel];
}

- (YYLabel *)firstChatLabel {
    if (_firstChatLabel == nil) {
        YYLabel *label = [[YYLabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _firstChatLabel = label;
    }
    return _firstChatLabel;
}

- (UIImageView *)firstAvatarImageView {
    if (_firstAvatarImageView == nil) {
        _firstAvatarImageView = [[UIImageView alloc] init];
        _firstAvatarImageView.layer.cornerRadius = TTGoddessChatContentCellAvatarSize/2.0f;
        _firstAvatarImageView.layer.masksToBounds = YES;
    }
    return _firstAvatarImageView;
}

- (YYLabel *)secondChatLabel {
    if (_secondChatLabel == nil) {
        YYLabel *label = [[YYLabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _secondChatLabel = label;
    }
    return _secondChatLabel;
}

- (UIImageView *)secondAvatarImageView {
    if (_secondAvatarImageView == nil) {
        _secondAvatarImageView = [[UIImageView alloc] init];
        _secondAvatarImageView.layer.cornerRadius = TTGoddessChatContentCellAvatarSize/2.0f;
        _secondAvatarImageView.layer.masksToBounds = YES;
    }
    return _secondAvatarImageView;
}

@end
