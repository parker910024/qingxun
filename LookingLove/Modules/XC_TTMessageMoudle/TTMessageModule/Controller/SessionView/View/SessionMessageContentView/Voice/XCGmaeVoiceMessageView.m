//
//  XCGmaeVoiceMessageView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCGmaeVoiceMessageView.h"
#import <YYText/YYLabel.h>
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface XCGmaeVoiceMessageView ()
/** 标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/** 内容*/
@property (nonatomic,strong) YYLabel *contentLabel;
/** 去录制*/
@property (nonatomic,strong) UIButton *actionButton;
@end

@implementation XCGmaeVoiceMessageView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
//        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)actionButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gameVoiceMessage:didClickButtonWith:)]) {
        [self.delegate gameVoiceMessage:self didClickButtonWith:self.attach.routerType];
    }
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.actionButton];
    
    [self.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.left.right.mas_equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-26);
    }];
}

#pragma mark - setters and getters
- (void)setAttach:(XCGameVoiceBottleAttachment *)attach {
    _attach = attach;
    if (attach.first == Custom_Noti_Header_Game_VoiceBottle) {
        if (attach.second == Custom_Noti_Sub_Voice_Bottle_Recording) {
            NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[XCTheme getTTMainTextColor]};
            NSString * reason = [NSString stringWithFormat:@"%@", attach.reason];
            NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] init];
            [attribut appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"你录制的声音没有通过审核，理由为：" attributes:dic]];
            [attribut appendAttributedString:[[NSMutableAttributedString alloc] initWithString:reason attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[XCTheme getTTMainColor]}]];
            [attribut appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"快重新录制一条吧~" attributes:dic]];
            NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 5;
            NSRange range = NSMakeRange(0, [attribut length]);
            [attribut addAttribute:NSParagraphStyleAttributeName value:style range:range];
            self.contentLabel.attributedText = attribut;
            [self.actionButton setTitle:@"我的声音" forState:UIControlStateNormal];
        }else if (attach.second == Custom_Noti_Sub_Voice_Bottle_Matching) {
            NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[XCTheme getTTMainTextColor]};
            NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 5;
            NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:@"恭喜你录制的声音成功通过审核！快来声音瓶子邂逅Ta~" attributes:dic];
            NSRange range = NSMakeRange(0, [attribut length]);
            [attribut addAttribute:NSParagraphStyleAttributeName value:style range:range];
            self.contentLabel.attributedText = attribut;
            [self.actionButton setTitle:@"声音匹配" forState:UIControlStateNormal];
        }
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"声音瓶子通知";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.preferredMaxLayoutWidth = 245-30;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setBackgroundColor:[XCTheme getTTMainColor]];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _actionButton.layer.masksToBounds = YES;
        _actionButton.layer.cornerRadius = 20;
        [_actionButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _actionButton;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
