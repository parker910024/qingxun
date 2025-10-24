//
//  TTKeeperManagerCell.m
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTKeeperManagerCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// model
#import "GuildHallManagerInfo.h"

@interface TTKeeperManagerCell ()
@property (nonatomic, strong) UISwitch *onSwitch;
@end

@implementation TTKeeperManagerCell

#pragma mark -
#pragma mark lifeCycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupText];
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.onSwitch];
}

- (void)initConstraints {
    [self.onSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(24);
    }];
}

- (void)setupText {
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [XCTheme getTTMainTextColor];
    self.detailTextLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setManagerInfo:(GuildHallManagerInfo *)managerInfo {
    _managerInfo = managerInfo;
    self.textLabel.text = managerInfo.name;
    self.detailTextLabel.text = managerInfo.desc;
    self.onSwitch.on = managerInfo.status;
}

#pragma mark -
#pragma mark button click events
- (void)onSwitchClickChangeHandler:(UISwitch *)onSwitch {
    // 改变
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSwClickHandler:authStr:)]) {
        [self.delegate onSwClickHandler:onSwitch authStr:self.managerInfo.code];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UISwitch *)onSwitch {
    if (!_onSwitch) {
        _onSwitch = [[UISwitch alloc] init];
        _onSwitch.onTintColor = [XCTheme getTTMainColor];
        [_onSwitch addTarget:self action:@selector(onSwitchClickChangeHandler:) forControlEvents:UIControlEventValueChanged];
    }
    return _onSwitch;
}
@end
