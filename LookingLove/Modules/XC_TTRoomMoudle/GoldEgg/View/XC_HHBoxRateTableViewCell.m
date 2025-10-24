//
//  XC_HHBoxRateTableViewCell.m
//  XCRoomMoudle
//
//  Created by Macx on 2019/2/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XC_HHBoxRateTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"

@implementation XC_HHBoxRateTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
        [self initContrations];
    }
    return self;
}

- (void)initContrations{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = RGBCOLOR(215, 215, 215);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}


- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor  = RGBCOLOR(215, 215, 215);
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subtitleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
