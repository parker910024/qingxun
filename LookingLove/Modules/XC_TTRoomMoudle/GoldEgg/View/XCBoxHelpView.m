//
//  XCBoxHelpView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxHelpView.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

#import "BoxCore.h"
#import "BoxCoreClient.h"
#import "NSArray+Safe.h"
#import "XC_HHBoxRateTableViewCell.h"
#import "XCMacros.h"

@interface XCBoxHelpView()<BoxCoreClient>

@property (nonatomic, strong) UIButton *closeButton;//close
@property (nonatomic, strong) UILabel *titleLabel;//title
@property (nonatomic, strong) UIImageView *helpImageView;//help
@property (nonatomic, strong) UIScrollView *scrollView; // 容器

@property (nonatomic, strong) UIImageView *goldEggIcon; // icon
@property (nonatomic, strong) UIImageView *goldEggRuleIcon; // 活动规则

@end

@implementation XCBoxHelpView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - event response
- (void)close{
    [self removeFromSuperview];
}

#pragma mark - puble method
- (void)updateImage:(NSString *)imageURL{
    [self.helpImageView qn_setImageImageWithUrl:imageURL placeholderImage:nil type:ImageTypeUserLibaryDetail];
}

- (void)setIsDiamondBox:(BOOL)isDiamondBox {
    _isDiamondBox = isDiamondBox;
    
    if (self.isDiamondBox) {
        self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"goldEgg_glod_list_bg"].CGImage);
    } else {
        self.backgroundColor = UIColorFromRGB(0x4C076C);
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
    }
}


#pragma mark - Private
- (void)setupSubviews{
    self.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
    
    [self addSubview:self.scrollView];
    [self addSubview:self.closeButton];
    [self addSubview:self.goldEggIcon];
    [self addSubview:self.goldEggRuleIcon];
    
    [self.scrollView addSubview:self.helpImageView];
    
    AddCoreClient(BoxCoreClient, self);
}

- (void)setupSubviewsConstraints{

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.top.right.equalTo(self).inset(12);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(67);
        make.left.equalTo(self).offset(15);
        make.right.bottom.equalTo(self).offset(-15);
    }];
    
    [self.helpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.scrollView).offset(-12);
        make.edges.mas_equalTo(self.scrollView).insets(UIEdgeInsetsMake(0, 12, 0, 0));
    }];

    [self.goldEggIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(22);
    }];
    
    [self.goldEggRuleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goldEggIcon.mas_right).offset(6);
        make.centerY.mas_equalTo(self.goldEggIcon);
    }];
}

#pragma mark - Getter
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"room_box_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"活动规则";
    }
    return _titleLabel;
}
- (UIImageView *)helpImageView{
    if (!_helpImageView) {
        _helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 311, 400)];
        _helpImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _helpImageView;
}

- (UIImageView *)goldEggIcon {
    if (!_goldEggIcon) {
        _goldEggIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldEgg_tips_icon"]];
    }
    return _goldEggIcon;
}

- (UIImageView *)goldEggRuleIcon {
    if (!_goldEggRuleIcon) {
        _goldEggRuleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldEgg_rules_icon"]];
    }
    return _goldEggRuleIcon;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 560);
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
