//
//  TTMyMasterTableViewCell.m
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMyMasterTableViewCell.h"

#import "UserInfo.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler+Discover.h"

@interface TTMyMasterTableViewCell ()
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 师徒bg */
@property (nonatomic, strong) UIImageView *masterBgImageView;
/** name */
@property (nonatomic, strong) UILabel *nameLabel;
/** iconLabel */
@property (nonatomic, strong) YYLabel *iconLabel;
/** delete */
@property (nonatomic, strong) UIButton *deleteButton;
/** bottomLineView */
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation TTMyMasterTableViewCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickDeleteButton:(UIButton *)button {
    if (self.deleteButtonDidClickBlcok) {
        self.deleteButtonDidClickBlcok(12); // ?? 需要修改
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.avatarImageView];
    [self addSubview:self.masterBgImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconLabel];
    [self addSubview:self.deleteButton];
    [self addSubview:self.bottomLineView];
    
    [self.deleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.masterBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView).offset(-2);
        make.left.mas_equalTo(self.avatarImageView).offset(-4);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(-50);
    }];
    
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(13);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(28 + 10);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - getters and setters
// discover_master_master discover_master_prentice
- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    [self.avatarImageView qn_setImageImageWithUrl:userInfo.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
    self.nameLabel.text = userInfo.nick;
    
    if (userInfo.type == 1) { //（1：我的师傅，2：我的徒弟）
        self.masterBgImageView.image = [UIImage imageNamed:@"discover_master_master"];
        self.masterBgImageView.hidden = NO;
        self.deleteButton.hidden = NO;
    } else if (userInfo.type == 2) {
        self.masterBgImageView.image = [UIImage imageNamed:@"discover_master_prentice"];
        self.masterBgImageView.hidden = NO;
        self.deleteButton.hidden = NO;
    } else {
        self.masterBgImageView.hidden = YES;
        self.deleteButton.hidden = YES;
    }
    
    // 性别,等级,魅力等级
    self.iconLabel.attributedText = [BaseAttrbutedStringHandler creatSex_userLevel_charmLevelByUserInfo:userInfo];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)masterBgImageView {
    if (!_masterBgImageView) {
        _masterBgImageView = [[UIImageView alloc] init];
    }
    return _masterBgImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (YYLabel *)iconLabel {
    if (!_iconLabel) {
        _iconLabel = [[YYLabel alloc] init];
    }
    return _iconLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"discover_master_delete"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = RGBCOLOR(240, 240, 240);
    }
    return _bottomLineView;
}

@end
