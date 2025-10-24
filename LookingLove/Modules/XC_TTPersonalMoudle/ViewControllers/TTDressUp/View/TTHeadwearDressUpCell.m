//
//  TTHeadwearDressUpCell.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHeadwearDressUpCell.h"

#import "UserHeadWear.h"

#import <YYAnimatedImageView.h>
#import "SpriteSheetImageManager.h"
//core client
#import "TTDressUpUIClient.h"

//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "TTPersonModuleTools.h"

@interface TTHeadwearDressUpCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView  *limitIcon;//

@property (nonatomic, strong) UIView  *topView;//
@property (nonatomic, strong) SpriteSheetImageManager  *manager;//
@property (nonatomic, strong) YYAnimatedImageView  *headwearImageView;//

@property (nonatomic, strong) UILabel *headwearNameLabel;
@property (nonatomic, strong) UILabel *goldNumLabel;

@end

@implementation TTHeadwearDressUpCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.topView];
    [self.containerView addSubview:self.headwearNameLabel];
    [self.containerView addSubview:self.limitIcon];
    [self.topView addSubview:self.headwearImageView];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.limitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.containerView).offset(6);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.containerView);
    }];
    [self.headwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.topView).inset(8);
        make.bottom.mas_equalTo(self.contentView).inset(43);
    }];
    [self.headwearNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.width.lessThanOrEqualTo(self.containerView);
        make.top.mas_equalTo(self.headwearImageView.mas_bottom).offset(18);
    }];
}

#pragma mark - Setter && Getter

- (void)setHeadwear:(UserHeadWear *)headwear {
    _headwear = headwear;
    NSString *imageName = [TTPersonModuleTools getNameFromDressUpLimitType:headwear];
    self.limitIcon.image = [UIImage imageNamed:imageName];
    [self.manager loadSpriteSheetImageWithURL:[NSURL URLWithString:_headwear.effect] completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
        self.headwearImageView.image = sprit;
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    self.headwearNameLabel.text = _headwear.name;
    if (_headwear.labelType == DressUpLabelType_Limit || _headwear.labelType == DressUpLabelType_Exclusive) {
        self.goldNumLabel.attributedText = nil;
        self.goldNumLabel.text = @"暂不出售";
    }else {
        self.goldNumLabel.attributedText = [TTPersonModuleTools getPriceAttriButeStringWithPrice:_headwear.price];
        
    }
    
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.topView.layer.borderWidth = _isSelect?2:0;
    self.topView.backgroundColor = _isSelect ? UIColor.whiteColor : UIColorFromRGB(0xFAFAFA);
    self.headwearNameLabel.textColor = _isSelect ? [XCTheme getTTMainColor] : [XCTheme getTTMainTextColor];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)limitIcon {
    if (!_limitIcon) {
        _limitIcon = [[UIImageView alloc] init];
    }
    return _limitIcon;
}


- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColorFromRGB(0xFAFAFA);
        _topView.layer.masksToBounds = YES;
        _topView.layer.cornerRadius = 14;
        _topView.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _topView.layer.borderWidth = 0;
    }
    return _topView;
}

- (SpriteSheetImageManager *)manager {
    if (!_manager) {
        _manager = [[SpriteSheetImageManager alloc] init];
    }
    return _manager;
}

- (YYAnimatedImageView *)headwearImageView {
    if (!_headwearImageView) {
        _headwearImageView = [[YYAnimatedImageView alloc] init];
    }
    return _headwearImageView;
}

- (UILabel *)headwearNameLabel {
    if (!_headwearNameLabel) {
        _headwearNameLabel = [[UILabel alloc] init];
        _headwearNameLabel.textColor = [XCTheme getTTMainTextColor];
        _headwearNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _headwearNameLabel;
}

- (UILabel *)goldNumLabel {
    if (!_goldNumLabel) {
        _goldNumLabel = [[UILabel alloc] init];
        _goldNumLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _goldNumLabel.font = [UIFont systemFontOfSize:12];
        _goldNumLabel.text = @"暂不出售";
    }
    return _goldNumLabel;
}

@end
