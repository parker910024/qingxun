//
//  TTRoomSettingsCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomSettingsCell.h"

#import "TTRoomSettingsConfig.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTRoomSettingsCell ()

/**
 房间设置 cell 类型
 */
@property (nonatomic, assign) TTRoomSettingsCellStyle cellStyle;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIView *separateLine;
@end

@implementation TTRoomSettingsCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - public method
#pragma mark - system protocols
#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)switchDidTapped:(UISwitch *)sender {
    if (self.switchClickBlock) {
        self.switchClickBlock(sender.on);
    }
}

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.separateLine];
    [self.contentView addSubview:self.selectSwitch];
    [self.contentView addSubview:self.detailLabel];
}

- (void)initConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.selectSwitch);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).offset(20);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.selectSwitch);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.selectSwitch);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.selectSwitch);
    }];
    
    [self.selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(7);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-72);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
}

#pragma mark - getters and setters
- (void)setConfig:(TTRoomSettingsConfig *)config {
    _config = config;
    
    self.cellStyle = config.cellStyle;
    self.nameLabel.text = config.name;
}

- (void)setCellStyle:(TTRoomSettingsCellStyle)cellStyle {
    _cellStyle = cellStyle;
    
    switch (cellStyle) {
            
        case TTRoomSettingsCellStyleArrow: {
            self.selectSwitch.hidden = YES;
            self.contentLabel.hidden = YES;
            self.arrowImageView.hidden = NO;
            self.detailLabel.hidden = YES;
            self.contentImageView.hidden = YES;
        }
            break;
            
        case TTRoomSettingsCellStyleContentArrow: {
            self.selectSwitch.hidden = YES;
            self.contentLabel.hidden = NO;
            self.arrowImageView.hidden = NO;
            self.detailLabel.hidden = YES;
            self.contentImageView.hidden = YES;
        }
            break;
            
        case TTRoomSettingsCellStyleSwitch: {
            self.selectSwitch.hidden = NO;
            self.contentLabel.hidden = YES;
            self.arrowImageView.hidden = YES;
            self.detailLabel.hidden = YES;
            self.contentImageView.hidden = YES;
        }
            break;
            
        case TTRoomSettingsCellStyleSwitchDetail: {
            self.selectSwitch.hidden = NO;
            self.contentLabel.hidden = YES;
            self.arrowImageView.hidden = YES;
            self.detailLabel.hidden = NO;
            self.contentImageView.hidden = YES;
        }
            break;
            
        case TTRoomSettingsCellStyleImage: {
            self.selectSwitch.hidden = YES;
            self.contentLabel.hidden = YES;
            self.arrowImageView.hidden = YES;
            self.detailLabel.hidden = YES;
            self.contentImageView.hidden = NO;
        }
        default:
            break;
    }
}

- (void)setHiddenSeparateLine:(BOOL)hiddenSeparateLine {
    _hiddenSeparateLine = hiddenSeparateLine;
    
    self.separateLine.hidden = hiddenSeparateLine;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _contentLabel.font = [UIFont systemFontOfSize:13];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"room_settings_arrow"];
        [_arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _arrowImageView;
}

- (UIImageView *)contentImageView {
    
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        [_contentImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_contentImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _contentImageView;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [XCTheme getLineDefaultGrayColor];
    }
    return _separateLine;
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

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

@end
