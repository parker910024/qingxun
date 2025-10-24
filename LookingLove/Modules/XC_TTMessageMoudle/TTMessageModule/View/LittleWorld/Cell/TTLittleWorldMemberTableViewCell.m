//
//  TTLittleWorldMemberTableViewCell.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldMemberTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler.h"
#import "XCMacros.h"
#import "UIImage+Utils.h"

@interface TTLittleWorldMemberTableViewCell ()
/** 显示等级*/
@property (nonatomic,strong) YYLabel *levelLabel;
/** 显示名字*/
@property (nonatomic,strong) YYLabel *nameLabel;
/** 显示头像*/
@property (nonatomic,strong) UIImageView *avatarImageView;
/** 显示是不是在派对中*/
@property (nonatomic,strong) UIImageView *partyImageView;
/** 显示在线*/
@property (nonatomic,strong) UIImageView *onlineImageView;
/** 管理员移出人*/
@property (nonatomic,strong) UIButton *removeButton;
@end

@implementation TTLittleWorldMemberTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)remoButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttLittleWorldMemberTableViewCell:ownerRemoveMember:)]) {
        [self.delegate ttLittleWorldMemberTableViewCell:self ownerRemoveMember:self.member];
    }
}
#pragma mark - private method
- (NSMutableAttributedString *)createLittleWorldNameAndGenderFlagWith:(LittleWolrdMember *)member {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] init];
    UIColor * nickColor;
    if (member.currentRoomUid > 0) {
        nickColor = UIColorFromRGB(0xFF3B30);
    }else {
        nickColor = [XCTheme getTTMainTextColor];
    }
    CGFloat maxWidth = KScreenWidth - 170;
    if (member.ownerFlag) {
        maxWidth = maxWidth - 38 -5;
    }
    NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                k_NickLabel_Color:nickColor,
                                k_NickLabel_MaxWidth:@(maxWidth),
                                k_NickLabel_LabelHeight:@(22)
                                };
    [attributeString appendAttributedString:[BaseAttrbutedStringHandler makeLabelNick:member.nick labelAttribute:attribute]];
    BaseAttributedUserGender gender;
    if (member.gender == UserInfo_Male) {
        gender = BaseAttributedUserGender_Male;
    }else {
        gender = BaseAttributedUserGender_Female;
    }
    [attributeString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    NSMutableAttributedString * genderAttributString = [BaseAttrbutedStringHandler makeGender:gender];
    [attributeString appendAttributedString:genderAttributString];
    
    if (member.ownerFlag) {
        [attributeString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        [attributeString appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 38, 15) urlString:nil imageName:@"worldletCreator"]];
    }
    return attributeString;
}

- (NSMutableAttributedString *)creatLittleWorldMebmerCharmAndLevelAttributWith:(LittleWolrdMember *)member {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] init];
    //userLevel
    if (member.userLevelVo.experUrl) {
        NSMutableAttributedString * experImageString = [BaseAttrbutedStringHandler makeExperImage:member.userLevelVo.experUrl size:CGSizeMake(34, 14)];
        [attributedString appendAttributedString:experImageString];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    //charmLevel
    if (member.userLevelVo.charmUrl) {
        NSMutableAttributedString * charmImageString = [BaseAttrbutedStringHandler makeExperImage:member.userLevelVo.charmUrl size:CGSizeMake(34, 14)];;
        [attributedString appendAttributedString:charmImageString];
        [attributedString appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    return attributedString;
}

- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.partyImageView];
    [self.contentView addSubview:self.onlineImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.removeButton];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.removeButton addTarget:self action:@selector(remoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initContrations {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(55);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.partyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 18));
        make.centerX.bottom.mas_equalTo(self.avatarImageView);
    }];
    
    [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(13);
        make.bottom.mas_equalTo(self.avatarImageView).offset(-2);
        make.right.mas_equalTo(self.avatarImageView).offset(-2);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.avatarImageView).offset(10);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-16);
    }];
}

#pragma mark - setters and getters
- (void)setMember:(LittleWolrdMember *)member {
    _member = member;
    if (_member) {
      [self.avatarImageView qn_setImageImageWithUrl:_member.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeRoomMagic];
        self.levelLabel.attributedText = [self creatLittleWorldMebmerCharmAndLevelAttributWith:member];
        self.nameLabel.attributedText = [self createLittleWorldNameAndGenderFlagWith:member];

        if (_member.currentRoomUid > 0) {
            self.partyImageView.hidden = NO;
            self.onlineImageView.hidden = YES;
        }else {
            self.partyImageView.hidden = YES;
            if (_member.onlineFlag) {
                self.onlineImageView.hidden = NO;
            }else {
                self.onlineImageView.hidden = YES;
            }
        }
        
        if (self.type == TTWorldletCreater) {
            if (_member.ownerFlag) {
                self.removeButton.hidden = YES;
            }
        }
    }
}

- (void)setType:(TTWorldLetType)type {
    _type = type;
    self.removeButton.hidden = _type != TTWorldletCreater;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 55/2;
        _avatarImageView.userInteractionEnabled = NO;
    }
    return _avatarImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
    }
    return _nameLabel;
}

- (YYLabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[YYLabel alloc] init];
    }
    return _levelLabel;
}

- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setBackgroundImage:[UIImage imageNamed:@"guild_Hall_remove"] forState:UIControlStateNormal];
         [_removeButton setBackgroundImage:[UIImage imageNamed:@"guild_Hall_remove"] forState:UIControlStateSelected];
        _removeButton.hidden = YES;
    }
    return _removeButton;
}

- (UIImageView *)partyImageView {
    if (!_partyImageView) {
        _partyImageView = [[UIImageView alloc] init];
        _partyImageView.image = [UIImage imageNamed:@"littleworld_party"];
    }
    return _partyImageView;
}

- (UIImageView *)onlineImageView {
    if (!_onlineImageView) {
        _onlineImageView = [[UIImageView alloc] init];
        _onlineImageView.layer.masksToBounds = YES;
        _onlineImageView.layer.cornerRadius = 13/ 2;
        _onlineImageView.image = [UIImage imageWithColor:UIColorFromRGB(0x2FCB96)];
        _onlineImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _onlineImageView.layer.borderWidth = 2;
    }
    return _onlineImageView;
}


@end
