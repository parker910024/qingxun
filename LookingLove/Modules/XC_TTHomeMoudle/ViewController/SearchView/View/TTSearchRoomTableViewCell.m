//
//  TTSearchRoomTableViewCell.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTSearchRoomTableViewCell.h"

#import "SearchResultInfo.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>
#import <YYLabel.h>
#import "XCTheme.h"
#import "XCMacros.h"

#import "BaseAttrbutedStringHandler+TTHome.h"
#import "TTNobleSourceHelper.h"

@interface TTSearchRoomTableViewCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 贵族头饰 */
@property (nonatomic, strong) UIImageView *disposeImageView;
/** 昵称 */
@property (nonatomic, strong) YYLabel *nameLabel;
/** id */
@property (nonatomic, strong) YYLabel *idLabel;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

/** 赠送按钮 */
@property (nonatomic, strong) UIButton *presentButton;
/** 邀请按钮 */
@property (nonatomic, strong) UIButton *inviteButton;
/** 进入房间按钮 */
@property (nonatomic, strong) UIButton *enterRoomButton;

@end

@implementation TTSearchRoomTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - puble method
- (void)setInfo:(SearchResultInfo *)info{
    _info = info;
    [self.iconImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    NSDictionary *parma = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                            k_NickLabel_Color:[UIColor blackColor],
                            k_NickLabel_MaxWidth:@150,
                            k_NickLabel_LabelHeight:@(22)
                            };
    UserInfo *user = [UserInfo new];
    user.nick = info.nick;
    user.defUser = info.defUser;
    user.nobleUsers = info.nobleUsers;
    user.gender = info.gender;
    user.userLevelVo = info.userLevelVo;
    self.nameLabel.attributedText = [BaseAttrbutedStringHandler creatNick_noble_sex_userLevel_charmLevelByUserInfo:user nickType:BaseAttributedStringNickTypeUILabel labelAttribute:parma];
    self.idLabel.attributedText = [self createBeautyAttributedString:info];
    
    if (info.nobleUsers.headwear) {
        self.disposeImageView.hidden = NO;
        NobleSourceInfo *sourceInfo = [[NobleSourceInfo alloc] init];
        sourceInfo.sourceType = NobleSourceTypeURL;
        
        [TTNobleSourceHelper disposeImageView:self.disposeImageView withSource:info.nobleUsers.headwear imageType:ImageTypeUserLibaryDetail];
    } else {
        self.disposeImageView.hidden = YES;
    }
}

#pragma mark - event response
- (void)didClickedPresentButton:(UIButton *)button {
    if (self.presentBtnClickBlcok) {
        self.presentBtnClickBlcok(button);
    }
}

- (void)didClickEnterRoomButton:(UIButton *)sender {
    !self.enterRoomHandler ?: self.enterRoomHandler();
}

#pragma mark - private method
//设置靓与id
- (NSMutableAttributedString *)createBeautyAttributedString:(SearchResultInfo *)info {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.bounds = CGRectMake(0, -2, 13, 13);
    
    if (info.defUser == AccountType_Official) {
        NSMutableAttributedString *officalBadge = [BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 10, 10) urlString:nil imageName:@"common_offical"];
        [attributedString appendAttributedString:officalBadge];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (info.hasPrettyErbanNo) {
        NSMutableAttributedString *beautyAttri = [BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 10, 10) urlString:nil imageName:@"common_beauty"];
        [attributedString appendAttributedString:beautyAttri];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    
    [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"ID:%@",info.erbanNo] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}]];
    return attributedString;
}

#pragma mark - private method
- (void)initView {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.disposeImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.idLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.presentButton];
    [self.contentView addSubview:self.inviteButton];
    [self.contentView addSubview:self.enterRoomButton];
}

- (void)initConstrations {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.disposeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(52);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.top.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(-30);
    }];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.enterRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(27);
        make.width.mas_equalTo(70);
    }];
}


#pragma mark - Getter & Setter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UIImageView *)disposeImageView {
    if (!_disposeImageView) {
        _disposeImageView = [[UIImageView alloc] init];
    }
    return _disposeImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = RGBCOLOR(51, 51, 51);
    }
    return _nameLabel;
}

- (YYLabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[YYLabel alloc] init];
    }
    return _idLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(240, 240, 240);
    }
    return _lineView;
}

- (UIButton *)presentButton {
    if (!_presentButton) {
        _presentButton = [[UIButton alloc] init];
        [_presentButton setTitle:@"赠送" forState:UIControlStateNormal];
        [_presentButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _presentButton.layer.cornerRadius = 15;
        _presentButton.layer.masksToBounds = YES;
        _presentButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _presentButton.layer.borderWidth = 1;
        _presentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_presentButton addTarget:self action:@selector(didClickedPresentButton:) forControlEvents:UIControlEventTouchUpInside];
        _presentButton.hidden = YES;
    }
    return _presentButton;
}

- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteButton.hidden = YES;
        _inviteButton.tag = 1001;
        [_inviteButton setImage:[UIImage imageNamed:@"guild_search_add"] forState:UIControlStateNormal];
        [_inviteButton addTarget:self action:@selector(didClickedPresentButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteButton;
}

- (UIButton *)enterRoomButton {
    if (!_enterRoomButton) {
        
        _enterRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterRoomButton setTitle:@"进入房间" forState:UIControlStateNormal];
        [_enterRoomButton setTitleColor:[XCTheme getMainDefaultColor] forState:UIControlStateNormal];
        [_enterRoomButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_enterRoomButton addTarget:self action:@selector(didClickEnterRoomButton:) forControlEvents:UIControlEventTouchUpInside];
        _enterRoomButton.layer.cornerRadius = 6;
        _enterRoomButton.layer.masksToBounds = YES;
        _enterRoomButton.layer.borderColor = [XCTheme getMainDefaultColor].CGColor;
        _enterRoomButton.layer.borderWidth = 1.f;
        
        if (projectType() == ProjectType_LookingLove) {
            _enterRoomButton.layer.cornerRadius = 27/2.0;
        }
        
        _enterRoomButton.hidden = YES;
    }
    return _enterRoomButton;
}

@end
