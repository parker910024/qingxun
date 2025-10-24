//
//  TTNotificationSettingsCell.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/12/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTNotificationSettingsCell.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTNotificationSettingsCell()
@end

@implementation TTNotificationSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self makeConstriants];
    }
    return self;
}

#pragma mark - event
- (void)switchDidTapped:(UISwitch *) sender {
    if (self.switchClickBlock) {
        self.switchClickBlock(sender.on);
    }
}

#pragma mark - private
- (void)initSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.selectSwitch];
}

- (void)makeConstriants {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(14);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    [self.selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Getter && Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _subtitleLabel;
}

- (UISwitch *)selectSwitch {
    if (_selectSwitch == nil) {
        _selectSwitch = [[UISwitch alloc] init];
        _selectSwitch.onTintColor = [XCTheme getTTMainColor];
        _selectSwitch.tintColor = [XCTheme getTTSimpleGrayColor];
        _selectSwitch.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _selectSwitch.layer.cornerRadius = CGRectGetHeight(_selectSwitch.frame)/2.0;
        _selectSwitch.layer.masksToBounds = YES;
        [_selectSwitch addTarget:self action:@selector(switchDidTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _selectSwitch;
}

@end
