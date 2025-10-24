//
//  TTGuildGroupContentCell.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupContentCell.h"
#import "TTGuildGroupManageConfig.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTGuildGroupContentCell ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *separateLine;
@end

@implementation TTGuildGroupContentCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - public method
#pragma mark - system protocols
#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)switchDidTapped:(UISwitch *)sender {
    if (self.switchClickBlock) {
        self.switchClickBlock(sender.on);
    }
}

- (void)outerGroupButtonTapped:(UIButton *)sender {
    sender.selected = YES;
    self.innerGroupButton.selected = NO;
    
    if (self.outerGroupClickBlock) {
        self.outerGroupClickBlock();
    }
}

- (void)innerGroupButtonTapped:(UIButton *)sender {
    sender.selected = YES;
    self.outerGroupButton.selected = NO;
    
    if (self.innerGroupClickBlock) {
        self.innerGroupClickBlock();
    }
}

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.separateLine];
    [self.contentView addSubview:self.selectSwitch];
    [self.contentView addSubview:self.innerGroupButton];
    [self.contentView addSubview:self.outerGroupButton];
    [self.contentView addSubview:self.avatarImageView];
}

- (void)initConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).offset(20);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.innerGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-36);
        make.width.mas_equalTo(80);
    }];
    
    [self.outerGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.innerGroupButton.mas_left).offset(-30);
        make.width.mas_equalTo(80);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - getters and setters
- (void)setConfig:(TTGuildGroupManageConfig *)config {
    _config = config;
    
    BOOL isGroupType = config.type == TTGuildGroupManageTypeClassify;
    BOOL isSwitch = config.type == TTGuildGroupManageTypeMsgDoNotDisturb;
    BOOL isAvatar = config.type == TTGuildGroupManageTypeAvatar;
    
    self.selectSwitch.hidden = !isSwitch;
    self.innerGroupButton.hidden = !isGroupType;
    self.outerGroupButton.hidden = !isGroupType;
    self.avatarImageView.hidden = !isAvatar;
    self.contentLabel.hidden = isSwitch || isGroupType;
    
    self.nameLabel.text = config.name;
    self.nameLabel.textColor = config.nameColor;
    
    self.arrowImageView.hidden = !config.isShowArrow;
    self.separateLine.hidden = !config.isShowUnderLine;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [XCTheme getTTMainTextColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"guild_group_arrow"];
        [_arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _arrowImageView;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [XCTheme getLineDefaultGrayColor];
    }
    return _separateLine;
}

- (UISwitch *)selectSwitch {
    if (_selectSwitch == nil) {
        _selectSwitch = [[UISwitch alloc] init];
        _selectSwitch.onTintColor = [XCTheme getTTMainColor];
        _selectSwitch.tintColor = UIColorFromRGB(0xF5F5F5);
        _selectSwitch.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _selectSwitch.layer.cornerRadius = CGRectGetHeight(_selectSwitch.frame)/2.0;
        _selectSwitch.layer.masksToBounds = YES;
        [_selectSwitch addTarget:self action:@selector(switchDidTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _selectSwitch;
}

- (UIButton *)outerGroupButton {
    if (_outerGroupButton == nil) {
        _outerGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _outerGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_outerGroupButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_outerGroupButton setTitle:@"公开群" forState:UIControlStateNormal];
        [_outerGroupButton setImage:[UIImage imageNamed:@"guild_group_mark_normal"] forState:UIControlStateNormal];
        [_outerGroupButton setImage:[UIImage imageNamed:@"guild_group_mark_select"] forState:UIControlStateSelected];
        [_outerGroupButton addTarget:self action:@selector(outerGroupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _outerGroupButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        
        _outerGroupButton.selected = YES;
    }
    return _outerGroupButton;
}

- (UIButton *)innerGroupButton {
    if (_innerGroupButton == nil) {
        _innerGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _innerGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_innerGroupButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_innerGroupButton setTitle:@"内部群" forState:UIControlStateNormal];
        [_innerGroupButton setImage:[UIImage imageNamed:@"guild_group_mark_normal"] forState:UIControlStateNormal];
        [_innerGroupButton setImage:[UIImage imageNamed:@"guild_group_mark_select"] forState:UIControlStateSelected];
        [_innerGroupButton addTarget:self action:@selector(innerGroupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _innerGroupButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
    }
    return _innerGroupButton;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:[[XCTheme defaultTheme] default_avatar]];
        _avatarImageView.layer.cornerRadius = 25;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

@end
