//
//  TTHomeRecommendPublicChatSectionHeaderView.m
//  TuTu
//
//  Created by lvjunhang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendPublicChatSectionHeaderView.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTHomeRecommendPublicChatSectionHeaderView ()
@property (nonatomic, strong) UILabel *chatLabel;
@property (nonatomic, strong) UIView *chatContainerView;// 聊天内容橙色背景
@end

@implementation TTHomeRecommendPublicChatSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

- (void)initView {
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = UIColorFromRGB(0xfafafa);
    [self.contentView addSubview:self.chatContainerView];
    [self.chatContainerView addSubview:self.chatLabel];
}

- (void)initConstraints {
    [self.chatContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(20);
        make.right.mas_lessThanOrEqualTo(-20);
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(24);
    }];

    [self.chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.chatContainerView).inset(12);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - getter setter
- (void)setATmeName:(NSString *)ATmeName {
    self.chatLabel.text = [NSString stringWithFormat:@"新消息：你的好友%@在公聊大厅@你", ATmeName ?: @""];
}

- (UILabel *)chatLabel {
    if (_chatLabel == nil) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.font = [UIFont systemFontOfSize:13];
        _chatLabel.textColor = [XCTheme getTTMainColor];
        _chatLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _chatLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _chatLabel;
}

- (UIView *)chatContainerView {
    if (_chatContainerView == nil) {
        _chatContainerView = [[UIView alloc] init];
        _chatContainerView.backgroundColor = [[XCTheme getTTMainColor] colorWithAlphaComponent:0.2];
        _chatContainerView.layer.cornerRadius = 12;
        _chatContainerView.layer.masksToBounds = YES;
    }
    return _chatContainerView;
}
@end
