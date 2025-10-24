//
//  TTNewUserCollectionViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTNewUserCollectionViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIImageView+QiNiu.h"
#import <YYLabel.h>
#import "BaseAttrbutedStringHandler.h"
#import "XCMacros.h"

@interface TTNewUserCollectionViewCell ()
/**名字 */
@property (nonatomic, strong) YYLabel * nameLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;

/** id*/
@property (nonatomic, strong) UILabel * numberLabel;
@end
@implementation TTNewUserCollectionViewCell

#pragma mark - life cycle
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContratsions];
    }
    return self;
}

#pragma mark - public method
- (void)configTTNewUserCollectionViewCell:(UserInfo *)infor{
    if (infor) {
        [self.iconImageView qn_setImageImageWithUrl:infor.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        NSString * nick = infor.nick.length > 0 ? infor.nick : @"--";
       NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] init];
        
        BaseAttributedUserGender gender;
        if (infor.gender == UserInfo_Male) {
            gender = BaseAttributedUserGender_Male;
        }else{
            gender = BaseAttributedUserGender_Female;
        }
        CGFloat width;
        if (self.isShowID) {
           width = (KScreenWidth -45) / 3 - 15;
        }else{
             width = (KScreenWidth - 30)/ 4 - 15;
        }
        
        NSDictionary *parma = @{k_NickLabel_Font:[UIFont systemFontOfSize:13],
                                k_NickLabel_Color:[XCTheme getTTMainTextColor],
                                k_NickLabel_MaxWidth:@(width)};
        [attribut appendAttributedString:[BaseAttrbutedStringHandler makeLabelNick:nick labelAttribute:parma]];
         [attribut appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
        
        [attribut appendAttributedString:[BaseAttrbutedStringHandler makeGender:gender]];
        
        self.nameLabel.attributedText = attribut;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        if (self.isShowID) {
            self.numberLabel.text = [NSString stringWithFormat:@"ID:%@", infor.erbanNo];
        }
    }
}

- (void)configTTFamilyGameCellWith:(XCFamilyModel *)familyModel{
    if (familyModel) {
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(70);
        }];
        [self.iconImageView qn_setImageImageWithUrl:familyModel.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        self.iconImageView.layer.cornerRadius = 5;
        self.nameLabel.text = familyModel.name;
    }
}

#pragma mark - prvate method
- (void)initView{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
}

- (void)initContratsions{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(67);
        make.top.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
    }];
    
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
    }];
}

#pragma mark - setters and getters
- (void)setIsShowID:(BOOL)isShowID{
    _isShowID = isShowID;
    if (_isShowID) {
        _numberLabel.hidden = NO;
        _iconImageView.layer.cornerRadius = 67/2;
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(67);
        }];
    }else{
        _numberLabel.hidden = YES;
        _iconImageView.layer.cornerRadius = 60/2;
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
        }];
    }
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 67/2;
    }
    return _iconImageView;
}

- (YYLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor  =  [XCTheme getTTDeepGrayTextColor];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}



@end
