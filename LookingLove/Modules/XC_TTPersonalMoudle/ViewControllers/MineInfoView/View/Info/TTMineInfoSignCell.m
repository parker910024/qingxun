//
//  TTMineInfoSignCell.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoSignCell.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTMineInfoSignCell ()


@end

@implementation TTMineInfoSignCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)initSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.signLabel];
    [self.contentView addSubview:self.showSignbtn];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(10);
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
}


- (void)showSignBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowSignBtn)]) {
        [self.delegate clickShowSignBtn];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"个性介绍";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)signLabel {
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.text = @"这个人比较神秘，什么都没留下";
        _signLabel.textColor = UIColorFromRGB(0x999999);
        _signLabel.font = [UIFont systemFontOfSize:14];
        _signLabel.numberOfLines = 0;
    }
    return _signLabel;
}

- (UIButton *)showSignbtn {
    if (!_showSignbtn) {
        _showSignbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showSignbtn.hidden = YES;
        [_showSignbtn setImage:[UIImage imageNamed:@"mineInfo_signClose"] forState:UIControlStateNormal];
        [_showSignbtn addTarget:self action:@selector(showSignBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showSignbtn;
}
@end
