//
//  TTFamilyMemberTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
// 家族成员 家族群

#import "TTFamilyMemberTableViewCell.h"
#import <YYLabel.h>
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UIImageView+QiNiu.h"
#import "GroupCore.h"
#import "GroupModel.h"
#import "AuthCore.h"
#import "TTGameStaticTypeCore.h"
#import "TTFamilyAttributedString.h"

@interface TTFamilyMemberTableViewCell()
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 名称 性别 等级 魅力值*/
@property (nonatomic, strong) YYLabel * nameLabel;
/** 显示id*/
@property (nonatomic, strong) UILabel * idLabel;
/**显示族长或者管理员*/
@property (nonatomic, strong) UIImageView * positionImageView;
/**状态的按钮 移出 禁言 添加 设置管理员*/
@property (nonatomic, strong) UIButton * typeButton;
/** 分割线*/
@property (nonatomic, strong) UIView * sepView;
/** 群成员的信息*/
@property (nonatomic, strong) GroupMemberModel * groupInfor;
/**家族成员的信息 */
@property (nonatomic, strong) XCFamilyModel * familyInfor;

@end

@implementation TTFamilyMemberTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)typeButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleFamilyMemberTableViewWith:groupModel:listType:typeButton:)]) {
        [self.delegate handleFamilyMemberTableViewWith:self.familyInfor groupModel:self.groupInfor listType:self.listType typeButton:sender];
    }
}

