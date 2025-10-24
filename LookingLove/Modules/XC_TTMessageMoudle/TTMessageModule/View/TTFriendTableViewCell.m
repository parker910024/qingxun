//
//  TTFriendTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFriendTableViewCell.h"
#import <YYLabel.h>
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "TTMessageAttributedString.h"
#import "TTNobleSourceHelper.h"
#import "VersionCore.h"
#import "UIButton+EnlargeTouchArea.h"

#import "TTSendPresentUserInfo.h"

@interface TTFriendTableViewCell ()
/** 名字*/
@property (nonatomic, strong) YYLabel * titleLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 头饰*/
@property (nonatomic, strong) UIImageView * headewearImageView;
/** 签名*/
@property (nonatomic, strong) UILabel * signLabel;
/** 分割线*/
//@property (nonatomic, strong) UIView * sepView;
/** 找到他 关注*/
@property (nonatomic, strong) UIButton * findButton;
/** 选择*/
@property (nonatomic, strong) UIButton * selectButton;
/** 赠送按钮*/
@property (nonatomic, strong) UIButton * presentButton;

/** 好友的*/
@property (nonatomic, strong) UserInfo * friendInfor;
/** 粉丝和关注的*/
@property (nonatomic, strong) Attention * attention;
@end


@implementation TTFriendTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)selectButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.delegate  && [self.delegate respondsToSelector:@selector(choseUserWithInfor:)]) {
        if (self.cellType == TTFriendTableViewCell_IsSelected) {
            self.friendInfor.isSelected = sender.selected;
            [self.delegate choseUserWithInfor:self.friendInfor];
        }
    }
}

- (void)findButtonAction:(UIButton *)sender{
    if (self.cellType == TTFriendTableViewCell_Focus) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusOrFindFriendWith:cellType:sender:)]) {
            [self.delegate focusOrFindFriendWith:self.friendInfor cellType:self.cellType sender:sender];
        }
    }else if (self.cellType == TTFriendTableViewCell_Find){
        if (self.delegate && [self.delegate respondsToSelector:@selector(findFriendWith:)]) {
            [self.delegate findFriendWith:self.attention];
        }
    }
}


#pragma mark - public method
- (void)configTTFriendTableViewCell:(UserInfo *)infor{
    if (infor) {
        if (self.cellType == TTFriendTableViewCell_RoomChat) {
            NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                        k_NickLabel_Color:[XCTheme getTTMainTextColor],
                                        k_NickLabel_MaxWidth:@(KScreenWidth - 180),
                                        k_NickLabel_LabelHeight:@(22)
                                        };
            NSMutableAttributedString *nick = [BaseAttrbutedStringHandler makeLabelNick:infor.nick labelAttribute:attribute];
            self.titleLabel.attributedText = nick;
        }else{
           self.titleLabel.attributedText = [TTMessageAttributedString createMessageNameWith:infor];
        }
       
          [self.iconImageView qn_setImageImageWithUrl:infor.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        
        if (infor.nobleUsers.headwear && self.cellType != TTFriendTableViewCell_RoomChat) {
            self.headewearImageView.hidden = NO;
           [TTNobleSourceHelper disposeImageView:self.headewearImageView withSource:infor.nobleUsers.headwear imageType:ImageTypeUserLibaryDetail];
        }else{
            self.headewearImageView.hidden = YES;
        }
        self.signLabel.text = infor.userDesc && infor.userDesc.length > 0? infor.userDesc : @"这个人很懒还没有签名";
        self.friendInfor = infor;
    }
}

/** 关注和粉丝给cell赋值*/
- (void)configTTFriendTableViewCellWithAttention:(Attention *)attention{
    if (attention) {
        if (self.cellType == TTFriendTableViewCell_RoomChat) {
            NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                        k_NickLabel_Color:[XCTheme getTTMainTextColor],
                                        k_NickLabel_MaxWidth:@(KScreenWidth - 180),
                                        k_NickLabel_LabelHeight:@(22)
                                        };
            NSMutableAttributedString *nick = [BaseAttrbutedStringHandler makeLabelNick:attention.nick labelAttribute:attribute];
            self.titleLabel.attributedText = nick;
        }else{
            NSMutableAttributedString *nick = [TTMessageAttributedString createMessageNameWithAttention:attention];
            self.titleLabel.attributedText = nick;
        }
        
        [self.iconImageView qn_setImageImageWithUrl:attention.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];

        
        if (attention.nobleUsers.headwear && self.cellType != TTFriendTableViewCell_RoomChat) {
            self.headewearImageView.hidden = NO;
           [TTNobleSourceHelper disposeImageView:self.headewearImageView withSource:attention.nobleUsers.headwear imageType:ImageTypeUserLibaryDetail];
        }else{
            self.headewearImageView.hidden = YES;
        }
        self.signLabel.text = attention.userDesc && attention.userDesc.length > 0? attention.userDesc : @"这个人很懒还没有签名";
        
        NSDictionary * dic = [attention model2dictionary];
        UserInfo * infor = [UserInfo modelDictionary:dic];
        self.friendInfor = infor;
        if (attention.userInRoom) {
            self.attention = attention;
        }
        
        if (self.cellType == TTFriendTableViewCell_Focus) {
            BOOL isMyFriend = [[NIMSDK sharedSDK].userManager isMyFriend:[NSString stringWithFormat:@"%lld",self.friendInfor.uid]];
            if (isMyFriend) {
                [self.findButton setBackgroundColor:UIColorFromRGB(0xcccccc)];
                self.findButton.selected = NO;
            }else{
                [self.findButton setBackgroundColor:[XCTheme getTTMainColor]];
                self.findButton.selected = YES;
            }

        } else if (self.cellType == TTFriendTableViewCell_Find) {
            
        }
    }
}

