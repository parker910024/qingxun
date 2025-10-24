//
//  TTGuildMemberHeaderSectionView.m
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildMemberHeaderSectionView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTGuildMemberHeaderSectionView ()
@end

@implementation TTGuildMemberHeaderSectionView

#pragma mark -
#pragma mark lifeCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addSubview:self.countLabel];
}

- (void)initConstraints {
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(8);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.text = @"总人数:0人";
        _countLabel.textColor = [XCTheme getMSMainTextColor];
        _countLabel.font = [UIFont systemFontOfSize:12.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _countLabel;
}
@end
