//
//  XCPersonInfoCell.m
//  XChat
//
//  Created by 卫明何 on 2018/1/27.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTSessionPersonInfoCell.h"
#import "UIColor+UIColor_Hex.h"
#import <Masonry.h>
#import "UIImageView+QiNiu.h"

@interface TTSessionPersonInfoCell ()
@property (nonatomic, strong)UIImageView *avatar;
@property (nonatomic, strong)UILabel *nickLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation TTSessionPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstraints];
        self.avatar.layer.cornerRadius = 20;
        self.avatar.layer.masksToBounds = YES;
    }
    return self;
}


- (void)initConstraints {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatar.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.avatar.mas_centerY);
        make.width.mas_equalTo(200);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(0);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)initView {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.subTitleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getter

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]init];
    }
    return _avatar;
}

- (UILabel *)nickLabel {
    if (_nickLabel == nil) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.font = [UIFont systemFontOfSize:15];
        _nickLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nickLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTitleLabel.text = @"个人主页";
    }
    return _subTitleLabel;
}

#pragma mark - Setter

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    self.nickLabel.text = self.userInfo.nick;
    [self.avatar qn_setImageImageWithUrl:userInfo.avatar placeholderImage:@"loading_avatar" type:(ImageType)ImageTypeUserIcon];
}

@end
