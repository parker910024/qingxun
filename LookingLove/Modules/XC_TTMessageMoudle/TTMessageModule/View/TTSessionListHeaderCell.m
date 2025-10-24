//
//  TTSessionListHeaderCell.m
//  XC_TTMessageMoudle
//
//  Created by Macx on 2019/4/12.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTSessionListHeaderCell.h"

#import "MentoringGrabModel.h"
#import "MentoringShipCoreClient.h"
#import "MentoringShipCore.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"

@interface TTSessionListHeaderCell ()<MentoringShipCoreClient>
/** bg */
@property (nonatomic, strong) UIImageView *bgImageView;
/** avatar */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** name */
@property (nonatomic, strong) UILabel *nameLabel;
/** 抢徒弟按钮 */
@property (nonatomic, strong) UIButton *goButton;
@end

@implementation TTSessionListHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initContrations];
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - MentoringShipCoreClient
/** 可抢徒弟, 倒计时回调 */
- (void)grabApprenticeCutdownAction {
    NSString *btnStr = [NSString stringWithFormat:@"抢徒 (%zds)", self.model.countdown];
    [self.goButton setTitle:btnStr forState:UIControlStateNormal];
}

#pragma mark - Even Response
- (void)didClickGoButton:(UIButton *)btn {
    if (self.goButtonDidClickAction) {
        self.goButtonDidClickAction(self.model.uid);
    }
}

#pragma mark - private method
- (void)initView {
    AddCoreClient(MentoringShipCoreClient, self);
    
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.avatarImageView];
    [self.bgImageView addSubview:self.nameLabel];
    [self.bgImageView addSubview:self.goButton];
}

- (void)initContrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(19);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImageView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(6);
        make.right.mas_equalTo(-13);
    }];
    
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-18);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - setters and getters
- (void)setModel:(MentoringGrabModel *)model {
    _model = model;
    
    self.nameLabel.text = model.nick;
    [self.avatarImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
    
    NSString *btnStr = [NSString stringWithFormat:@"抢徒 (%zds)", model.countdown];
    [self.goButton setTitle:btnStr forState:UIControlStateNormal];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"discover_master_message_header_bg"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [[UIButton alloc] init];
        [_goButton setBackgroundImage:[UIImage imageNamed:@"discover_master_message_header_btn_bg"] forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_goButton addTarget:self action:@selector(didClickGoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goButton;
}
@end
