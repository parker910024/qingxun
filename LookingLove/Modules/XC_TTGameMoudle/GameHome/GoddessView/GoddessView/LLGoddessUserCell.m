//
//  LLGoddessUserCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGoddessUserCell.h"

#import "TTGoddessViewProtocol.h"

#import "TTNobleSourceHelper.h"

#import "HomeV5Data.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "CALayer+QiNiu.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

@interface LLGoddessUserCell ()
@property (nonatomic, strong) UIButton *avatarImageView;
@property (nonatomic, strong) UIImageView *liveImageView;//房间 live
@property (nonatomic, strong) YYLabel *nameLabel;//名称
@property (nonatomic, strong) UIImageView *roomTagImageView;//房间标签
@property (nonatomic, strong) YYLabel *userTagLabel;
@property (nonatomic, strong) UIButton *actionButton;//操作：前往围观、一起玩
@property (nonatomic, strong) UIImageView *actionArrowImageView;//操作箭头
@property (nonatomic, strong) UILabel *statusLabel;//状态：她正在玩游戏、热门直播厅
@property (nonatomic, strong) UILabel *distanceLabel;//距离
@end

@implementation LLGoddessUserCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
- (void)didClickActionButton:(UIButton *)sender {
    
    if (self.model.recommendRoom) {
        //推荐房间的操作按钮动作和点击整个 cell 一样
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectUserCell:data:)]) {
            [self.delegate didSelectUserCell:self data:self.model];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickActionButtonWithData:)]) {
            [self.delegate didClickActionButtonWithData:self.model];
        }
    }
}

- (void)didClickAvatarButton:(UIButton *)sender {
    
    if (self.model.recommendRoom) {
        //推荐房间的头像按钮动作和点击整个 cell 一样
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectUserCell:data:)]) {
            [self.delegate didSelectUserCell:self data:self.model];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAvatarWithData:)]) {
            [self.delegate didClickAvatarWithData:self.model];
        }
    }
}

#pragma mark - private method
#pragma mark layout
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.liveImageView];
    [self.contentView addSubview:self.roomTagImageView];
    [self.contentView addSubview:self.userTagLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.actionButton];
    [self.contentView addSubview:self.actionArrowImageView];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.statusLabel];
}

- (void)initConstraints {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatarImageView);
        make.width.height.mas_equalTo(69);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_top).offset(4);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(12);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_greaterThanOrEqualTo(self.nameLabel.mas_right).offset(20);
    }];
    
    [self.actionArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.actionButton.mas_right).offset(4);
        make.centerY.mas_equalTo(self.actionButton);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(7/2.0);
        make.height.mas_equalTo(12/2.0);
    }];
    
    [self.roomTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(50);
    }];
    
    [self.userTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(16);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userTagLabel);
        make.left.mas_greaterThanOrEqualTo(self.userTagLabel.mas_right).offset(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userTagLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.nameLabel);
    }];
}

/**
 根据状态更新名称顶部约束
 */
- (void)updateNameLabelLayout {
    
    NSString *statusText = self.statusLabel.text;
    
    if (statusText && statusText.length > 0) {
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_top).offset(4);
        }];
        
    } else {
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_top).offset(14);
        }];
    }
}

#pragma mark make NSMutableAttributedString
//房间在线列表副标题（新 官方 房主 管理 等级 魅力值）
- (NSMutableAttributedString *)userSubTitleAttributedString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    //贵族
    if (self.model.nobleUsers.level) {
        
        UIImageView *nobleBadgeImageView = [[UIImageView alloc]init];
        [TTNobleSourceHelper disposeImageView:nobleBadgeImageView withSource:self.model.nobleUsers.badge imageType:ImageTypeUserLibaryDetail];
        nobleBadgeImageView.bounds = CGRectMake(0, 0, 15, 15);
        nobleBadgeImageView.contentMode = UIViewContentModeScaleToFill;
        
        NSMutableAttributedString *nobleImageString = [NSMutableAttributedString yy_attachmentStringWithContent:nobleBadgeImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nobleBadgeImageView.frame.size.width, nobleBadgeImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
        
        [attributedString appendAttributedString:nobleImageString];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }

    // gender
    NSMutableAttributedString *genderString = [self genderAgeAttributedStringWithGender:self.model.gender age:self.model.age];
    [attributedString appendAttributedString:genderString];
    [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    
    //官方主播认证
    if (self.model.recommendRoom && self.model.nameplate && self.model.nameplate.fixedWord.length>0) {
        NSMutableAttributedString *certTag = [BaseAttrbutedStringHandler certificationTagWithName:self.model.nameplate.fixedWord image:self.model.nameplate.iconPic];
        [attributedString appendAttributedString:certTag];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    //经验值
    if (self.model.userLevelVo.experUrl) {
        NSMutableAttributedString *experImageString = [BaseAttrbutedStringHandler makeExperImage:self.model.userLevelVo.experUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    //魅力值
    if (self.model.userLevelVo.charmUrl) {
        NSMutableAttributedString *experImageString = [BaseAttrbutedStringHandler makeExperImage:self.model.userLevelVo.charmUrl];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    return attributedString;
}

/// 性别年龄富文本
- (NSMutableAttributedString *)genderAgeAttributedStringWithGender:(UserGender)gender age:(NSInteger)age {
    
    if (age <= 0) {
        //只显示性别
        NSString *imageName = self.model.gender == UserInfo_Male ? [XCTheme defaultTheme].common_sex_male : [XCTheme defaultTheme].common_sex_female;
        NSMutableAttributedString *genderString = [BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 15, 15) urlString:nil imageName:imageName];
        return genderString;
    }
    
    NSString *genderImage = self.model.gender == UserInfo_Male ? @"game_home_list_gender_male" : @"game_home_list_gender_female";
    CGFloat width = age > 99 ? 34 : 30;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, width, 16);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:genderImage]];
    [bgView addSubview:imageView];
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.text = @(age).stringValue;
    ageLabel.textColor = UIColor.whiteColor;
    ageLabel.font = [UIFont systemFontOfSize:10];
    [bgView addSubview:ageLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(imageView);
    }];
    
    NSMutableAttributedString *str = [NSMutableAttributedString yy_attachmentStringWithContent:bgView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(bgView.frame.size.width, bgView.frame.size.height) alignToFont:[UIFont systemFontOfSize:10] alignment:YYTextVerticalAlignmentCenter];
    return str;
}

