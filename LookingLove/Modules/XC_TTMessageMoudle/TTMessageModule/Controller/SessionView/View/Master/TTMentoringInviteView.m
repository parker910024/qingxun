//
//  TTMentoringInviteView.m
//  TTPlay
//
//  Created by gzlx on 2019/2/18.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTMentoringInviteView.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>

#import "AuthCore.h"

@interface TTMentoringInviteView ()
/** 背景图*/
@property (nonatomic, strong) UIImageView * backImageView;

@property (nonatomic, strong) UIView * contentView;
/** 师傅的头像*/
@property (nonatomic, strong) UIImageView * avatarImageView;
/** 师傅的名字*/
@property (nonatomic, strong) UILabel * nickLabel;
/** 内容*/
@property (nonatomic, strong) UILabel * textLabel;

/** tips*/
@property (nonatomic, strong) UILabel * tipsLabel;

@end

@implementation TTMentoringInviteView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)didClickEnterButton:(UIButton *)sender{
    if (self.didClickEnterButton) {
        self.didClickEnterButton(sender);
    }
}

- (void)avatarImageViewRecognizer:(UITapGestureRecognizer *)tap{
    if (self.avatarImageTapBlock) {
        self.avatarImageTapBlock();
    }
}

#pragma mark - private method
- (void)initView{
    [self addSubview:self.backImageView];
    
    [self.backImageView addSubview:self.contentView];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.enterButton];
    [self.contentView addSubview:self.tipsLabel];
    
    [self.enterButton addTarget:self action:@selector(didClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewRecognizer:)];
    [self.avatarImageView addGestureRecognizer:tap];
}

- (void)initContrations{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView).offset(14);
        make.left.mas_equalTo(self.backImageView).offset(11);
        make.right.mas_equalTo(self.backImageView).offset(-11);
        make.bottom.mas_equalTo(self.backImageView).offset(-14);
    }];
    
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(30);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImageView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(11);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(30);
        make.right.mas_equalTo(self.contentView).offset(-30);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(22);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(38);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-36);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
    
}

#pragma mark - setters and getters
- (void)setInviteModel:(MentoringInviteModel *)inviteModel{
    if (inviteModel) {
        if (inviteModel.masterUid == GetCore(AuthCore).getUid.userIDValue) {
            [self.enterButton setTitle:@"已邀请" forState:UIControlStateDisabled];
            self.enterButton.enabled = NO;
        }else if(inviteModel.apprenticeUid == GetCore(AuthCore).getUid.userIDValue){
            self.enterButton.enabled = YES;
        }
        [self.avatarImageView qn_setImageImageWithUrl:inviteModel.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        self.nickLabel.text = inviteModel.nick;
    }
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.image = [UIImage imageNamed:@"message_master_backimage"];
    }
    return _backImageView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}


- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.textColor = [XCTheme getTTMainColor];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickLabel;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [XCTheme getTTMainTextColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"房间开好啦,速速加入一起畅聊,谁还不是个有故事的少年呢~";
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:11];
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"·从这里进房任务才生效哦·";
    }
    return _tipsLabel;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"立即进入" forState:UIControlStateNormal];
        [_enterButton setTitle:@"立即进入" forState:UIControlStateDisabled];
        [_enterButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_normal"] forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:[UIImage imageNamed:@"message_master_btn_bg_disable"] forState:UIControlStateDisabled];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _enterButton.layer.cornerRadius = 19;
        _enterButton.layer.masksToBounds = YES;
    }
    return _enterButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
