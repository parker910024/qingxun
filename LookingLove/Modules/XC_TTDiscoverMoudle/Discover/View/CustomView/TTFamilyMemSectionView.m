//
//  TTFamilyMemSectionView.m
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMemSectionView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTFamilyMemSectionView ()

@end

@implementation TTFamilyMemSectionView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContration];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
}

- (void)initContration{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self);
    }];
}
#pragma mark - setters and getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor  =  [XCTheme getTTDeepGrayTextColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subtitleLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
