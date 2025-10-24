//
//  TTWorldletBottomView.m
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldletBottomView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "XCMediator+TTMessageMoudleBridge.h"
#import <YYLabel.h>
#import "AuthCore.h"
#import "ImMessageCoreClient.h"

@interface TTWorldletBottomView ()<ImMessageCoreClient>
@property (nonatomic, strong) UIView *contentView;
// 群聊
@property (nonatomic, strong) UIButton *messageBtn;
// 成员列表
@property (nonatomic, strong) UIButton *memberBtn;
// 加入小世界
@property (nonatomic, strong) UIButton *joinWorldletBtn;
// 阴影view
@property (nonatomic, strong) UIView *joinBtnShadowView;
// 发布小世界动态按钮
@property (nonatomic, strong) UIButton *postDynamicBtn;
// 未读消息
@property (nonatomic, strong) YYLabel *unReadLabel;
// 在线
@property (nonatomic, strong) YYLabel *onLineLabel;
@property (nonatomic, strong) UIView *leftView; // 左边
@property (nonatomic, strong) UIView *rightView; // 右边

@property (nonatomic, strong) UIView *lineView;
@end

@implementation TTWorldletBottomView

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        AddCoreClient(ImMessageCoreClient, self);
        
        [self addSubview:self.contentView];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:self.messageBtn];
        [self addSubview:self.memberBtn];
        [self addSubview:self.unReadLabel];
        [self addSubview:self.onLineLabel];
        [self addSubview:self.joinBtnShadowView];
        [self addSubview:self.joinWorldletBtn];
        [self addSubview:self.postDynamicBtn];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)onRecvAnMsg:(NIMMessage *)msg {
    if (msg.session.sessionId.userIDValue == self.model.tid.userIDValue) {
        if (self.model.tid.length > 0) {
            NSInteger number = [[XCMediator sharedInstance] ttMessageMoudle_GetLittleWorldTeamUnreadCountWithSessionId:self.model.tid];
            if (number <= 0) {
                self.unReadLabel.hidden = YES;
                return;
            }
            self.unReadLabel.hidden = NO;
            if (number > 99) {
                self.unReadLabel.text = @"99+";
                [self.unReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(32);
                }];
            } else if (number >= 10 && number <= 99) {
                self.unReadLabel.text = [NSString stringWithFormat:@"%ld",number];
                [self.unReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(20);
                }];
            } else {
                self.unReadLabel.text = [NSString stringWithFormat:@"%ld",number];
                [self.unReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(18);
                }];
            }
        } else {
            self.unReadLabel.hidden = YES;
        }
    }
}

- (void)setModel:(LittleWorldListItem *)model {
    _model = model;
    if (model.inWorld) {
        [self initView:YES];
        
        [self initConstraint:YES];
        
        if (self.model.tid.length > 0) {
            NSInteger number = [[XCMediator sharedInstance] ttMessageMoudle_GetLittleWorldTeamUnreadCountWithSessionId:self.model.tid];
            if (number <= 0) {
                self.unReadLabel.hidden = YES;
            } else {
                self.unReadLabel.hidden = NO;
                if (number > 99) {
                    self.unReadLabel.text = @"99+";
                    [self.unReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(32);
                    }];
                } else if (number >= 10 && number <= 99) {
                    self.unReadLabel.text = [NSString stringWithFormat:@"%ld",number];
                    [self.unReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(20);
                    }];
                } else {
                    self.unReadLabel.text = [NSString stringWithFormat:@"%ld",number];
                    [self.unReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(18);
                    }];
                }
            }
        } else {
            self.unReadLabel.hidden = YES;
        }
        
        if (model.onlineNum <= 0) {
            self.onLineLabel.hidden = YES;
        } else {
            self.onLineLabel.hidden = NO;
            if (model.onlineNum > 99) {
                self.onLineLabel.text = @"99+";
                [self.onLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(32);
                }];
            } else if (model.onlineNum >= 10 && model.onlineNum <= 99) {
                self.onLineLabel.text = [NSString stringWithFormat:@"%d",model.onlineNum];
                [self.onLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(20);
                }];
            } else {
                self.onLineLabel.text = [NSString stringWithFormat:@"%d",model.onlineNum];
                [self.onLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(18);
                }];
            }
        }
    } else {
        [self initView:NO];
        
        [self initConstraint:NO];
    }
}

- (void)initView:(BOOL)inWorld {
    if (inWorld) {
        self.messageBtn.hidden = NO;
        self.memberBtn.hidden = NO;
        self.joinWorldletBtn.hidden = YES;
        self.joinBtnShadowView.hidden = YES;
        self.postDynamicBtn.hidden = NO;
    } else {
        self.messageBtn.hidden = YES;
        self.memberBtn.hidden = YES;
        self.unReadLabel.hidden = YES;
        self.onLineLabel.hidden = YES;
        self.joinWorldletBtn.hidden = YES;
        self.joinBtnShadowView.hidden = YES;
        self.postDynamicBtn.hidden = YES;
    }
    
}

