
//
//  XC_MSBaseContributionHeadCellView.m
//  AFNetworking
//
//  Created by zoey on 2019/2/12.
//

#import "TTRoomContributionCrownInfoView.h"

#import "XCTheme.h"
#import "Masonry.h"

@implementation TTRoomContributionCrownInfoView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.nickStckView];
    [self addSubview:self.uidLabel];
    [self addSubview:self.accountLabel];
    
    [self.nickStckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_greaterThanOrEqualTo(20);
        make.right.mas_lessThanOrEqualTo(-20);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(13);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.nameLabel).offset(15);
        make.left.right.mas_equalTo(self);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.uidLabel).offset(18);
        make.left.right.mas_equalTo(self);
    }];
}

#pragma mark - Getter && Setter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = UIColorRGBAlpha(0xffffff, 1);
        _nameLabel.text = @"虚位以待";
    }
    return _nameLabel;
}

- (UILabel *)uidLabel {
    if (!_uidLabel) {
        _uidLabel = [[UILabel alloc] init];
        _uidLabel.textAlignment = NSTextAlignmentCenter;
        _uidLabel.font = [UIFont systemFontOfSize:10];
        _uidLabel.textColor = UIColorRGBAlpha(0xffffff, 0.6);
    }
    return _uidLabel;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        _accountLabel.font = [UIFont systemFontOfSize:12];
        _accountLabel.textColor = UIColorRGBAlpha(0xffffff, 1);
    }
    return _accountLabel;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
        _genderImageView.image = [UIImage imageNamed:@"common_sex_female"];
        _genderImageView.hidden = YES;
        
        [_genderImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _genderImageView;
}

- (UIStackView *)nickStckView {
    if (_nickStckView == nil) {
        _nickStckView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nameLabel, self.genderImageView]];
        _nickStckView.spacing = 4;
    }
    return _nickStckView;
}

@end
