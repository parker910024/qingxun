//
//  TTBlackListCell.m
//  TuTu
//
//  Created by zoey on 2018/11/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTBlackListCell.h"

//view
#import <YYText/YYLabel.h>
//model
#import "UserInfo.h"
//t
#import "BaseAttrbutedStringHandler+TTMineInfo.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIImageView+QiNiu.h"
@interface TTBlackListCell()
@property (strong , nonatomic) UIImageView *avatar;
@property (strong , nonatomic) UIImageView *sexImageView;
@property (strong , nonatomic) YYLabel *nameLabel;
@property (strong , nonatomic) YYLabel *idLabel;
@property (strong , nonatomic) UIView *lineView;
@end

@implementation TTBlackListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.sexImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.idLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatar.mas_right).offset(12);
        make.top.mas_equalTo(self.avatar).offset(3);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
        make.width.height.mas_equalTo(13);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
}



#pragma mark - Setter && Getter

- (void)setInfo:(UserInfo *)info {
    _info = info;
    [self.avatar qn_setImageImageWithUrl:_info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:info.erbanNo attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}];
    if (info.hasPrettyErbanNo) {
        [string insertAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" ID "] atIndex:0];
        [string insertAttributedString:[BaseAttrbutedStringHandler makeBeautyImage] atIndex:0];
    }
    self.idLabel.attributedText = string;
    self.nameLabel.text = _info.nick;
    if (_info.gender == UserInfo_Male){
        self.sexImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].common_sex_male];
    }else {
        self.sexImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].common_sex_female];
    }
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 20;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
    }
    return _sexImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
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
        _lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _lineView;
}

@end
