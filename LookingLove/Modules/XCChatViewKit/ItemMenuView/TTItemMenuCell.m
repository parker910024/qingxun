//
//  TTItemMenuCell.m
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTItemMenuCell.h"

//tool
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"

@interface TTItemMenuCell ()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation TTItemMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
}

- (void)initConstrations {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(19);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.icon.mas_trailing).offset(15);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-15);
    }];
}

- (void)setItem:(TTItemMenuItem *)item {
    _item = item;
    [self.icon setImage:[UIImage imageNamed:item.iconName]];
    [self.titleLabel setText:item.title];
    [self.titleLabel setTextColor:item.titleColor];
    [self.titleLabel setFont:item.titleFont];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGB(0x1a1a1a);
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _titleLabel;
}

@end
