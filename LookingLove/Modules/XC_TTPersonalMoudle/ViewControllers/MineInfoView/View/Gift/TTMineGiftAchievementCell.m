//
//  TTMineGiftAchievementCell.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/2/24.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineGiftAchievementCell.h"

#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "UIButton+EnlargeTouchArea.h"

#import "UserGiftAchievementList.h"

#import <Masonry/Masonry.h>

@interface TTMineGiftAchievementCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *maskImageView;//未获取蒙层
@property (nonatomic, strong) UIButton *markButton;//问号？
@property (nonatomic, strong) UIImageView *giftImage;
@property (nonatomic, strong) UILabel *giftName;
@property (nonatomic, strong) UILabel *giftNumber;

@end

@implementation TTMineGiftAchievementCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.markButton];
    [self.contentView addSubview:self.giftImage];
    [self.contentView addSubview:self.giftName];
    [self.contentView addSubview:self.giftNumber];
    [self.contentView addSubview:self.maskImageView];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.bgImageView.mas_width);
    }];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
    }];
    [self.giftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgImageView).inset(20);
    }];
    [self.giftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    [self.giftNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftName.mas_bottom).offset(4);
        make.left.right.mas_equalTo(0);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgImageView);
    }];
}

/// 该礼物是否没有点亮
- (BOOL)unlightedGift {
    BOOL unlighted = self.data && self.data.giftSum == 0;//没有点亮，置灰
    return unlighted;
}

/// 根据分类名获取背景颜色
- (NSString *)bgImageWithCategoryName:(NSString *)categoryName {
    NSString *image = @"mine_gift_bg_yellow";
    NSDictionary *dic = @{@"传说礼物": @"mine_gift_bg_yellow",
                          @"史诗礼物": @"mine_gift_bg_purple",
                          @"稀有礼物": @"mine_gift_bg_pink",
                          @"限定礼物": @"mine_gift_bg_blue"};
    if ([[dic allKeys] containsObject:categoryName]) {
        image = [dic objectForKey:categoryName];
    }
    return image;
}

#pragma mark - Public
/// 配置背景图片，根据分类名字hardcode
/// @param categoryName 分类名
- (void)configBgImageWithCategoryName:(NSString *)categoryName {
    
    BOOL unlighted = [self unlightedGift];
    self.maskImageView.hidden = !unlighted;
    if (unlighted) {
        self.bgImageView.image = [UIImage imageNamed:@"mine_gift_bg_gray"];
        return;
    }
    
    NSString *imageName = [self bgImageWithCategoryName:categoryName];
    self.bgImageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - Getter && Setter
- (void)setData:(UserGiftAchievementItem *)data {
    _data = data;
    
    [self.giftImage qn_setImageImageWithUrl:data.picUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomMagic];

    self.giftName.text = data.giftName;
    self.giftNumber.text = [NSString stringWithFormat:@"%ld", data.giftSum];
    self.markButton.hidden = data.tip.length == 0;
    
    BOOL unlighted = [self unlightedGift];
    self.maskImageView.hidden = !unlighted;
    self.giftName.textColor = unlighted ? UIColorFromRGB(0xABAAB2) : UIColorFromRGB(0x626166);
    if (unlighted) {
        self.bgImageView.image = [UIImage imageNamed:@"mine_gift_bg_gray"];
        return;
    }
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = [UIImage imageNamed:@"mine_gift_bg_yellow"];
    }
    return _bgImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.contentMode = UIViewContentModeScaleAspectFit;
        _maskImageView.image = [UIImage imageNamed:@"mine_gift_mask"];
        _maskImageView.hidden = YES;
    }
    return _maskImageView;
}

- (UIButton *)markButton {
    if (!_markButton) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setImage:[UIImage imageNamed:@"mine_gift_mark"] forState:UIControlStateNormal];
        _markButton.userInteractionEnabled = NO;
        
        [_markButton enlargeTouchArea:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _markButton;
}

- (UIImageView *)giftImage {
    if (!_giftImage) {
        _giftImage = [[UIImageView alloc] init];
        _giftImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImage;
}

- (UILabel *)giftName {
    if (!_giftName) {
        _giftName = [[UILabel alloc] init];
        _giftName.textAlignment = NSTextAlignmentCenter;
        _giftName.textColor = [XCTheme getTTMainTextColor];
        _giftName.font = [UIFont boldSystemFontOfSize:13];
    }
    return _giftName;
}

- (UILabel *)giftNumber {
    if (!_giftNumber) {
        _giftNumber = [[UILabel alloc] init];
        _giftNumber.textAlignment = NSTextAlignmentCenter;
        _giftNumber.textColor = [XCTheme getMSThirdTextColor];
        _giftNumber.font = [UIFont systemFontOfSize:13];
    }
    return _giftNumber;
}

@end
