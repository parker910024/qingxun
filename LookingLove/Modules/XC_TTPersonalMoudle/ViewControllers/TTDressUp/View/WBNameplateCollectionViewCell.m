//
//  WBNameplateCollectionViewCell.m
//  WanBan
//
//  Created by ShenJun_Mac on 2020/9/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "WBNameplateCollectionViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YYLabel.h"

#import "BaseAttrbutedStringHandler+TTMineInfo.h"
#import "XCTheme.h"
#import "UIImage+Utils.h"
#import "XCHUDTool.h"


@interface WBNameplateCollectionViewCell()
@property (nonatomic, strong) UIButton *hintImageView;//提示
@property (nonatomic, strong) UIImageView *nameplateImageView;//铭牌图片
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *fixedLabel;//文案
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) UIButton *makeButton;
@property (nonatomic, strong) UIView *nameplateBgView;//铭牌图片

@end

@implementation WBNameplateCollectionViewCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.nameplateBgView];
    [self addSubview:self.hintImageView];
    [self addSubview:self.nameplateImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.makeButton];
    [self addSubview:self.fixedLabel];
    
}

- (void)initConstraints {
    [self.nameplateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
    }];
    
    [self.hintImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.nameplateBgView).inset(4);
    }];
    
    [self.nameplateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.nameplateBgView.mas_centerX);
        make.width.equalTo(@60);
        make.height.equalTo(@15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-7);
        make.left.equalTo(self.nameplateBgView.mas_right).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(7);
        make.left.equalTo(self.nameplateBgView.mas_right).offset(10);
    }];
    
    [self.makeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@85);
        make.height.equalTo(@33);
    }];
    
    [self.fixedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameplateImageView.mas_centerY);
        make.left.equalTo(self.nameplateImageView.mas_left).offset(17);
        make.width.equalTo(@40);
    }];
}

//是否使用(0 -- 未使用, 1 -- 使用中, 2 --待制作, 3 -- 已制作
- (void)configMakeButton:(NSInteger)used {
    switch (used) {
        case 0: {
            [_makeButton setTitle:@"使用" forState:normal];
            [_makeButton setTitleColor:UIColorFromRGB(0x343434) forState:normal];
            [_makeButton setBackgroundColor:UIColorFromRGB(0x34EBDE)];
            _makeButton.layer.borderColor = UIColorFromRGB(0x343434).CGColor;
        }
            break;
        case 1: {
            [_makeButton setTitle:@"摘下" forState:normal];
            [_makeButton setTitleColor:UIColorFromRGB(0x343434) forState:normal];
            [_makeButton setBackgroundColor:[UIColor whiteColor]];
            _makeButton.layer.borderColor = UIColorFromRGB(0xB4B4B4).CGColor;
        }
            break;
        case 2: {
            [_makeButton setTitle:@"制作" forState:normal];
            [_makeButton setTitleColor:UIColorFromRGB(0x343434) forState:normal];            
            [_makeButton setBackgroundColor:UIColorFromRGB(0xFF8484)];
            _makeButton.layer.borderColor = UIColorFromRGB(0x343434).CGColor;
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Action
- (void)makeButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMakeButtonClicked:)]) {
        [self.delegate onMakeButtonClicked:self.model];
    }
}

- (void)hintButtonClick {
    [XCHUDTool showErrorWithMessage:self.model.desc];
}

#pragma mark - Setter && Getter
- (void)setModel:(WBUserNameplate *)model {
    _model = model;
    [self.nameplateImageView sd_setImageWithURL:[NSURL URLWithString:model.iconPic]];
    self.nameLabel.text = model.name;
    self.timeLabel.attributedText = [BaseAttrbutedStringHandler creatNameplateTitle:model.expireDate];
    [self configMakeButton:model.used];
    if (!model.desc || [model.desc isEqualToString:@""]) {
        self.hintImageView.hidden = YES;
    } else {
        self.hintImageView.hidden = NO;
    }
    
    self.fixedLabel.text = model.fixedWord;
    if (model.expireDate < 0) {
        self.makeButton.hidden = YES;
    } else {
        self.makeButton.hidden = NO;
    }
}

- (UIButton *)hintImageView {
    if (!_hintImageView) {
        _hintImageView = [UIButton new];
        [_hintImageView setBackgroundImage:[UIImage imageNamed:@"person_nameplate_hint"] forState:normal];
        [_hintImageView addTarget:self action:@selector(hintButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hintImageView;
}

- (UIImageView *)nameplateImageView {
    if (!_nameplateImageView) {
        _nameplateImageView = [UIImageView new];
    }
    return _nameplateImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _nameLabel.textColor = UIColorFromRGB(0x333333);
        
    }
    return _nameLabel;
}

- (YYLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [YYLabel new];
    }
    return _timeLabel;
}

- (UIButton *)makeButton {
    if (!_makeButton) {
        _makeButton = [UIButton new];
        [_makeButton setTitle:@"制作" forState:normal];
        _makeButton.layer.cornerRadius = 33/2;
        _makeButton.layer.masksToBounds = YES;
        [_makeButton setTitleColor:[UIColor whiteColor] forState:normal];
        _makeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_makeButton addTarget:self action:@selector(makeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _makeButton.layer.borderWidth = 1.5;
    }
    return _makeButton;
}

- (UILabel *)fixedLabel {
    if (!_fixedLabel) {
        _fixedLabel = [UILabel new];
        _fixedLabel.textColor = [UIColor whiteColor];
        _fixedLabel.font = [UIFont systemFontOfSize:9];
        _fixedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fixedLabel;
}

- (UIView *)nameplateBgView {
    if (!_nameplateBgView) {
        _nameplateBgView = [UIView new];
        _nameplateBgView.backgroundColor = UIColorFromRGB(0xFAFAFA);
        _nameplateBgView.layer.cornerRadius = 10;
    }
    return _nameplateBgView;
}
@end