#pragma mark - Even Response
- (void)presentButtonTapped {
    if (self.delegate  && [self.delegate respondsToSelector:@selector(sendPresentDidSelect:)]) {
        TTSendPresentUserInfo *user;
        if (self.friendInfor != nil) {
            user = [TTSendPresentUserInfo initWithNickname:self.friendInfor.nick userID:self.friendInfor.uid];
        } else if (self.attention != nil) {
            user = [TTSendPresentUserInfo initWithNickname:self.attention.nick userID:self.attention.uid];
        }
        
        NSAssert(user, @"Unexpected issue happen");
        
        [self.delegate sendPresentDidSelect:user];
    }
}

#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
      self.backgroundColor = [UIColor clearColor];
    }
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.headewearImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.signLabel];
    [self.contentView addSubview:self.findButton];
    [self.contentView addSubview:self.presentButton];
    [self.contentView addSubview:self.selectButton];
}

- (void)initContrations {

     [self.headewearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.width.mas_equalTo(70);
         make.centerY.centerX.mas_equalTo(self.iconImageView);
     }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(55);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(12);
        make.right.mas_equalTo(self.contentView).offset(-85);
        make.height.mas_equalTo(15);
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.width.mas_equalTo(KScreenWidth- 150);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.findButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(17);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setters and getters
- (void)setSelectDic:(NSMutableDictionary *)selectDic{
    _selectDic = selectDic;
    
    if (_selectDic && _selectDic.allKeys.count > 0) {
       UserInfo * infor = [_selectDic objectForKey:[NSString stringWithFormat:@"%lld",[self.friendInfor uid]]];
        if (infor) {
            self.selectButton.selected = infor.isSelected;
        }else{
            self.selectButton.selected = NO;
        }
    }
}

- (void)setCellType:(TTFriendTableViewCellType)cellType{
    _cellType = cellType;
    
    self.presentButton.hidden = YES;
    
    if (_cellType == TTFriendTableViewCell_Find) {
        self.findButton.hidden = NO;
        self.selectButton.hidden = YES;
        [self.findButton setBackgroundColor:[UIColor whiteColor]];
        [self.findButton setTitle:@"找到TA" forState:UIControlStateNormal];
        [self.findButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        self.findButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        self.findButton.layer.borderWidth = 1;
    } else if (_cellType == TTFriendTableViewCell_Focus) {
        self.findButton.hidden = NO;
        self.selectButton.hidden = YES;
        [self.findButton setTitle:@"相互关注" forState:UIControlStateNormal];
        [self.findButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.findButton setTitle:@"+关注" forState:UIControlStateSelected];
        [self.findButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if (_cellType == TTFriendTableViewCell_Hidden || _cellType == TTFriendTableViewCell_RoomChat) {
        self.findButton.hidden = YES;
        self.selectButton.hidden = YES;
    } else if (_cellType == TTFriendTableViewCell_IsSelected) {
        self.findButton.hidden = YES;
        self.selectButton.hidden = NO;
    } else if (_cellType == TTFriendTableViewCell_Present) {
        self.findButton.hidden = YES;
        self.selectButton.hidden = YES;
        self.presentButton.hidden = NO;
    }
}

- (UIImageView *)headewearImageView{
    if (!_headewearImageView) {
        _headewearImageView = [[UIImageView alloc] init];

    }
    return _headewearImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 55/2;
    }
    return _iconImageView;
}

- (YYLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =[[YYLabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.textColor  =  [XCTheme getTTDeepGrayTextColor];
        _signLabel.font = [UIFont systemFontOfSize:12];
    }
    return _signLabel;
}


- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"family_create_notchoose"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"family_create_choose"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    }
    return _selectButton;
}

- (UIButton *)findButton{
    if (!_findButton) {
        _findButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _findButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _findButton.layer.cornerRadius = 15;
        _findButton.layer.masksToBounds = YES;
        [_findButton addTarget:self action:@selector(findButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _findButton;
}

- (UIButton *)presentButton {
    if (_presentButton == nil) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentButton setTitle:@"赠送" forState:UIControlStateNormal];
        [_presentButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _presentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _presentButton.layer.cornerRadius = 15;
        _presentButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _presentButton.layer.borderWidth = 0.5;
        
        [_presentButton addTarget:self action:@selector(presentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}

@end
