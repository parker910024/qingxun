//
//  TTGuildIncomeDetailsCell.m
//  TuTu
//
//  Created by lee on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeDetailsCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// tools
#import <YYText/YYText.h>
#import "UIImageView+QiNiu.h"
// model
#import "GuildIncomeDetail.h"

@interface TTGuildIncomeDetailsCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *giftName;
/** 礼物价格 & 数量 */
@property (nonatomic, strong) YYLabel *giftCountAndPrice;
@end

@implementation TTGuildIncomeDetailsCell

#pragma mark -
#pragma mark lifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}
- (void)initViews {
    [self addSubview:self.bgView];
    [self addSubview:self.giftImageView];
    [self addSubview:self.giftName];
    [self addSubview:self.giftCountAndPrice];
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_width);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(7);
        make.left.right.mas_equalTo(self).inset(18);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).inset(8);
    }];
    
    [self.giftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.giftCountAndPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftName.mas_bottom).offset(6);
        make.centerX.mas_equalTo(self);
        make.left.right.mas_equalTo(self).inset(7);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setDetailModel:(GuildIncomeDetail *)detailModel {
    _detailModel = detailModel;
    [self.giftImageView qn_setImageImageWithUrl:detailModel.picUrl placeholderImage:nil type:ImageTypeUserLibary];
    self.giftName.text = detailModel.giftName;
//    self.giftCountAndPrice.text = [NSString stringWithFormat:@"%@%@", detailModel.goldPrice, detailModel.giftNum];
    self.giftCountAndPrice.attributedText = [self configAttributedGiftName:nil giftCount:detailModel.giftNum giftPirce: detailModel.goldPrice];
}

- (NSMutableAttributedString *)configAttributedGiftName:(NSString *)name giftCount:(NSString *)count giftPirce:(NSString *)price {
    NSString *str = [NSString stringWithFormat:@"%@金币\nX%@", price, count];
    NSRange priceRange = [str rangeOfString:price];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    attStr.yy_font = [UIFont systemFontOfSize:12];
    attStr.yy_color = [XCTheme getTTDeepGrayTextColor];
    attStr.yy_alignment = NSTextAlignmentCenter;
    [attStr yy_setColor:[XCTheme getTTMainColor] range:priceRange];
    return attStr;
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _bgView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _giftImageView;
}

- (UILabel *)giftName
{
    if (!_giftName) {
        _giftName = [[UILabel alloc] init];
        _giftName.text = @"么么哒";
        _giftName.textColor = [XCTheme getMSMainTextColor];
        _giftName.font = [UIFont systemFontOfSize:14.f];
        _giftName.adjustsFontSizeToFitWidth = YES;
    }
    return _giftName;
}

- (YYLabel *)giftCountAndPrice {
    if (!_giftCountAndPrice) {
        _giftCountAndPrice = [[YYLabel alloc] init];
        _giftCountAndPrice.displaysAsynchronously = YES;
        _giftCountAndPrice.fadeOnAsynchronouslyDisplay = NO;
        _giftCountAndPrice.fadeOnHighlight = NO;
        _giftCountAndPrice.numberOfLines = 2;
        _giftCountAndPrice.font = [UIFont systemFontOfSize:12];
        _giftCountAndPrice.textColor = [XCTheme getTTDeepGrayTextColor];
        _giftCountAndPrice.text = @"1231231金币\n x 2490";
        _giftCountAndPrice.textAlignment = NSTextAlignmentCenter;
    }
    return _giftCountAndPrice;
}
@end
