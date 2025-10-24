//
//  TTPersonEditCell.m
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonEditCell.h"

//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTPersonEditCell()
@property (nonatomic, strong) UIImageView  *arrow;//
@end

@implementation TTPersonEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dataLabel];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.arrow];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(13);
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrow.mas_left).offset(-14);
        make.height.width.mas_equalTo(50);
    }];
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrow.mas_left).offset(-14);
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).offset(5);
    }];
}

#pragma mark - Getter && Setter

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_setting_arrow"]];
    }
    return _arrow;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 25;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.font = [UIFont systemFontOfSize:14];
        _dataLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _dataLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _titleLabel;
}


@end