- (void)initConstraint:(BOOL)inWorld {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(64);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    if (inWorld) {
        [self.postDynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.height.width.mas_equalTo(49);
        }];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.postDynamicBtn.mas_left);
        }];
        
        [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.leftView);
            make.width.height.mas_equalTo(44);
        }];
    
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.postDynamicBtn.mas_right);
        }];
        
        [self.memberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.rightView);
            make.width.height.mas_equalTo(44);
        }];
        
        [self.unReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.messageBtn.mas_right).offset(-8);
            make.centerY.mas_equalTo(self.messageBtn.mas_top).offset(6);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(18);
        }];
        
        [self.onLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.memberBtn.mas_right).offset(-8);
            make.centerY.mas_equalTo(self.memberBtn.mas_top).offset(6);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(18);
        }];
    } else {
        [self.joinWorldletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(-20);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(55);
        }];
        
        [self.joinBtnShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.joinWorldletBtn);
            make.bottom.right.mas_equalTo(self.joinWorldletBtn).offset(5);
        }];
    }
}

#pragma mark --- 按钮方法 ---
// 进入群聊
- (void)messageBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterChatBtnClick:)]) {
        [self.delegate enterChatBtnClick:self];
        sender.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
        });
        self.unReadLabel.hidden = YES;
    }
}

// 小世界成员
- (void)memberBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(worldletMemberBtnClick:)]) {
        [self.delegate worldletMemberBtnClick:self];
        sender.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
        });
    }
}

// 发布小世界动态
- (void)postDynamicBtnClickAction:(UIButton *)postDynamicBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(postLittleWorldDynamicBtnClick:)]) {
        [self.delegate postLittleWorldDynamicBtnClick:self];
        postDynamicBtn.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            postDynamicBtn.userInteractionEnabled = YES;
        });
    }
}

#pragma mark --- 加入小世界 ---
- (void)joinWorldletBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(joinWorldletBtnClick:)]) {
        [self.delegate joinWorldletBtnClick:self];
        sender.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
        });
    }
}

#pragma mark --- setter ---
- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"worldletChat"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _messageBtn.hidden = YES;
    }
    return _messageBtn;
}

- (UIButton *)memberBtn {
    if (!_memberBtn) {
        _memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_memberBtn setImage:[UIImage imageNamed:@"worldletGroup"] forState:UIControlStateNormal];
        [_memberBtn addTarget:self action:@selector(memberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _memberBtn.hidden = YES;
    }
    return _memberBtn;
}

- (YYLabel *)unReadLabel {
    if (!_unReadLabel) {
        _unReadLabel = [[YYLabel alloc] init];
        _unReadLabel.backgroundColor = UIColorFromRGB(0xFF3B30);
        _unReadLabel.textColor = UIColorFromRGB(0xffffff);
        _unReadLabel.textAlignment = NSTextAlignmentCenter;
        _unReadLabel.font = [UIFont systemFontOfSize:12];
        _unReadLabel.layer.cornerRadius = 9;
        _unReadLabel.layer.masksToBounds = YES;
        _unReadLabel.hidden = YES;
        _unReadLabel.preferredMaxLayoutWidth = 32;
    }
    return _unReadLabel;
}

- (YYLabel *)onLineLabel {
    if (!_onLineLabel) {
        _onLineLabel = [[YYLabel alloc] init];
        _onLineLabel.backgroundColor = UIColorFromRGB(0xFF3B30);
        _onLineLabel.textColor = UIColorFromRGB(0xffffff);
        _onLineLabel.textAlignment = NSTextAlignmentCenter;
        _onLineLabel.font = [UIFont systemFontOfSize:12];
        _onLineLabel.layer.cornerRadius = 9;
        _onLineLabel.layer.masksToBounds = YES;
        _onLineLabel.hidden = YES;
        _onLineLabel.preferredMaxLayoutWidth = 32;
    }
    return _onLineLabel;
}

- (UIButton *)joinWorldletBtn {
    if (!_joinWorldletBtn) {
        _joinWorldletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinWorldletBtn setTitle:@"  加入小世界" forState:UIControlStateNormal];
        [_joinWorldletBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _joinWorldletBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_joinWorldletBtn setBackgroundColor:[UIColor whiteColor]];
        _joinWorldletBtn.layer.cornerRadius = 55/2;
        _joinWorldletBtn.layer.masksToBounds = YES;
        _joinWorldletBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _joinWorldletBtn.layer.borderWidth = 2.5f;
        [_joinWorldletBtn addTarget:self action:@selector(joinWorldletBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _joinWorldletBtn.hidden = YES;
    }
    return _joinWorldletBtn;
}

- (UIView *)joinBtnShadowView {
    if (!_joinBtnShadowView) {
        _joinBtnShadowView = [[UIView alloc] init];
        _joinBtnShadowView.backgroundColor = [XCTheme getTTMainColor];
        _joinBtnShadowView.layer.cornerRadius = 55/2;
        _joinBtnShadowView.layer.masksToBounds = YES;
        _joinBtnShadowView.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _joinBtnShadowView.layer.borderWidth = 2.5f;
    }
    return _joinBtnShadowView;
}

- (UIButton *)postDynamicBtn {
    if (!_postDynamicBtn) {
        _postDynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postDynamicBtn setImage:[UIImage imageNamed:@"worldletDynamicPost"] forState:UIControlStateNormal];
        [_postDynamicBtn addTarget:self action:@selector(postDynamicBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postDynamicBtn;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _lineView;
}
@end
