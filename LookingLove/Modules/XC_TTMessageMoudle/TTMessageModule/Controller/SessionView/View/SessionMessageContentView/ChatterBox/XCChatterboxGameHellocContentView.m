//
//  XCChatterboxGameHellocContentView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/18.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCChatterboxGameHellocContentView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>
#import "XCChatterboxAttachment.h"
#import "TTChatterboxGameModel.h"
#import "ImMessageCore.h"
#import "BaseAttrbutedStringHandler.h"

NSString * const XCChatterboxGameHellocContentViewClick = @"XCChatterboxGameHellocContentViewClick";

@interface XCChatterboxGameHellocContentView ()

/** 显示话匣子的*/
@property (nonatomic,strong) YYLabel *contentLabel;

/** 话匣子游戏的按钮*/
@property (nonatomic,strong) UIButton *chatterBoxGameButton;
@end


@implementation XCChatterboxGameHellocContentView
#pragma mark - lift cycle
- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)chatterBoxGameButtonAction:(UIButton *)sender {
    [self updateChatterBoxMessage];
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCChatterboxGameHellocContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject * customObject = data.message.messageObject;
    Attachment * attach = (Attachment *)customObject.attachment;
    if (attach.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
        if (attach.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
            if (self.model.message.localExt) {
                 TTChatterboxGameModel * model = [TTChatterboxGameModel yy_modelWithJSON:self.model.message.localExt];
                [self changeChatterBoxGameButtonBackColorWithIsShow:model.isShow];
            }else {
                 TTChatterboxGameModel * model = [TTChatterboxGameModel yy_modelWithJSON:attach.data];
                [self changeChatterBoxGameButtonBackColorWithIsShow:model.isShow];
            }
            self.contentLabel.attributedText = [self creatChatterBoxGameContentAttribute];
        }
    }
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.contentLabel];
    [self addSubview:self.chatterBoxGameButton];
    self.bubbleImageView.hidden = YES;
    self.bubbleImageView.userInteractionEnabled = NO;
    [self.chatterBoxGameButton addTarget:self action:@selector(chatterBoxGameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableAttributedString *)creatChatterBoxGameContentAttribute {
    NSMutableAttributedString * attrtbuting = [[NSMutableAttributedString alloc] init];
    [attrtbuting appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 28, 28) urlString:nil imageName:@"chat_say_game"]];
    [attrtbuting appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
    [attrtbuting appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"打开话匣子和对方互动一下吧~" attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}]];
    return attrtbuting;
}

- (void)initContrations {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(15);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.chatterBoxGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 28));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(24);
    }];
}

- (void)changeChatterBoxGameButtonBackColorWithIsShow:(BOOL)isShow {
    if (isShow) {
        self.chatterBoxGameButton.userInteractionEnabled = NO;
        [self.chatterBoxGameButton setBackgroundColor:UIColorFromRGB(0xf0f0f2)];
        [self.chatterBoxGameButton setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
        [self.chatterBoxGameButton setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateSelected];
    }else {
        self.chatterBoxGameButton.userInteractionEnabled = YES;
        [self.chatterBoxGameButton setBackgroundColor:[UIColor whiteColor]];
        [self.chatterBoxGameButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [self.chatterBoxGameButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
    }
}

- (void)updateChatterBoxMessage {
    
    TTChatterboxGameModel * model = [[TTChatterboxGameModel alloc] init];
    model.isShow = YES;
    self.model.message.localExt = [model model2dictionary];
    [GetCore(ImMessageCore) updateMessage:self.model.message session:self.model.message.session];
}

#pragma mark - setters and getters
- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
    }
    return _contentLabel;
}

- (UIButton *)chatterBoxGameButton {
    if (!_chatterBoxGameButton) {
        _chatterBoxGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatterBoxGameButton setTitle:@"话匣子游戏" forState:UIControlStateNormal];
        [_chatterBoxGameButton setTitle:@"话匣子游戏" forState:UIControlStateSelected];
        _chatterBoxGameButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _chatterBoxGameButton.layer.masksToBounds = YES;
        _chatterBoxGameButton.layer.cornerRadius = 14;
    }
    return _chatterBoxGameButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
