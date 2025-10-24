//
//  TTMessageSegmentView.m
//  XC_TTMessageMoudle
//
//  Created by Macx on 2019/4/12.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTMessageSegmentView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTMessageSegmentView ()
/** 消息按钮 */
@property (nonatomic, strong) UIButton *messageButton;
/** 联系人按钮 */
@property (nonatomic, strong) UIButton *contactsButton;
@end

@implementation TTMessageSegmentView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)updateButtonWithIndex:(NSInteger)index {
    
    if (index == 0) {
        self.messageButton.selected = YES;
        self.contactsButton.selected = NO;
        
        self.messageButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.contactsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        self.messageButton.selected = NO;
        self.contactsButton.selected = YES;
        
        self.messageButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.contactsButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickMessageButton:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageSegmentView:didSelectWithIndex:)]) {
        [self.delegate messageSegmentView:self didSelectWithIndex:0];
    }
    [self updateButtonWithIndex:0];
}

- (void)didClickContactsButton:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageSegmentView:didSelectWithIndex:)]) {
        [self.delegate messageSegmentView:self didSelectWithIndex:1];
    }
    [self updateButtonWithIndex:1];
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.messageButton];
    [self addSubview:self.contactsButton];
    
    [self.messageButton addTarget:self action:@selector(didClickMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contactsButton addTarget:self action:@selector(didClickContactsButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.mas_top).offset(13 + 20 + statusbarHeight);
    }];
    
    [self.contactsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(76);
        make.bottom.mas_equalTo(self.mas_top).offset(13 + 20 + statusbarHeight);
    }];
}

#pragma mark - getters and setters

- (UIButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] init];
        [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
        [_messageButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_messageButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
        _messageButton.titleLabel.font = [UIFont boldSystemFontOfSize:20]; // 20
    }
    return _messageButton;
}

- (UIButton *)contactsButton {
    if (!_contactsButton) {
        _contactsButton = [[UIButton alloc] init];
        [_contactsButton setTitle:@"联系人" forState:UIControlStateNormal];
        [_contactsButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_contactsButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
        _contactsButton.titleLabel.font = [UIFont boldSystemFontOfSize:20]; // 20
    }
    return _contactsButton;
}

@end