/// 姓名富文本
- (NSMutableAttributedString *)nameAttributedStringWithName:(NSString *)name cert:(UserOfficialAnchorCertification *)cert {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    if (cert && cert.fixedWord.length > 0) {
        NSMutableAttributedString *certTag = [BaseAttrbutedStringHandler certificationTagWithName:cert.fixedWord image:cert.iconPic];
        [str appendAttributedString:certTag];
        [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:name];
    nameStr.yy_font = [UIFont systemFontOfSize:15];
    nameStr.yy_color = [XCTheme getTTMainTextColor];
    [str appendAttributedString:nameStr];
    
    return str;
}

#pragma mark - getters and setters
- (void)setModel:(HomeV5Data *)model {
    _model = model;
    
    if (model.recommendRoom) {
        
        [self.avatarImageView.layer qn_setImageImageWithUrl:model.roomVo.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        [self.liveImageView qn_setImageImageWithUrl:model.roomVo.icon placeholderImage:nil type:ImageTypeUserIcon];
        self.liveImageView.hidden = NO;
        
        self.nameLabel.attributedText = [self nameAttributedStringWithName:model.roomVo.title cert:model.nameplate];
        self.statusLabel.text = model.roomVo.desc;
        
        self.distanceLabel.text = @"";
        
        // 房间标签
        NSString *roomTag = model.roomVo.liveTag ? model.roomVo.skillTag : model.roomVo.tagPict;
        
        @weakify(self)
        [self.roomTagImageView qn_setImageImageWithUrl:roomTag placeholderImage:nil type:ImageTypeUserRoomTag success:^(UIImage *image) {
            
            @strongify(self)
            if (image && image.size.height > 0) {
                
                self.roomTagImageView.hidden = NO;
                
                CGFloat tagWidth = image.size.width / (image.size.height / 15);
                [self.roomTagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(tagWidth);
                }];
                
            } else {
                self.roomTagImageView.hidden = YES;
            }
        }];
        
        self.userTagLabel.hidden = YES;
        self.roomTagImageView.hidden = NO;
        
        NSString *online = [NSString stringWithFormat:@"%ld人在看", (long)model.roomVo.onlineNum];
        [self.actionButton setTitle:online forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:@"game_home_list_room"] forState:UIControlStateNormal];
        self.actionButton.hidden = NO;
        
        [self updateNameLabelLayout];
        return;
    }
    
    [self.avatarImageView.layer qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
    self.liveImageView.hidden = YES;
    
    self.nameLabel.attributedText = [self nameAttributedStringWithName:model.nick cert:model.nameplate];
    self.statusLabel.text = model.desc;
    self.distanceLabel.text = model.distanceStr ?: @"";
    
    self.userTagLabel.attributedText = [self userSubTitleAttributedString];
    self.userTagLabel.hidden = NO;
    self.roomTagImageView.hidden = YES;
    
    if (model.status.intValue == 2) {
        [self.actionButton setTitle:@"一起玩" forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:@"game_home_list_game"] forState:UIControlStateNormal];
        
    } else if (model.status.intValue == 1 ||
               model.status.intValue == 3) {
     
        [self.actionButton setTitle:@"去找TA" forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:@"game_home_list_room"] forState:UIControlStateNormal];
        
    } else {
        
        [self.actionButton setTitle:@"撩一下" forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:@"game_home_list_flirt"] forState:UIControlStateNormal];
    }
    
    [self updateNameLabelLayout];
}

- (UIButton *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarImageView.layer.cornerRadius = 30;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_avatarImageView addTarget:self action:@selector(didClickAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarImageView;
}

- (UIImageView *)liveImageView {
    if (_liveImageView == nil) {
        _liveImageView = [[UIImageView alloc] init];
        _liveImageView.image = [UIImage imageNamed:@"game_home_list_live"];
    }
    return _liveImageView;
}

- (UIImageView *)roomTagImageView {
    if (_roomTagImageView == nil) {
        _roomTagImageView = [[UIImageView alloc] init];
    }
    return _roomTagImageView;
}

- (YYLabel *)userTagLabel {
    if (_userTagLabel == nil) {
        _userTagLabel = [[YYLabel alloc] init];
    }
    return _userTagLabel;
}

- (YYLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _nameLabel;
}

- (UIButton *)actionButton {
    if (_actionButton == nil) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setImage:[UIImage imageNamed:@"game_home_list_game"] forState:UIControlStateNormal];
        [_actionButton setTitle:@"一起玩" forState:UIControlStateNormal];
        [_actionButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_actionButton addTarget:self action:@selector(didClickActionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        
        [_actionButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [_actionButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _actionButton;
}

- (UIImageView *)actionArrowImageView {
    if (_actionArrowImageView == nil) {
        _actionArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"master_hint_arrow"]];
    }
    return _actionArrowImageView;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = UIColorFromRGB(0xb3b3b3);
    }
    return _statusLabel;
}

- (UILabel *)distanceLabel {
    if (_distanceLabel == nil) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textColor = UIColorFromRGB(0xb3b3b3);
        
        [_distanceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _distanceLabel;
}

@end

