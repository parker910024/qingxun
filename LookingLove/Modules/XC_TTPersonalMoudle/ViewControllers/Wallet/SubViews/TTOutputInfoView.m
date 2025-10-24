//
//  TTOutputInfoView.m
//  TuTu
//
//  Created by Macx on 2018/12/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTOutputInfoView.h"
#import "TTOutputEnumConst.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XCKeyWordTool.h"
#import "UIImageView+QiNiu.h"
// model
#import "ZXCInfo.h"

@interface TTOutputInfoView ()

@property (nonatomic, strong) UIView *accountInfoView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *rightArrowImageView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *realNameLabel;

@property (nonatomic, strong) UIImageView *diamondImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countNumLabel;

@property (nonatomic, strong) UILabel *leftLabel;

@end


@implementation TTOutputInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
        [self addViewClickGestureRecognizer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.accountInfoView];
    [self addSubview:self.diamondImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countNumLabel];
    [self addSubview:self.leftLabel];
    
    [self.accountInfoView addSubview:self.iconImageView];
    [self.accountInfoView addSubview:self.accountLabel];
    [self.accountInfoView addSubview:self.realNameLabel];
    [self.accountInfoView addSubview:self.descLabel];
    [self.accountInfoView addSubview:self.rightArrowImageView];
    [self.accountInfoView addSubview:self.lineView];
}

- (void)initConstraints {
    
    [self.accountInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconImageView);
    }];
    
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountLabel);
        make.bottom.mas_equalTo(self.iconImageView);
    }];
    
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0).inset(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.accountInfoView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(67, 67));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.diamondImageView.mas_bottom).offset(8);
    }];
    
    [self.countNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    /**  */
}

#pragma mark -
#pragma mark setup data
- (void)setZxcInfo:(ZXCInfo *)zxcInfo {
    _zxcInfo = zxcInfo;
    
    if (zxcInfo.zxcAccount.length != 0 &&
        zxcInfo.zxcAccountName.length != 0) {
        _accountLabel.text = [NSString stringWithFormat:@"%@：%@", [XCKeyWordTool sharedInstance].xczAccount, zxcInfo.zxcAccount];
        _realNameLabel.text = [NSString stringWithFormat:@"真实姓名：%@", zxcInfo.zxcAccountName];
        _descLabel.hidden = _rightArrowImageView.hidden = YES;
        _realNameLabel.hidden = _accountLabel.hidden = NO;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:kHelloWorld_blue]];
    } else {
        _accountLabel.hidden = _realNameLabel.hidden = YES;
        _descLabel.hidden = _rightArrowImageView.hidden = NO;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:kHelloWorld_gray]];
    }
    _countNumLabel.text = [NSString stringWithFormat:@"%.2f",zxcInfo.diamondNum.floatValue];
}

- (void)setOutputType:(TTOutputViewType)outputType{
    _outputType = outputType;
    switch (outputType) {
        case TTOutputViewTypexcCF:
        {
            _diamondImageView.image = [UIImage imageNamed:@"output_diaIcon"];
            _titleLabel.text = [NSString stringWithFormat:@"%@余额", [XCKeyWordTool sharedInstance].xcCF];
        }
            break;
        case TTOutputViewTypexcRedColor:
        {
            _diamondImageView.image = [UIImage imageNamed:@"output_redColor"];
            _titleLabel.text = @"奖励金余额";
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark methods
- (void)addViewClickGestureRecognizer {
    
    self.accountInfoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction)];
    [self.accountInfoView addGestureRecognizer:tap];
}

#pragma mark -
#pragma mark click GestureRecognizer
- (void)viewClickAction {
    !_infoViewClickHandler ? :  _infoViewClickHandler();
}

#pragma mark -
#pragma mark getter & setter
- (UIView *)accountInfoView
{
    if (!_accountInfoView) {
        _accountInfoView = [[UIView alloc] init];
    }
    return _accountInfoView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = [NSString stringWithFormat:@"请绑定你的%@账号",[XCKeyWordTool sharedInstance].xczAccount];
        _descLabel.textColor = [XCTheme getMSMainTextColor];
        _descLabel.font = [UIFont systemFontOfSize:15.f];
        _descLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _descLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 25.f;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)rightArrowImageView
{
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"output_rightArrow"]];
    }
    return _rightArrowImageView;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = [XCTheme getMSMainTextColor];
        _accountLabel.font = [UIFont systemFontOfSize:15.f];
        _accountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _accountLabel;
}

- (UILabel *)realNameLabel
{
    if (!_realNameLabel) {
        _realNameLabel = [[UILabel alloc] init];
        _realNameLabel.textColor = [XCTheme getMSMainTextColor];
        _realNameLabel.font = [UIFont systemFontOfSize:15.f];
        _realNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _realNameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _lineView;
}

- (UIImageView *)diamondImageView
{
    if (!_diamondImageView) {
        _diamondImageView = [[UIImageView alloc] init];
    }
    return _diamondImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countNumLabel
{
    if (!_countNumLabel) {
        _countNumLabel = [[UILabel alloc] init];
        _countNumLabel.text = @"0";
        _countNumLabel.textColor = [XCTheme getMSMainTextColor];
        _countNumLabel.font = [UIFont boldSystemFontOfSize:21.f];
        _countNumLabel.adjustsFontSizeToFitWidth = YES;
        _countNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countNumLabel;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = [NSString stringWithFormat:@"选择%@金额", [XCKeyWordTool sharedInstance].xcCF];
        _leftLabel.textColor = [XCTheme getMSMainTextColor];
        _leftLabel.font = [UIFont systemFontOfSize:15.f];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _leftLabel;
}
@end
