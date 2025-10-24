//
//  TTMineInfoGiftEmptyCell.m
//  TuTu
//
//  Created by lee on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoGiftEmptyCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTMineInfoGiftEmptyCell ()

@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation TTMineInfoGiftEmptyCell

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
    [self.contentView addSubview:self.emptyImageView];
    [self.contentView addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(185, 145));
        make.centerX.mas_equalTo(0);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(4);
        make.centerX.mas_equalTo(0);
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
- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
    return _emptyImageView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"还没有收到礼物哦";
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:13.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _tipsLabel;
}

@end
