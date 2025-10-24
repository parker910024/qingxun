//
//  TTSettingCell.m
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSettingCell.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTSettingCell()
@property (nonatomic, strong) UIImageView  *arrowImageView;//
@end

@implementation TTSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - event
- (void)switchDidTapped:(UISwitch *) sender {
    if (self.switchClickBlock) {
        self.switchClickBlock(sender.on);
    }
}

- (void)hiddenArrow:(BOOL)hidden {
    self.arrowImageView.hidden = hidden;
}

#pragma mark - private
- (void)initSubviews {
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.dataLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.selectSwitch];
    
    [self makeConstriants];
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
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-37);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).offset(5);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-11);
        make.centerY.mas_equalTo(self.contentView);
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

- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.font = [UIFont systemFontOfSize:14];
        _dataLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _dataLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_setting_arrow"]];
    }
    return _arrowImageView;
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