#pragma mark -public method
/** 家族成员列表的赋值*/
- (void)configFamilyMemberWith:(XCFamilyModel *)familyModel{
    self.familyInfor = familyModel;
    [self.iconImageView qn_setImageImageWithUrl:familyModel.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    NSDictionary * dic = [familyModel model2dictionary];
    UserInfo * infor = [UserInfo yy_modelWithDictionary:dic];
    self.nameLabel.attributedText = [TTFamilyAttributedString createNameGenderLevelCharmWiht:familyModel.name gender:familyModel.gender level:familyModel.userLevelVo];
    self.idLabel.text = [NSString stringWithFormat:@"ID: %@", familyModel.erbanNo];
    self.positionImageView.hidden = NO;
    if ([familyModel.position integerValue] == FamilyMemberPositionOwen) {
        self.positionImageView.image = [UIImage imageNamed:@"family_person_patria"];
        self.positionImageView.hidden = NO;
    }else{
        self.positionImageView.hidden = YES;
    }
}
/** 群成员的赋值*/
- (void)configGroupMemberWith:(GroupMemberModel*)groupMember{
    if (groupMember) {
        self.groupInfor = groupMember;
        [self.iconImageView qn_setImageImageWithUrl:groupMember.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        self.nameLabel.attributedText = [TTFamilyAttributedString createNameGenderLevelCharmWiht:groupMember.nick gender:groupMember.gender level:groupMember.userLevelVo];
        self.idLabel.text = [NSString stringWithFormat:@"ID: %@", groupMember.erbanNo];
    }
}

- (void)configShareCellWith:(UserInfo *)infor{
    [self.iconImageView qn_setImageImageWithUrl:infor.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    self.nameLabel.attributedText = [TTFamilyAttributedString createNameGenderLevelCharmWiht:infor.nick gender:infor.gender level:infor.userLevelVo];
    if (infor.userDesc) {
        self.idLabel.text = infor.userDesc;
    }else{
        self.idLabel.text = @"这个人很懒还没有个性签名";
    }
    self.positionImageView.hidden = YES;
    if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
        self.inviteButton.hidden = NO;
    }
    
}

- (void)configSearchFamilyWith:(XCFamily *)family{
    if (family) {
        [self.iconImageView qn_setImageImageWithUrl:family.familyIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        NSString * familyStr = [NSString stringWithFormat:@"家族ID：%@  成员：%@", family.familyId,family.memberCount];
        self.nameLabel.attributedText =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",  family.familyName]];
        self.iconImageView.layer.cornerRadius = 5;
        self.idLabel.text = familyStr;
    }
}

/** 搜索的时候*/
- (void)configSearchShareCellWith:(SearchResultInfo *)infor{
    [self.iconImageView qn_setImageImageWithUrl:infor.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    self.nameLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:infor.nick];
    self.idLabel.text = [NSString stringWithFormat:@"ID: %@", infor.erbanNo];
    self.positionImageView.hidden = YES;
}


- (void)setListType:(FamilyMemberListType)listType{
    _listType = listType;
    if (_listType == FamilyMemberListCreateGroup || _listType == FamilyMemberAddGroup) {
        if ([self.familyInfor.position integerValue] == FamilyMemberPositionOwen) {
            self.typeButton.hidden = YES;
        }else{
            self.typeButton.hidden= NO;
            [self.typeButton setImage:[UIImage imageNamed:@"family_create_notchoose"] forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"family_create_choose"] forState:UIControlStateSelected];
            self.typeButton.selected = self.familyInfor.isSelect;
        }
    }else{
        NSString * imageName;
        NSString * selectImageName;
        BOOL isSelected = NO;
        BOOL isHidden = NO;
        //移出家族
        if (_listType == FamilyMemberListFamilyRemove) {
            if ((self.familyInfor && [self.familyInfor.position integerValue] == FamilyMemberPositionOwen)) {
                isHidden = YES;
            }else{
                isHidden = NO;
                imageName = @"family_member_remove";
                selectImageName = @"family_member_remove";
                isSelected = NO;
            }
        }else if (_listType == FamilyMemberListGroupRemove){
            //族长没有 自己不能移出自己 管理员不能移出管理员
            GroupModel * model = GetCore(GroupCore).groupInfor;
            if ((self.groupInfor.role == GroupMemberRole_Owner || self.groupInfor.uid == [[GetCore(AuthCore) getUid] userIDValue]) ||(model.role == GroupMemberRole_Manager && self.groupInfor.role == GroupMemberRole_Manager)) {
                isHidden = YES;
            }else{
                isHidden = NO;
                isHidden = NO;
                imageName = @"family_member_remove";
                selectImageName = @"family_member_remove";
                isSelected = NO;
            }
        }else if (_listType == FamilyMemberListGroupManager){
            //群成员列表 设置管理员
            selectImageName = @"family_group_canclemanager";
            imageName = @"family_group_setmanager";
            if (self.groupInfor) {
                if (self.groupInfor.role == GroupMemberRole_Owner) {
                    isHidden = YES;
                    isSelected = YES;
                }else if (self.groupInfor.role == GroupMemberRole_Manager){
                    isHidden = NO;
                    isSelected = YES;
                }else if (self.groupInfor.role == GroupMemberRole_Normal){
                    isHidden = NO;
                    isSelected = NO;
                }
            }else{
                isHidden = YES;
            }
        }else if (_listType == FamilyMemberListGroupBanned){
            imageName = @"family_group_banned";
            selectImageName = @"family_group_canclebanned";
            GroupModel * model = GetCore(GroupCore).groupInfor;
            if (self.groupInfor) {
                if (self.groupInfor.role == GroupMemberRole_Owner || self.groupInfor.uid == [[GetCore(AuthCore) getUid] userIDValue] ||(model.role == GroupMemberRole_Manager && self.groupInfor.role == GroupMemberRole_Manager)) {
                    isHidden = YES;
                }else{
                    isHidden = NO;
                    if (self.groupInfor.isDisable) {
                        isSelected = NO;
                    }else{
                        isSelected = YES;
                    }
                }
            }else{
                isHidden = YES;
            }
        }else{
            isHidden = YES;
        }
        if (imageName.length > 0) {
            [self.typeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        if (selectImageName.length >0) {
            [self.typeButton setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
        }
        self.typeButton.selected = isSelected;
        self.typeButton.hidden = isHidden;
    }
    
    if (self.listType == FamilyMemberListGroupManager) {
        if (self.groupInfor.role == GroupMemberRole_Owner) {
            self.positionImageView.image = [UIImage imageNamed:@"family_person_patria"];
            self.positionImageView.hidden = NO;
            [self.positionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(34);
            }];
        }else if (self.groupInfor.role == GroupMemberRole_Manager){
            self.positionImageView.image = [UIImage imageNamed:@"family_position_manager"];
            self.positionImageView.hidden = NO;
            [self.positionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(41);
            }];
        }else{
            self.positionImageView.hidden = YES;
        }
    }
}

- (void)setSelectMemberDic:(NSMutableDictionary *)selectMemberDic{
    _selectMemberDic = selectMemberDic;
    if (self.selectMemberDic && self.selectMemberDic.allKeys.count > 0) {
        if (self.listType == FamilyMemberAddGroup || self.listType == FamilyMemberListCreateGroup) {
            if (self.selectMemberDic && [self.selectMemberDic allKeys].count > 0) {
                if ([[self.selectMemberDic allKeys] containsObject:self.familyInfor.uid]) {
                    XCFamilyModel * selectmodel = [self.selectMemberDic objectForKey:[NSString stringWithFormat:@"%@", self.familyInfor.uid]];
                    self.typeButton.selected = selectmodel.isSelect;
                }
            }else{
                self.typeButton.selected = self.familyInfor.isSelect;
            }
        }else if (self.listType == FamilyMemberListGroupManager
                  || self.listType == FamilyMemberListGroupBanned){
            if ([[self.selectMemberDic allKeys] containsObject:[NSString stringWithFormat:@"%lld", self.groupInfor.uid]]) {
                GroupMemberModel * selectmodel = [self.selectMemberDic objectForKey:[NSString stringWithFormat:@"%lld", self.groupInfor.uid]];
                self.groupInfor = selectmodel;
            }
        }
    }
}

#pragma mark - private method
- (void)initView{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.positionImageView];
    [self.contentView addSubview:self.idLabel];
    [self.contentView addSubview:self.typeButton];
    [self.contentView addSubview:self.sepView];
    [self.contentView addSubview:self.inviteButton];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initContrations{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(34);
        make.centerX.bottom.mas_equalTo(self.iconImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(1);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-35);
    }];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
    
}
#pragma mark - setters and getters
- (UIImageView*)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)positionImageView{
    if (!_positionImageView) {
        _positionImageView = [[UIImageView alloc] init];
    }
    return _positionImageView;
}

- (YYLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)idLabel{
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _idLabel.font = [UIFont systemFontOfSize:12];
    }
    return _idLabel;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}

- (UIButton *)typeButton{
    if (!_typeButton) {
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeButton;
}

-(UIButton *)inviteButton{
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_inviteButton setImage:[UIImage imageNamed:@"family_create_notchoose"] forState:UIControlStateNormal];
        [_inviteButton setImage:[UIImage imageNamed:@"family_create_choose"] forState:UIControlStateSelected];
        _inviteButton.hidden = YES;
    }
    return _inviteButton;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
