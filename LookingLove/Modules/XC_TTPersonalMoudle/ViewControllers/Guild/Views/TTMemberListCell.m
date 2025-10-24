//
//  TTMemberListCell.m
//  TuTu
//
//  Created by lee on 2019/1/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMemberListCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import <YYText/YYText.h>
#import "UserInfo.h"
#import "BaseAttrbutedStringHandler+TTGuildInfo.h"
#import "UIImageView+QiNiu.h"
#import "UIButton+EnlargeTouchArea.h"

@interface TTMemberListCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *memberIDLabel;
@property (nonatomic, strong) YYLabel *titleTagLabel;
@property (nonatomic, strong) UIImageView *identifiIcon;
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation TTMemberListCell

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.memberIDLabel];
    [self.contentView addSubview:self.titleTagLabel];
    [self.contentView addSubview:self.identifiIcon];
    [self.contentView addSubview:self.selectedBtn];
}

- (void)initConstraints {
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.top.mas_equalTo(self.iconImage);
        make.width.mas_equalTo(0);
    }];
    
    [self.memberIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.iconImage);
    }];
    
    [self.titleTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.top.mas_equalTo(self.iconImage);
    }];
    
    [self.identifiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(14);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
        make.centerX.mas_equalTo(self.iconImage);
    }];
    
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(17);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setIsGroup:(BOOL)isGroup {
    _isGroup = isGroup;
    
}
/** 是否是禁言类型 */
- (void)setIsMute:(BOOL)isMute {
    _isMute = isMute;
    [self.selectedBtn setImage:[UIImage imageNamed:@"guild_groupChat_mute"] forState:UIControlStateSelected];
    [self.selectedBtn setImage:[UIImage imageNamed:@"guild_groupChat_unMute"] forState:UIControlStateNormal];
    self.selectedBtn.hidden = !isMute;
}
/** 是否是多选类型 */
- (void)setIsMutable:(BOOL)isMutable {
    _isMutable = isMutable;
    self.selectedBtn.hidden = !isMutable;
}
/** 普通不显示类型 */
- (void)setIsNormal:(BOOL)isNormal {
    _isNormal = isNormal;
    self.selectedBtn.hidden = isNormal;
}
/** 删除类型 */
- (void)setIsRemove:(BOOL)isRemove {
    _isRemove = isRemove;
    [self.selectedBtn setImage:[UIImage imageNamed:@"guild_Hall_remove"] forState:UIControlStateNormal];
    self.selectedBtn.hidden = !isRemove;
}
/** 选中类型 */
- (void)setIsManagerSelected:(BOOL)isManagerSelected {
    _isManagerSelected = isManagerSelected;
    self.selectedBtn.hidden = !isManagerSelected;
}

#pragma mark -
#pragma mark button click events
- (void)onSelectedBtnClickHandler:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCellSelectedClickHandler:info:)]) {
        [self.delegate onCellSelectedClickHandler:btn info:self.userInfo];
    }
}

#pragma mark -
#pragma mark getter & setter
- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    self.titleTagLabel.attributedText = [BaseAttrbutedStringHandler creatName_Sex_userRank_charmRankByUserInfo:userInfo];
    [self.iconImage qn_setImageImageWithUrl:userInfo.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    self.memberIDLabel.text = [NSString stringWithFormat:@"ID:%@", userInfo.erbanNo];
//    角色类型： 1：厅主，2：高管，3：普通成员
    if ([userInfo.roleType isEqualToString:@"1"]) {
        _identifiIcon.image = [UIImage imageNamed:@"guild_memberList_cell_master"];
        self.selectedBtn.hidden = YES;
    } else if ([userInfo.roleType isEqualToString:@"2"]) {
//        self.selectedBtn.hidden = !self.isHallMaster;
        if (self.isManagerSelected) {
            self.selectedBtn.selected = YES;
        }
        if (self.isGroup) {
            _identifiIcon.image = [UIImage imageNamed:@"guild_GroupChat_cell_manager"];
        } else {
            _identifiIcon.image = [UIImage imageNamed:@"guild_memberList_cell_manager"];
        }
        if (self.isRemove || self.isMute) {
            if ([userInfo.roleType isEqualToString:self.currentManagerRoleType]) {
                self.selectedBtn.hidden = YES;
            }
        }
        
    } else if ([userInfo.roleType isEqualToString:@"3"]) {
        // 成员图标莫得，如果后期加了就在此处处理
        _identifiIcon.image = nil;
        self.selectedBtn.selected = NO;
    }
    self.selectedBtn.tag = self.tag;
    if (self.isMute) {
        self.selectedBtn.selected = userInfo.bannedStatus;
    }
}
- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
        _iconImage.layer.cornerRadius = 20;
        _iconImage.layer.masksToBounds = YES;
    }
    return _iconImage;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [XCTheme getMSMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.f];
//        _nameLabel.preferredMaxLayoutWidth = 110;
    }
    return _nameLabel;
}

- (UILabel *)memberIDLabel
{
    if (!_memberIDLabel) {
        _memberIDLabel = [[UILabel alloc] init];
        _memberIDLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _memberIDLabel.font = [UIFont systemFontOfSize:12.f];
        _memberIDLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _memberIDLabel;
}

- (YYLabel *)titleTagLabel {
    if (!_titleTagLabel) {
        _titleTagLabel = [[YYLabel alloc] init];
        _titleTagLabel.displaysAsynchronously = YES;
        _titleTagLabel.fadeOnHighlight = NO;
        _titleTagLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _titleTagLabel;
}

- (UIImageView *)identifiIcon {
    if (!_identifiIcon) {
        _identifiIcon = [[UIImageView alloc] init];
        _identifiIcon.image = [UIImage imageNamed:@"guild_memberList_cell_master"];
    }
    return _identifiIcon;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"guild_cell_normal"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"guild_cell_selected"] forState:UIControlStateSelected];
        [_selectedBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_selectedBtn addTarget:self action:@selector(onSelectedBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        _selectedBtn.hidden = YES;
    }
    return _selectedBtn;
}

@end
