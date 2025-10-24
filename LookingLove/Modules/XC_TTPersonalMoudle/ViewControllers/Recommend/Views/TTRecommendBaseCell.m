//
//  TTRecommendBaseCell.m
//  TTPlay
//
//  Created by lee on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRecommendBaseCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// model
#import "RecommendModel.h"
#import "NSDate+TimeCategory.h"
#import <YYText/YYText.h>

@interface TTRecommendBaseCell ()
/** 背景图 */
@property (nonatomic, strong) UIImageView *bgImgView;
/** 推荐卡标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *countLabel;
/** 到期时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 有效期 */
@property (nonatomic, strong) UIButton *effectiveTimeBtn;
/** 立刻使用 */
@property (nonatomic, strong) UIButton *usedNowBtn;
/** 推荐卡状态 */
@property (nonatomic, strong) UIImageView *cellStateImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TTRecommendBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.contentView addSubview:self.bgImgView];
    [self.bgImgView addSubview:self.titleLabel];
    [self.bgImgView addSubview:self.lineView];
    [self.bgImgView addSubview:self.timeLabel];
    [self.bgImgView addSubview:self.countLabel];
    [self.bgImgView addSubview:self.usedNowBtn];
    [self.bgImgView addSubview:self.effectiveTimeBtn];
    [self.bgImgView addSubview:self.cellStateImageView];
}

- (void)initConstraints {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 15, 5, 15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(23);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(3);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    [self.effectiveTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(46);
    }];
    
    [self.usedNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-23);
        make.width.mas_equalTo(86);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.effectiveTimeBtn.mas_bottom).offset(9);
    }];
    
    [self.cellStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-9);
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(78);
    }];
}

- (void)setCellStyle:(TTRecommendCellStyle)cellStyle {
    _cellStyle = cellStyle;
    switch (cellStyle) {
        case TTRecommendCellStyleUsing:
        {// 使用中
            self.effectiveTimeBtn.hidden = YES;
            self.countLabel.hidden = YES;
            self.cellStateImageView.hidden = YES;
            
            self.lineView.hidden = NO;
            self.usedNowBtn.hidden = NO;
            [self.usedNowBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
            [self.usedNowBtn setTitle:@"使用中" forState:UIControlStateNormal];
            self.bgImgView.image = [UIImage imageNamed:@"recommend_Cell_bg"];
        }
            break;
        case TTRecommendCellStyleUnUsed:
        {
            // 未使用
            self.lineView.hidden = YES;
            self.cellStateImageView.hidden = YES;
            
            self.effectiveTimeBtn.hidden = NO;
            self.countLabel.hidden = NO;
            self.usedNowBtn.hidden = NO;
            [self.usedNowBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
            [self.usedNowBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            self.bgImgView.image = [UIImage imageNamed:@"recommend_Cell_bg"];
        }
            break;
        case TTRecommendCellStyleUsed:
        {
            // 已使用
            self.effectiveTimeBtn.hidden = YES;
            self.countLabel.hidden = YES;
            self.usedNowBtn.hidden = YES;
            
            self.lineView.hidden = NO;
            self.cellStateImageView.hidden = NO;
            self.cellStateImageView.image = [UIImage imageNamed:@"recommend_Icon_used"];
            self.bgImgView.image = [UIImage imageNamed:@"recommend_Cell_bg_gary"];
        }
            break;
        case TTRecommendCellStyleInvalid:
        {
            // 已失效
            self.effectiveTimeBtn.hidden = YES;
            self.usedNowBtn.hidden = YES;
            
            self.countLabel.hidden = NO;
            self.lineView.hidden = NO;
            self.cellStateImageView.hidden = NO;
            self.cellStateImageView.image = [UIImage imageNamed:@"recommend_Icon_Invalid"];
            self.bgImgView.image = [UIImage imageNamed:@"recommend_Cell_bg_gary"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setModel:(RecommendModel *)model {
    _model = model;
    self.titleLabel.text = model.cardName;
    self.countLabel.attributedText = [self configCountAttributedStr:@(model.count).stringValue];
    [self.effectiveTimeBtn setTitle:[NSString stringWithFormat:@"%@天", @(model.days).stringValue] forState:UIControlStateNormal];
    if (model.status == RecommendState_Unuse || model.status == RecommendState_Timeout ) {
        self.timeLabel.text = [NSString stringWithFormat:@"有效期至 %@",[self getRecommendCardEndTime]];
    } else {
        self.timeLabel.text = [self makeUseTime:model];
    }
}

- (NSString *)makeUseTime:(RecommendModel *)model {
    NSString *useEndtime = [model getUseEndTime];
    NSString *hours = [useEndtime substringFromIndex:useEndtime.length - 5];
    return [NSString stringWithFormat:@"使用时间 %@ - %@",model.getUseStartTime, hours];
}

- (NSString *)getRecommendCardEndTime {
    NSString *endTime = [NSDate dateStrFromCstampTime:self.model.validEndTime.longLongValue / 1000 withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    return endTime;
}

/**
 富文本显示效果

 @param text 显示数量
 @return 富文本内容
 */
- (NSMutableAttributedString *)configCountAttributedStr:(NSString *)text {
    NSString *str = [NSString stringWithFormat:@"x%@",text];
    NSRange range = [str rangeOfString:text];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    attStr.yy_font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:11];
    [attStr yy_setFont:[UIFont fontWithName:@"DIN-Medium" size:20] range:range];
    attStr.yy_color = [UIColor whiteColor];
    return attStr;
}
#pragma mark -
#pragma mark button click events
- (void)onUseNowBtnClickAction:(UIButton *)btn {
    // 去使用
    !_recommendCellBtnClickHandler ?: _recommendCellBtnClickHandler(self.model);
}

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recommend_Cell_bg"]];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"推荐位小时卡";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.preferredMaxLayoutWidth = 100;
    }
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.text = @"x20";
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:20.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
        _countLabel.hidden = YES;
    }
    return _countLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"有效期至  2019.12.12  24:00";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.f];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

- (UIButton *)usedNowBtn {
    if (!_usedNowBtn) {
        _usedNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_usedNowBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [_usedNowBtn setTitleColor:UIColorFromRGB(0xFBB606) forState:UIControlStateNormal];
        [_usedNowBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        _usedNowBtn.backgroundColor = [UIColor whiteColor];
        _usedNowBtn.layer.masksToBounds = YES;
        _usedNowBtn.layer.cornerRadius = 15;
        [_usedNowBtn addTarget:self action:@selector(onUseNowBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _usedNowBtn.hidden = YES;
    }
    return _usedNowBtn;
}

- (UIButton *)effectiveTimeBtn {
    if (!_effectiveTimeBtn) {
        _effectiveTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_effectiveTimeBtn setTitle:@"7天" forState:UIControlStateNormal];
        _effectiveTimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_effectiveTimeBtn setImage:[UIImage imageNamed:@"recommend_Clock"] forState:UIControlStateNormal];
        [_effectiveTimeBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_effectiveTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:11.f]];
        _effectiveTimeBtn.layer.masksToBounds = YES;
        _effectiveTimeBtn.layer.cornerRadius = 9;
        _effectiveTimeBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        _effectiveTimeBtn.userInteractionEnabled = NO;
        _effectiveTimeBtn.hidden = YES;
    }
    return _effectiveTimeBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.layer.cornerRadius = 1.5f;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UIImageView *)cellStateImageView
{
    if (!_cellStateImageView) {
        _cellStateImageView = [[UIImageView alloc] init];
    }
    return _cellStateImageView;
}

@end
