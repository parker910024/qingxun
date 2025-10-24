//
//  TTHomeRecommendBigRoomCVCell.m
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendBigRoomCVCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "TTHomeV4DetailData.h"
#import "LXSEQView.h"

@interface TTHomeRecommendBigRoomCVCell ()

@property (nonatomic, strong) UILabel *nameLabel;//推荐名称
@property (nonatomic, strong) UIImageView *coverImageView;//封面
@property (nonatomic, strong) UIImageView *lockImageView;//锁
@property (nonatomic, strong) UIImageView *tagImageView;//标签，e.g HOT

@property (nonatomic, strong) LXSEQView *voiceImageView;//音符
@property (nonatomic, strong) UILabel *onlineLabel;//显示在线人数
@property (nonatomic, strong) UIView *onlineBgView;//在线人数背景

@end

@implementation TTHomeRecommendBigRoomCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self updateConstraint];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.coverImageView];
    
    [self.coverImageView addSubview:self.onlineBgView];
    [self.coverImageView addSubview:self.voiceImageView];
    [self.coverImageView addSubview:self.onlineLabel];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lockImageView];
    [self.contentView addSubview:self.tagImageView];
}

- (void)updateConstraint {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.coverImageView.mas_width);
    }];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.coverImageView);
        make.center.mas_equalTo(self.coverImageView);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.coverImageView).offset(6);
        make.width.mas_equalTo(34).priorityLow();
        make.width.mas_equalTo(67);
        make.height.mas_equalTo(15);
    }];
    
    [self.onlineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(16);
    }];
    
    [self.voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.onlineBgView.mas_left).offset(6);
        make.centerY.mas_equalTo(self.onlineBgView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(8);
    }] ;
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voiceImageView.mas_right).offset(4);
        make.right.mas_equalTo(self.onlineBgView.mas_right).offset(-6);
        make.centerY.mas_equalTo(self.voiceImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(8);
        make.left.right.mas_equalTo(self.contentView).inset(4);
    }];
}

#pragma mark - Getter Setter
- (void)setModel:(TTHomeV4DetailData *)model {
    _model = model;
    
    self.nameLabel.hidden = model == nil;
    self.onlineLabel.hidden = model == nil;
    self.onlineBgView.hidden = model == nil;
    self.voiceImageView.hidden = model == nil;
    self.tagImageView.hidden = model == nil;
    self.lockImageView.hidden = model == nil || model.roomPwd.length == 0;
    
    //角标优先展示半小时榜，其次皇帝推荐，再次下发图片，最后不显示
    if (self.showRankMark) {//半小时榜
        self.tagImageView.image = [UIImage imageNamed:@"home_half_hour_rank"];
    } else if (model.isRecom) {//皇帝推荐
        self.tagImageView.image = [UIImage imageNamed:@"home_emperor"];
    } else if (model.badge.length > 0) {//下发图片
        [self.tagImageView sd_setImageWithURL:[NSURL URLWithString:model.badge] placeholderImage:nil];
    } else {
        [self.tagImageView sd_setImageWithURL:nil placeholderImage:nil];
        self.tagImageView.image = nil;
    }
    
    self.nameLabel.text = model.title;
    if (model) {
        [self.coverImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];
    }else{
        [self.coverImageView qn_setImageImageWithUrl:model.avatar placeholderImage:@"home_room_placeholder" type:ImageTypeHomePageItem];
    }
    
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld人在线", (long)model.onlineNum];
    
    if (model) {
        [self.voiceImageView startAnimation];
    } else {
        [self.voiceImageView stopAnimation];
    }
}

- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@"home_room_placeholder"];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = 16;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIImageView *)tagImageView {
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.image = [UIImage imageNamed:@"home_emperor"];
    }
    return _tagImageView;
}

- (UIImageView *)lockImageView {
    if (_lockImageView == nil) {
        _lockImageView = [[UIImageView alloc] init];
        _lockImageView.image = [UIImage imageNamed:@"home_room_lock_big"];
    }
    return _lockImageView;
}

- (LXSEQView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[LXSEQView alloc] init];
        _voiceImageView.pillarWidth = 2;
        _voiceImageView.pillarColor = UIColorFromRGB(0xFFFFFF);
    }
    return _voiceImageView;
}

- (UILabel *)onlineLabel {
    if (_onlineLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xf5f5f5);
        label.font = [UIFont systemFontOfSize:10];
        label.text = @"0人在线";
        _onlineLabel = label;
    }
    return _onlineLabel;
}

- (UIView *)onlineBgView {
    if (_onlineBgView == nil) {
        _onlineBgView = [[UIView alloc] init];
        _onlineBgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        _onlineBgView.layer.cornerRadius = 8;
        _onlineBgView.layer.masksToBounds = YES;
    }
    return _onlineBgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 2;
        
        _nameLabel = label;
    }
    return _nameLabel;
}

@end
