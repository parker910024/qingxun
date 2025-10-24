//
//  TTGuildIncomeStatisticSectionHeaderView.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeStatisticSectionHeaderView.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>

#define SCREEN_WIDTH_RATE KScreenWidth/375.0f

@interface TTGuildIncomeStatisticSectionHeaderView ()
@property (nonatomic, strong) UIView *contentContainerView;//#F5F5F5背景容器
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@end

@implementation TTGuildIncomeStatisticSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initView {
    self.contentContainerView = [[UIView alloc] init];
    self.contentContainerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.rankLabel = [self makeLabelWithText:@"排名"];
    self.avatarLabel = [self makeLabelWithText:@"头像"];
    self.nickLabel = [self makeLabelWithText:@"昵称"];
    self.incomeLabel = [self makeLabelWithText:@"收入(金币）"];
    
    [self.contentView addSubview:self.contentContainerView];
    [self.contentContainerView addSubview:self.rankLabel];
    [self.contentContainerView addSubview:self.avatarLabel];
    [self.contentContainerView addSubview:self.nickLabel];
    [self.contentContainerView addSubview:self.incomeLabel];
}

- (void)initConstraints {
    [self.contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(33);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(48*SCREEN_WIDTH_RATE);
    }];
    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rankLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(48*SCREEN_WIDTH_RATE);
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(70*SCREEN_WIDTH_RATE);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(84*SCREEN_WIDTH_RATE);
    }];
}

- (UILabel *)makeLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [XCTheme getTTDeepGrayTextColor];
    label.text = text;
    return label;
}

@end
